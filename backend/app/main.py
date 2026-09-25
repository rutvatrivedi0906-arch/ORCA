from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from fastapi import Depends

from app.api.dependencies import require_roles
from app.models.user import User
from app.database import engine
from app.api.routes.auth import router as auth_router
app = FastAPI(
    title="ORCA Marine Intelligence API",
    description=(
        "Backend service for the ORCA Agentic Marine Intelligence Platform."
    ),
    version="0.1.0",
)
app.include_router(auth_router)

# Development CORS configuration.
# We will tighten this when the web dashboard is deployed.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {
        "application": "ORCA",
        "full_name": "Marine Intelligence Platform",
        "version": "0.1.0",
        "status": "running",
    }


@app.get("/api/v1/health")
def health():
    return {
        "status": "healthy",
        "service": "orca-backend",
        "version": "0.1.0",
    }


@app.get("/api/v1/meta/roles")
def get_roles():
    return {
        "roles": [
            {
                "code": "FISHERMAN",
                "name": "Fisherman",
                "interface": "mobile",
            },
            {
                "code": "RESEARCHER",
                "name": "Marine Researcher",
                "interface": "web",
            },
            {
                "code": "AUTHORITY",
                "name": "Coastal Authority",
                "interface": "web",
            },
            {
                "code": "ADMIN",
                "name": "Administrator",
                "interface": "web",
            },
        ]
    }
@app.get("/api/v1/database/health")
def database_health():
    try:
        with engine.connect() as connection:
            database_name = connection.execute(
                text("SELECT current_database();")
            ).scalar_one()

            database_user = connection.execute(
                text("SELECT current_user;")
            ).scalar_one()

            postgis_version = connection.execute(
                text("SELECT PostGIS_Version();")
            ).scalar_one()

        return {
            "status": "healthy",
            "database": database_name,
            "user": database_user,
            "postgis": postgis_version,
        }

    except SQLAlchemyError:
        return {
            "status": "unhealthy",
            "database": "connection_failed",
        }
@app.get("/api/v1/test/fisherman")
def fisherman_test(
    current_user: User = Depends(
        require_roles("FISHERMAN")
    ),
):
    return {
        "message": "Fisherman access granted.",
        "user": current_user.email,
    }


@app.get("/api/v1/test/researcher")
def researcher_test(
    current_user: User = Depends(
        require_roles("RESEARCHER")
    ),
):
    return {
        "message": "Researcher access granted.",
        "user": current_user.email,
    }


@app.get("/api/v1/test/authority")
def authority_test(
    current_user: User = Depends(
        require_roles("AUTHORITY", "ADMIN")
    ),
):
    return {
        "message": "Authority access granted.",
        "user": current_user.email,
    }