from datetime import datetime
from decimal import Decimal
from uuid import UUID, uuid4

from sqlalchemy import (
    CheckConstraint,
    DateTime,
    ForeignKey,
    Integer,
    Numeric,
    String,
    func,
)
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Vessel(Base):
    __tablename__ = "vessels"

    __table_args__ = (
        CheckConstraint(
            "length_m IS NULL OR length_m > 0",
            name="ck_vessels_length_positive",
        ),
        CheckConstraint(
            "beam_m IS NULL OR beam_m > 0",
            name="ck_vessels_beam_positive",
        ),
        CheckConstraint(
            "cruising_speed_knots IS NULL OR cruising_speed_knots > 0",
            name="ck_vessels_speed_positive",
        ),
        CheckConstraint(
            "persons_onboard_default > 0",
            name="ck_vessels_persons_positive",
        ),
    )

    id: Mapped[UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid4,
    )

    owner_id: Mapped[UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    name: Mapped[str] = mapped_column(
        String(120),
        nullable=False,
    )

    registration_number: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
        unique=True,
    )

    vessel_type: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
    )

    length_m: Mapped[Decimal | None] = mapped_column(
        Numeric(6, 2),
        nullable=True,
    )

    beam_m: Mapped[Decimal | None] = mapped_column(
        Numeric(6, 2),
        nullable=True,
    )

    cruising_speed_knots: Mapped[Decimal | None] = mapped_column(
        Numeric(6, 2),
        nullable=True,
    )

    persons_onboard_default: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=1,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )