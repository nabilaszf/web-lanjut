from sqlmodel import Session, select
from app.models.product_model import Product, ProductCreate

class ProductService:
    def get_all_products(self, session: Session):
        statement = select(Product)
        results = session.exec(statement).all()
        return results

    def create_product(self, session: Session, data: ProductCreate):
        db_product = Product.model_validate(data)
        session.add(db_product)
        session.commit()
        session.refresh(db_product)
        return db_product

product_service = ProductService()