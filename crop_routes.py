from fastapi import APIRouter, Depends, HTTPException
from auth.auth_bearer import JWTBearer
from models.crop_model import CropRequest   # ✅ Fixed import
from services.recommendation_service import get_crop_recommendation

router = APIRouter(prefix="/crop", tags=["Crop Recommendation"])

@router.post("/recommend", dependencies=[Depends(JWTBearer())])
async def recommend_crop(data: CropRequest):
    """
    Protected route that recommends the best crop based on soil and weather parameters.
    """
    try:
        result = get_crop_recommendation(data)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
