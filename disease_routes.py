from fastapi import APIRouter, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
import shutil
import os
from pathlib import Path
import numpy as np
from PIL import Image
import io

router = APIRouter()

# Create uploads directory if it doesn't exist
UPLOAD_DIR = Path("uploads")
UPLOAD_DIR.mkdir(exist_ok=True)

@router.post("/api/disease-detection")
async def detect_disease(file: UploadFile = File(...)):
    """
    Endpoint to detect crop diseases from uploaded images.
    """
    try:
        # Validate file type
        if not file.content_type.startswith('image/'):
            raise HTTPException(status_code=400, detail="File must be an image")

        # Save uploaded file
        file_path = UPLOAD_DIR / file.filename
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        # TODO: Implement actual disease detection model
        # For now, return mock results
        mock_diseases = [
            "Healthy Plant - No disease detected",
            "Leaf Blight detected - Early stage",
            "Powdery Mildew detected - Moderate infection",
            "Rust Disease detected - Advanced stage",
            "Bacterial Spot detected - Contagious"
        ]

        # Simulate processing time
        import time
        time.sleep(1)

        # Mock prediction (in real implementation, load ML model here)
        detected_disease = np.random.choice(mock_diseases)

        # Clean up uploaded file
        os.remove(file_path)

        return {
            "success": True,
            "disease": detected_disease,
            "confidence": round(np.random.uniform(0.75, 0.95), 2),
            "recommendations": [
                "Isolate affected plants",
                "Apply appropriate fungicide",
                "Improve air circulation",
                "Monitor soil moisture levels"
            ]
        }

    except Exception as e:
        # Clean up file if it exists
        if 'file_path' in locals() and file_path.exists():
            os.remove(file_path)
        raise HTTPException(status_code=500, detail=f"Error processing image: {str(e)}")
