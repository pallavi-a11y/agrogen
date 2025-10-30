from pydantic import BaseModel, EmailStr
from typing import Optional

class User(BaseModel):
    id: Optional[str]
    name: str
    email: EmailStr
    password: str

class SensorData(BaseModel):
    temperature: float
    humidity: float
    soil_moisture: float
    nitrogen: float
    phosphorus: float
    potassium: float

class CropRecommendation(BaseModel):
    crop_name: str
    confidence: float
    soil_health_score: float


class CropInput(BaseModel):
    nitrogen: float
    phosphorus: float
    potassium: float
    temperature: float
    humidity: float
    ph: float
    soil_moisture: float
    name: str
    unit: str
    soil_type: str
    notes: str
    latitude: float
    longitude: float
    area: float
