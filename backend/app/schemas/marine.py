from pydantic import BaseModel, Field


class MarineEvidence(BaseModel):
    source: str
    source_url: str
    model_time: str | None = None
    fetched_at: str
    freshness_label: str
    note: str | None = None


class MarineConditionsResponse(BaseModel):
    requested_latitude: float
    requested_longitude: float
    grid_latitude: float | None = None
    grid_longitude: float | None = None

    wave_height_m: float | None = None
    wave_direction_deg: float | None = None
    wave_period_s: float | None = None
    swell_height_m: float | None = None
    sea_surface_temperature_c: float | None = None
    ocean_current_velocity_ms: float | None = None
    ocean_current_direction_deg: float | None = None
    sea_level_height_msl_m: float | None = None

    wind_speed_ms: float | None = None
    wind_direction_deg: float | None = None
    wind_gust_ms: float | None = None

    screening_status: str
    screening_reason: str
    screening_is_prototype: bool = True

    evidence: list[MarineEvidence]
    official_india_reference: str = Field(
        default="INCOIS Ocean State Forecast (OSF)"
    )
    navigation_notice: str = Field(
        default=(
            "Development decision-support only. This does not replace "
            "official marine advisories, nautical charts, or authorized "
            "navigation/safety guidance."
        )
    )
