import numpy as np
import pickle
import os


# Load the trained model
with open("models/crop_model.pkl", "rb") as f:
    model = pickle.load(f)

def predict_crop(data):
    features = np.array([[data.nitrogen, data.phosphorus, data.potassium, data.soil_moisture, data.temperature]])
    crop_prediction = model.predict(features)[0]

    return {
        "recommended_crop": crop_prediction,
        "confidence": 0.85,
        "soil_health_score": round((data.nitrogen + data.phosphorus + data.potassium) / 3, 2)
    }
