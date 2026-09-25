from pydantic import BaseModel, Field


class BoundaryZone(BaseModel):
    id: str
    name: str
    category: str
    is_demo: bool = True
    coordinates: list[list[float]]
    note: str


class MaritimeZoneAssessment(BaseModel):
    label: str
    status: str
    zone_name: str | None = None
    distance_to_limit_km: float | None = None
    distance_label: str | None = None
    source: str
    source_note: str


class BoundaryCheckResponse(BaseModel):
    latitude: float
    longitude: float

    surface: str
    status: str

    coast_distance_km: float | None = None
    coast_distance_note: str | None = None

    territorial_sea: MaritimeZoneAssessment | None = None
    eez: MaritimeZoneAssessment | None = None

    nearest_zone_id: str | None = None
    nearest_zone_name: str | None = None
    distance_to_zone_km: float | None = None
    inside_zone: bool = False
    message: str

    land_mask_note: str = (
        "Land/water classification uses the global-land-mask GLOBE dataset "
        "at approximately 1 km resolution. Coastline-edge results can be approximate."
    )
    maritime_boundary_note: str = (
        "Territorial-sea and EEZ jurisdiction checks use Marine Regions reference "
        "datasets when the WFS service is available. These are reference GIS layers, "
        "not a substitute for current official nautical charts or legal advice."
    )
    restricted_area_note: str = (
        "The red restricted/protected polygons in the current ORCA demo are synthetic "
        "hackathon geofences. An official protected/restricted-area layer has not yet "
        "been loaded."
    )
    temporary_hazard_note: str = (
        "Temporary environmental conditions are evaluated separately using ORCA's "
        "live marine-conditions adapter. Official INCOIS/IMD warnings take priority."
    )
    is_demo_boundary_data: bool = True


class RoutePlanRequest(BaseModel):
    start_latitude: float = Field(ge=-90, le=90)
    start_longitude: float = Field(ge=-180, le=180)
    end_latitude: float = Field(ge=-90, le=90)
    end_longitude: float = Field(ge=-180, le=180)
    cruising_speed_knots: float = Field(gt=0, le=80)


class RouteCondition(BaseModel):
    wave_height_m: float | None = None
    wave_direction_deg: float | None = None
    wave_period_s: float | None = None
    wind_speed_ms: float | None = None
    wind_direction_deg: float | None = None
    wind_gust_ms: float | None = None
    current_velocity_ms: float | None = None
    current_direction_deg: float | None = None


class RouteWaypoint(BaseModel):
    latitude: float
    longitude: float
    sequence: int
    condition: RouteCondition


class RouteAlternative(BaseModel):
    route_id: str
    title: str
    distance_nm: float
    eta_minutes: float
    exposure_score: float
    max_wave_height_m: float | None = None
    max_wind_speed_ms: float | None = None
    max_wind_gust_ms: float | None = None
    average_current_ms: float | None = None
    route_status: str
    route_message: str
    rationale: list[str]
    waypoints: list[RouteWaypoint]


class RoutePlanResponse(BaseModel):
    start_surface: str
    end_surface: str
    fastest: RouteAlternative
    lower_exposure: RouteAlternative
    data_source: str
    data_freshness: str
    model_note: str
    demo_boundary_note: str
    navigation_notice: str = (
        "Prototype decision-support route. It does not replace official nautical "
        "charts, Notices to Mariners, INCOIS/IMD advisories, COLREGS, local port "
        "instructions, or a qualified navigator's judgment."
    )
