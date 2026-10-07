from typing import Optional
from sqlmodel import SQLModel, Field

# Tabel database utama
class Product(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    price: int

# Schema input untuk request POST (tanpa ID) - dengan validasi Pydantic via SQLModel
class ProductCreate(SQLModel):
    name: str = Field(min_length=1, max_length=100)
    price: int = Field(ge=0)