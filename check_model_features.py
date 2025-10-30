import pickle

# Load your model (relative to backend folder)
model = pickle.load(open("models/crop_model.pkl", "rb"))

# Print feature names used during training
if hasattr(model, "feature_names_in_"):
    print("✅ Model feature names:")
    print(model.feature_names_in_)
else:
    print("⚠️ Model doesn't have feature_names_in_ attribute.")
