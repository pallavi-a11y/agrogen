from fastapi import Request, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from auth.auth_handler import decode_access_token

class JWTBearer(HTTPBearer):
    async def __call__(self, request: Request):
        credentials: HTTPAuthorizationCredentials = await super().__call__(request)
        if credentials:
            token = credentials.credentials
            if not decode_access_token(token):
                raise HTTPException(status_code=403, detail="Invalid or expired token.")
            return token
        else:
            raise HTTPException(status_code=403, detail="Invalid authorization header.")
