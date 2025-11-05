from fastapi import APIRouter, HTTPException, Depends
from passlib.hash import bcrypt
from database import db
from models.user_model import User
from auth.auth_handler import create_access_token
from bson import ObjectId

router = APIRouter()

@router.post("/register")
async def register_user(user: User):
    existing = await db.users.find_one({"email": user.email})
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    user.password = bcrypt.hash(user.password)
    user_dict = user.dict()
    result = await db.users.insert_one(user_dict)
    return {"message": "User registered successfully", "user_id": str(result.inserted_id)}

@router.post("/login")
async def login_user(credentials: dict):
    user = await db.users.find_one({"email": credentials["email"]})
    if not user or not bcrypt.verify(credentials["password"], user["password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    token = create_access_token({"sub": user["email"]})
    return {"access_token": token, "token_type": "bearer"}
