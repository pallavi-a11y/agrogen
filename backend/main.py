import os,sys
sys.path.append(os.path.dirname(__file__))
import io
import numpy as np
from fastapi import FastAPI, UploadFile, File, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from PIL import Image
from auth.auth_bearer import JWTBearer  # ✅ keep your existing JWT auth

# ======================================================
# ✅ FASTAPI INITIALIZATION
# ======================================================

app = FastAPI(
    title="SmartFarm - Crop Disease Detection 🌿",
    description="Detect plant leaf diseases and get treatment recommendations",
    version="2.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ======================================================
# ✅ LOAD TRAINED MODEL
# ======================================================
MODEL_PATH = r"C:\Users\papna\OneDrive\Desktop\smartfarm-backend\backend\models\disease_model.h5"
model = load_model(MODEL_PATH)

# ✅ Class labels from your training data
CLASS_LABELS = [
    'Apple___Apple_scab', 'Apple___Black_rot', 'Apple___Cedar_apple_rust', 'Apple___healthy',
    'Blueberry___healthy', 'Cherry_(including_sour)___Powdery_mildew', 'Cherry_(including_sour)___healthy',
    'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot', 'Corn_(maize)___Common_rust_',
    'Corn_(maize)___Northern_Leaf_Blight', 'Corn_(maize)___healthy', 'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)', 'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)', 'Grape___healthy',
    'Orange___Haunglongbing_(Citrus_greening)', 'Peach___Bacterial_spot', 'Peach___healthy',
    'Pepper,_bell___Bacterial_spot', 'Pepper,_bell___healthy', 'Potato___Early_blight',
    'Potato___Late_blight', 'Potato___healthy', 'Raspberry___healthy', 'Soybean___healthy',
    'Squash___Powdery_mildew', 'Strawberry___Leaf_scorch', 'Strawberry___healthy',
    'Tomato___Bacterial_spot', 'Tomato___Early_blight', 'Tomato___Late_blight', 'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot', 'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot', 'Tomato___Tomato_Yellow_Leaf_Curl_Virus', 'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy'
]

# ======================================================
# ✅ DISEASE SOLUTIONS
# ======================================================
DISEASE_SOLUTIONS = {
    "Apple___Apple_scab": "Remove affected leaves and apply fungicide with captan or sulfur.",
    "Apple___Black_rot": "Prune infected branches and spray copper-based fungicide.",
    "Apple___Cedar_apple_rust": "Remove nearby juniper trees; apply mancozeb or myclobutanil sprays.",
    "Corn_(maize)___Common_rust_": "Use resistant hybrids and apply fungicide like azoxystrobin.",
    "Pepper,_bell___Bacterial_spot": "Avoid overhead watering and apply copper-based bactericides.",
    "Tomato___Early_blight": "Rotate crops and apply chlorothalonil or copper fungicide.",
    "Tomato___Late_blight": "Remove infected plants and spray with mancozeb or chlorothalonil.",
    "Potato___Late_blight": "Destroy infected tubers and use protective fungicides regularly.",
    "Grape___Black_rot": "Prune infected vines and use captan spray every 10–14 days.",
    "Orange___Haunglongbing_(Citrus_greening)": "Remove infected trees; control psyllid insects with insecticides."
}

# ======================================================
# ✅ DISEASE PREDICTION ENDPOINT
# ======================================================
@app.post("/predict_disease")
async def predict_disease_api(file: UploadFile = File(...)):
    try:
        # Read uploaded image
        contents = await file.read()
        img = Image.open(io.BytesIO(contents)).convert("RGB")
        img = img.resize((128, 128))
        img_array = np.array(img) / 255.0  # ✅ same normalization as training
        img_array = np.expand_dims(img_array, axis=0)

        # Predict
        predictions = model.predict(img_array)
        predicted_class_index = np.argmax(predictions[0])
        confidence = float(np.max(predictions[0]) * 100)
        disease = CLASS_LABELS[predicted_class_index]

        # Get treatment recommendation
        recommendation = DISEASE_SOLUTIONS.get(disease, "No specific treatment found. Consult an agronomist.")

        return JSONResponse({
            "disease": disease,
            "confidence": f"{confidence:.2f}%",
            "recommendation": recommendation
        })

    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)


@app.get("/")
def home():
    return {"message": "🌿 SmartFarm Disease Detection API Running!"}


# ======================================================
# ✅ ENTRY POINT
# ======================================================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
