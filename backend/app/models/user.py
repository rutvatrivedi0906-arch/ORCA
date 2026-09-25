from datetime import datetime
from uuid import UUID, uuid4

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    DateTime,
    String,
    func,
)
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class User(Base):
    __tablename__ = "users"

    __table_args__ = (
        CheckConstraint(
            "role IN ('FISHERMAN', 'RESEARCHER', 'AUTHORITY', 'ADMIN')",
            name="ck_users_role",
        ),
        CheckConstraint(
            "auth_method IN ('PHONE_OTP', 'PASSWORD')",
            name="ck_users_auth_method",
        ),
    )

    id: Mapped[UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid4,
    )

    full_name: Mapped[str] = mapped_column(
        String(120),
        nullable=False,
    )

    # Researcher / Authority / Admin
    email: Mapped[str | None] = mapped_column(
        String(320),
        nullable=True,
        unique=True,
        index=True,
    )

    # Fisherman primary login
    phone_number: Mapped[str | None] = mapped_column(
        String(20),
        nullable=True,
        unique=True,
        index=True,
    )

    phone_verified: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        default=False,
        server_default="false",
    )

    # Fisherman platform identifier
    fisher_id: Mapped[str | None] = mapped_column(
        String(40),
        nullable=True,
        unique=True,
        index=True,
    )

    # Not required for PHONE_OTP users
    password_hash: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )

    auth_method: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        default="PASSWORD",
        server_default="PASSWORD",
    )

    role: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
    )

    preferred_language: Mapped[str] = mapped_column(
        String(10),
        nullable=False,
        default="en",
        server_default="en",
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        default=True,
        server_default="true",
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )