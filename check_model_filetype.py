import os

file_path = "models/crop_model.pkl"

if os.path.exists(file_path):
    with open(file_path, "rb") as f:
        first_bytes = f.read(20)
        print("First 20 bytes of file:", first_bytes)
else:
    print("File not found:", file_path)
