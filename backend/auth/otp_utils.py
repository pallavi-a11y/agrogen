import random
import time

# Temporary in-memory OTP store
otp_storage = {}

OTP_EXPIRY_SECONDS = 300  # 5 minutes
DEV_MODE = True            # ✅ Turn this ON for easy testing (auto-verifies OTP)
DEV_OTP = "123456"         # ✅ Static OTP for dev use

def generate_otp(identifier: str) -> str:
    """Generate and store a 6-digit OTP for the user (phone or email)."""
    if DEV_MODE:
        print(f"[DEV MODE] OTP for {identifier}: {DEV_OTP}")
        otp_storage[identifier] = {
            "otp": DEV_OTP,
            "timestamp": time.time()
        }
        return DEV_OTP
    
    otp = str(random.randint(100000, 999999))
    otp_storage[identifier] = {
        "otp": otp,
        "timestamp": time.time()
    }
    print(f"[DEBUG] OTP for {identifier}: {otp}")
    return otp


def verify_otp(identifier: str, user_otp: str) -> bool:
    """Check if the OTP is valid and not expired."""
    if DEV_MODE and user_otp == DEV_OTP:
        return True

    if identifier not in otp_storage:
        return False
    
    record = otp_storage[identifier]
    if time.time() - record["timestamp"] > OTP_EXPIRY_SECONDS:
        del otp_storage[identifier]
        return False
    
    if record["otp"] == user_otp:
        del otp_storage[identifier]
        return True
    
    return False
