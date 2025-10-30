from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import pandas as pd
from dotenv import load_dotenv
import joblib
from pymongo import MongoClient
import datetime
import os

router = APIRouter()

load_dotenv()
# Load model
model = joblib.load("models/crop_model.pkl")

# --- MongoDB Connection ---
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
client = MongoClient(MONGO_URI)
db = client["smartfarm"]
collection = db["recommendations"] 
predictions_collection = db["crop_predictions"]

# --- Input Schema ---
class CropInput(BaseModel):
    nitrogen: float
    phosphorus: float
    potassium: float
    temperature: float
    humidity: float
    soil_moisture: float
    ph: float
    name: str
    unit: str
    soil_type: str
    notes: str
    latitude: float
    longitude: float
    area: float


@router.post("/crop")
def recommend_crop(data: CropInput):
    try:
        # Prepare input data in correct column order
        input_data = pd.DataFrame([[
            data.nitrogen,
            data.phosphorus,
            data.potassium,
            data.temperature,
            data.humidity,
            data.ph,
            data.soil_moisture
        ]], columns=["N", "P", "K", "temperature", "humidity", "ph", "soil_moisture"])

        # Predict
        prediction = model.predict(input_data)[0]
        confidence = model.predict_proba(input_data).max() * 100

        # Save to MongoDB
        record = {
            "input": data.dict(),
            "recommended_crop": prediction,
            "confidence": round(confidence, 2),
            "timestamp": datetime.datetime.utcnow()
        }
        collection.insert_one(record)

        # Response
        return {
            "recommended_crop": prediction,
            "confidence": f"{round(confidence, 2)}%",
            "message": "Prediction successful and saved to MongoDB ✅"
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
