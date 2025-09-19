# File implements JWT authentication and bcrypt password hashing

import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials
from fastapi import Header
from fastapi import HTTPException

#Firebase admin initialization
firecredentials = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(firecredentials)

def verify_firetoken(authorization: str = Header(None)):
    if not authorization or " " not in authorization:
        raise HTTPException(status_code=401, detail= "This is missing the HTTP authorization header")
    parts = authorization.split(" ", 1)
    scheme, token = parts
    if scheme.lower() != "bearer":
        raise HTTPException(status_code=401, detail = "This is an invalid authorize scheme")
    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except Exception as e:
        raise HTTPException(status_code=401, detail=f"This is an invalid token: {e}")

