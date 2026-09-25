from sqlalchemy import create_engine
from sqlalchemy.engine import URL
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from app.config import settings


# Build the PostgreSQL connection URL safely.
# URL.create() correctly handles special characters such as @ in passwords.
database_url = URL.create(
    drivername="postgresql+psycopg",
    username=settings.db_user,
    password=settings.db_password,
    host=settings.db_host,
    port=settings.db_port,
    database=settings.db_name,
)


# Main SQLAlchemy database engine.
engine = create_engine(
    database_url,
    pool_pre_ping=True,
)


# Creates database sessions for API requests.
SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
)


# Base class used by all SQLAlchemy models.
class Base(DeclarativeBase):
    pass


# FastAPI dependency for database sessions.
def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()