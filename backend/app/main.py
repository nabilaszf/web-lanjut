from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import create_db_and_tables
from app.routers import product

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Membuat file database dan tabel otomatis saat server menyala
    create_db_and_tables()
    yield

app = FastAPI(title="Backend FastAPI SQLite", lifespan=lifespan)

# Konfigurasi CORS agar frontend Flutter bisa mengakses API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(product.router)

@app.get("/")
def root():
    return {"message": "Server FastAPI Berhasil Dijalankan dengan SQLite!"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)