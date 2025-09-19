from fastapi import FastAPI, Depends
from app.authorize import verify_firetoken

app = FastAPI()

@app.get("/secure")
def secure_endpoint(user=Depends(verify_firetoken)):
    return {"uid": user["uid"], "email": user.get("email")}
