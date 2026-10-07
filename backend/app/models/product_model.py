from typing import Optional
from sqlmodel import SQLModel, Field

# Tabel database utama
class Product(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    price: int

# Schema input untuk request POST (tanpa ID)
class ProductCreate(SQLModel):
    name: str
    price: int