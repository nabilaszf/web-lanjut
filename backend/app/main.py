from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.database import create_db_and_tables
from app.routers import product

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Membuat file database dan tabel otomatis saat server menyala
    create_db_and_tables()
    yield

app = FastAPI(title="Backend FastAPI SQLite", lifespan=lifespan)

app.include_router(product.router)

@app.get("/")
def root():
    return {"message": "Server FastAPI Berhasil Dijalankan dengan SQLite!"}