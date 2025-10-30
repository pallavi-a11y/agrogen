import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
import pickle
import os

# Sample dataset (you can replace with real IoT or soil data later)
data = {
    'N': [90, 45, 60, 75, 120, 30, 50, 80],
    'P': [42, 35, 25, 50, 20, 10, 15, 40],
    'K': [43, 30, 50, 55, 60, 25, 45, 35],
    'temperature': [26, 22, 30, 28, 35, 18, 21, 29],
    'humidity': [80, 65, 90, 70, 55, 60, 75, 68],
    'ph': [6.5, 7.0, 6.8, 5.8, 7.2, 6.0, 5.5, 6.7],
    'soil_moisture': [40, 50, 35, 45, 55, 30, 60, 48],
    'label': ['Rice', 'Wheat', 'Millet', 'Maize', 'Cotton', 'Millet', 'Rice', 'Wheat']
}

# Convert to DataFrame
df = pd.DataFrame(data)

# Features and labels
X = df[['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'soil_moisture']]
y = df['label']

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train a Random Forest model
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluate accuracy
acc = model.score(X_test, y_test)
print(f"✅ Model trained successfully! Accuracy: {acc:.2f}")

# Save the model
os.makedirs("models", exist_ok=True)
with open("models/crop_model.pkl", "wb") as f:
    pickle.dump(model, f)

print("💾 Model saved at: models/crop_model.pkl")
