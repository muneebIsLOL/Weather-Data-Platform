from fastapi import Header, HTTPException
from dotenv import load_dotenv
import os

load_dotenv()

def login(token: str = Header(None)):
    auth_token = os.getenv("AUTH_ACCESS_TOKEN")
    if token != auth_token:
        raise HTTPException(403, "Invalid Token")
    
    return None