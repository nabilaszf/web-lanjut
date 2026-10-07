from fastapi import APIRouter, Depends, status
from sqlmodel import Session
from app.database import get_session
from app.models.product_model import ProductCreate
from app.services.product_service import product_service

router = APIRouter(prefix="/api/products", tags=["Products"])

@router.get("")
def get_products(session: Session = Depends(get_session)):
    products = product_service.get_all_products(session)
    return {"data": products}

@router.post("", status_code=status.HTTP_201_CREATED)
def create_product(product: ProductCreate, session: Session = Depends(get_session)):
    new_product = product_service.create_product(session, product)
    return {"data": new_product}