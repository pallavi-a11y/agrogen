from fastapi import APIRouter
from models.sensor_model import SensorData
from database import db

router = APIRouter()

@router.post("/api/sensors/data")
def add_sensor_data(data: SensorData):
    db.sensor_data.insert_one(data.dict())
    return {"message": "Sensor data added successfully"}
