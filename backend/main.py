from fastapi import FastAPI
from pymongo import MongoClient
from dotenv import load_dotenv
from models.user_model import User
from routes import user_routes, sensor_routes, recommendation_routes
from routes.crop_routes import router as crop_router
from fastapi.middleware.cors import CORSMiddleware
import os

load_dotenv()

app = FastAPI()
# Allow frontend connection
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For testing, allows all — later you can specify your Flutter app URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MongoDB connection
try:
    MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
    client = MongoClient(MONGO_URI)
    db = client["smartfarm"]
    print("✅ MongoDB connected successfully!")
except Exception as e:
    print("MongoDB connection failed:", e)


@app.get("/api/health")
def health_check():
    return {"status": "OK", "message": "Server is running fine ✅"}

@app.get("/")
def root():
    return {"message": "🌾 SmartFarm FastAPI backend running"}

# Register routers
app.include_router(user_routes.router)
app.include_router(sensor_routes.router)
app.include_router(recommendation_routes.router, prefix="/api")
app.include_router(crop_router, prefix="/api/recommend")
