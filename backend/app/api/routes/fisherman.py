from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.api.dependencies import get_current_user
from app.database import get_db
from app.models.fisherman_profile import FishermanProfile
from app.models.user import User
from app.models.vessel import Vessel
from app.schemas.fisherman import (
    FishermanProfileResponse,
    FishermanProfileUpdateRequest,
    VesselCreateRequest,
    VesselResponse,
    VesselUpdateRequest,
)

router = APIRouter(
    prefix="/api/v1/fisherman",
    tags=["Fisherman"],
)


def _require_fisherman(current_user: User) -> None:
    if current_user.role != "FISHERMAN":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Fisherman access required.",
        )


def _get_or_create_profile(db: Session, user_id: UUID) -> FishermanProfile:
    profile = db.scalar(
        select(FishermanProfile).where(
            FishermanProfile.user_id == user_id
        )
    )

    if profile is None:
        profile = FishermanProfile(user_id=user_id)
        db.add(profile)
        db.commit()
        db.refresh(profile)

    return profile


def _profile_response(
    user: User,
    profile: FishermanProfile,
) -> FishermanProfileResponse:
    return FishermanProfileResponse(
        user_id=user.id,
        full_name=user.full_name,
        phone_number=user.phone_number,
        phone_verified=user.phone_verified,
        fisher_id=user.fisher_id,
        preferred_language=user.preferred_language,
        home_landing_centre=profile.home_landing_centre,
        emergency_contact_name=profile.emergency_contact_name,
        emergency_contact_phone=profile.emergency_contact_phone,
    )


def _clean_optional_text(value: str | None) -> str | None:
    if value is None:
        return None
    value = value.strip()
    return value or None


@router.get(
    "/profile",
    response_model=FishermanProfileResponse,
)
def get_fisherman_profile(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _require_fisherman(current_user)
    profile = _get_or_create_profile(db, current_user.id)
    return _profile_response(current_user, profile)


@router.patch(
    "/profile",
    response_model=FishermanProfileResponse,
)
def update_fisherman_profile(
    data: FishermanProfileUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _require_fisherman(current_user)
    profile = _get_or_create_profile(db, current_user.id)
    payload = data.model_dump(exclude_unset=True)

    if "full_name" in payload:
        current_user.full_name = payload["full_name"].strip()

    if "preferred_language" in payload:
        current_user.preferred_language = (
            payload["preferred_language"].strip().lower()
        )

    if "home_landing_centre" in payload:
        profile.home_landing_centre = _clean_optional_text(
            payload["home_landing_centre"]
        )

    if "emergency_contact_name" in payload:
        profile.emergency_contact_name = _clean_optional_text(
            payload["emergency_contact_name"]
        )

    if "emergency_contact_phone" in payload:
        profile.emergency_contact_phone = _clean_optional_text(
            payload["emergency_contact_phone"]
        )

    db.commit()
    db.refresh(current_user)
    db.refresh(profile)
    return _profile_response(current_user, profile)


@router.get(
    "/vessels",
    response_model=list[VesselResponse],
)
def list_vessels(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _require_fisherman(current_user)

    return list(
        db.scalars(
            select(Vessel)
            .where(Vessel.owner_id == current_user.id)
            .order_by(Vessel.created_at.desc())
        ).all()
    )


@router.post(
    "/vessels",
    response_model=VesselResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_vessel(
    data: VesselCreateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _require_fisherman(current_user)

    vessel = Vessel(
        owner_id=current_user.id,
        name=data.name.strip(),
        registration_number=_clean_optional_text(
            data.registration_number
        ),
        vessel_type=_clean_optional_text(data.vessel_type),
        length_m=data.length_m,
        beam_m=data.beam_m,
        cruising_speed_knots=data.cruising_speed_knots,
        persons_onboard_default=data.persons_onboard_default,
    )

    db.add(vessel)

    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=(
                "A vessel with this registration number "
                "already exists."
            ),
        )

    db.refresh(vessel)
    return vessel


def _get_owned_vessel(
    db: Session,
    vessel_id: UUID,
    owner_id: UUID,
) -> Vessel:
    vessel = db.scalar(
        select(Vessel).where(
            Vessel.id == vessel_id,
            Vessel.owner_id == owner_id,
        )
    )

    if vessel is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Vessel not found.",
        )

    return vessel


@router.get(
    "/vessels/{vessel_id}",
    response_model=VesselResponse,
)
def get_vessel(
    vessel_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _require_fisherman(current_user)
    return _get_owned_vessel(db, vessel_id, current_user.id)


@router.patch(
    "/vessels/{vessel_id}",
    response_model=VesselResponse,
)
def update_vessel(
    vessel_id: UUID,
    data: VesselUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _require_fisherman(current_user)
    vessel = _get_owned_vessel(db, vessel_id, current_user.id)
    payload = data.model_dump(exclude_unset=True)

    for field in ("name", "registration_number", "vessel_type"):
        if field in payload:
            value = payload[field]
            if field == "name":
                setattr(vessel, field, value.strip())
            else:
                setattr(vessel, field, _clean_optional_text(value))

    for field in (
        "length_m",
        "beam_m",
        "cruising_speed_knots",
        "persons_onboard_default",
    ):
        if field in payload:
            setattr(vessel, field, payload[field])

    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=(
                "A vessel with this registration number "
                "already exists."
            ),
        )

    db.refresh(vessel)
    return vessel


@router.delete(
    "/vessels/{vessel_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_vessel(
    vessel_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _require_fisherman(current_user)
    vessel = _get_owned_vessel(db, vessel_id, current_user.id)
    db.delete(vessel)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
