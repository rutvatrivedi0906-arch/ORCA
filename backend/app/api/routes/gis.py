from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.api.dependencies import get_current_user
from app.models.user import User
from app.schemas.gis import (
    BoundaryCheckResponse,
    BoundaryZone,
    RoutePlanRequest,
    RoutePlanResponse,
)
from app.services.gis_service import (
    check_boundary,
    list_zones,
    plan_weather_aware_route,
)


router = APIRouter(
    prefix="/api/v1/gis",
    tags=["GIS & Route"],
)


@router.get(
    "/zones",
    response_model=list[BoundaryZone],
)
def get_zones(
    current_user: User = Depends(get_current_user),
):
    del current_user
    return list_zones()


@router.get(
    "/boundary/check",
    response_model=BoundaryCheckResponse,
)
def boundary_check(
    latitude: float = Query(ge=-90, le=90),
    longitude: float = Query(ge=-180, le=180),
    current_user: User = Depends(get_current_user),
):
    del current_user
    return check_boundary(latitude, longitude)


@router.post(
    "/route/plan",
    response_model=RoutePlanResponse,
)
def route_plan(
    data: RoutePlanRequest,
    current_user: User = Depends(get_current_user),
):
    del current_user

    try:
        return plan_weather_aware_route(
            data.start_latitude,
            data.start_longitude,
            data.end_latitude,
            data.end_longitude,
            data.cruising_speed_knots,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=str(exc),
        ) from exc
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=(
                "Weather-aware route planning is temporarily unavailable. "
                "Check the backend internet connection and retry."
            ),
        ) from exc
