from decimal import Decimal
from uuid import UUID

from pydantic import BaseModel, Field


class FishermanProfileResponse(BaseModel):
    user_id: UUID
    full_name: str
    phone_number: str | None = None
    phone_verified: bool
    fisher_id: str | None = None
    preferred_language: str

    home_landing_centre: str | None = None
    emergency_contact_name: str | None = None
    emergency_contact_phone: str | None = None


class FishermanProfileUpdateRequest(BaseModel):
    full_name: str | None = Field(default=None, min_length=2, max_length=120)
    preferred_language: str | None = Field(default=None, min_length=2, max_length=10)
    home_landing_centre: str | None = Field(default=None, max_length=200)
    emergency_contact_name: str | None = Field(default=None, max_length=120)
    emergency_contact_phone: str | None = Field(default=None, max_length=30)


class VesselCreateRequest(BaseModel):
    name: str = Field(min_length=1, max_length=120)
    registration_number: str | None = Field(default=None, max_length=100)
    vessel_type: str | None = Field(default=None, max_length=100)
    length_m: Decimal | None = Field(default=None, gt=0, max_digits=6, decimal_places=2)
    beam_m: Decimal | None = Field(default=None, gt=0, max_digits=6, decimal_places=2)
    cruising_speed_knots: Decimal | None = Field(default=None, gt=0, max_digits=6, decimal_places=2)
    persons_onboard_default: int = Field(default=1, ge=1, le=200)


class VesselUpdateRequest(BaseModel):
    name: str | None = Field(default=None, min_length=1, max_length=120)
    registration_number: str | None = Field(default=None, max_length=100)
    vessel_type: str | None = Field(default=None, max_length=100)
    length_m: Decimal | None = Field(default=None, gt=0, max_digits=6, decimal_places=2)
    beam_m: Decimal | None = Field(default=None, gt=0, max_digits=6, decimal_places=2)
    cruising_speed_knots: Decimal | None = Field(default=None, gt=0, max_digits=6, decimal_places=2)
    persons_onboard_default: int | None = Field(default=None, ge=1, le=200)


class VesselResponse(BaseModel):
    id: UUID
    owner_id: UUID
    name: str
    registration_number: str | None = None
    vessel_type: str | None = None
    length_m: Decimal | None = None
    beam_m: Decimal | None = None
    cruising_speed_knots: Decimal | None = None
    persons_onboard_default: int

    model_config = {"from_attributes": True}
