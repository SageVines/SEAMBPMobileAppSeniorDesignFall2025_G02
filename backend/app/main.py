# FastAPI entrypoint (defines API endpoints)

from fastapi import FASTAPI

app = FASTAPI()

@app.get("/")
def home():
    return {"status": "Backend running on App Engine!"}