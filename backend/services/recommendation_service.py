import pandas as pd
import joblib
import os
import random

# Load the model
model_path = os.path.join(os.path.dirname(__file__), '..', 'models', 'crop_model.pkl')
model = joblib.load(model_path)

def get_crop_recommendation(data):
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

    # Get probabilities for all classes
    probabilities = model.predict_proba(input_data)[0]
    classes = model.classes_

    # Get top 3 recommendations
    top_indices = probabilities.argsort()[-3:][::-1]
    crops = []

    for i, idx in enumerate(top_indices):
        crop_name = classes[idx]
        match_percentage = round(probabilities[idx] * 100, 2)

        # Determine suitability based on match percentage
        if match_percentage >= 90:
            suitability = "Excellent Suitability"
        elif match_percentage >= 70:
            suitability = "Good Suitability"
        elif match_percentage >= 50:
            suitability = "Moderate Suitability"
        else:
            suitability = "Low Suitability"

        # Mock image path and conditions (in real implementation, this would come from a database or config)
        image_path = f"assets/{crop_name.lower()}.png"
        conditions = ["Sunny", "Well-drained soil", f"pH {data.ph - 0.5:.1f}-{data.ph + 0.5:.1f}"]

        crops.append({
            "name": crop_name,
            "suitability": suitability,
            "match_percentage": match_percentage,
            "image_path": image_path,
            "conditions": conditions,
            "is_current": i == 0  # First one is current recommendation
        })

    return {"crops": crops}
