from datetime import datetime, timedelta, timezone
from uuid import UUID
import hashlib
import hmac
import secrets
import jwt
from pwdlib import PasswordHash

from app.config import settings


password_hash = PasswordHash.recommended()


def hash_password(password: str) -> str:
    return password_hash.hash(password)


def verify_password(
    plain_password: str,
    hashed_password: str,
) -> bool:
    return password_hash.verify(
        plain_password,
        hashed_password,
    )


def create_access_token(
    user_id: UUID,
    role: str,
) -> str:
    expires_at = datetime.now(timezone.utc) + timedelta(
        minutes=settings.access_token_expire_minutes
    )

    payload = {
        "sub": str(user_id),
        "role": role,
        "exp": expires_at,
        "type": "access",
    }

    return jwt.encode(
        payload,
        settings.jwt_secret_key,
        algorithm=settings.jwt_algorithm,
    )


def decode_access_token(token: str) -> dict:
    return jwt.decode(
        token,
        settings.jwt_secret_key,
        algorithms=[settings.jwt_algorithm],
    )
def generate_otp() -> str:
    return f"{secrets.randbelow(900000) + 100000}"


def hash_otp(
    phone_number: str,
    otp: str,
) -> str:
    message = f"{phone_number}:{otp}".encode()

    return hmac.new(
        settings.jwt_secret_key.encode(),
        message,
        hashlib.sha256,
    ).hexdigest()


def verify_otp_hash(
    phone_number: str,
    otp: str,
    stored_hash: str,
) -> bool:
    expected_hash = hash_otp(
        phone_number,
        otp,
    )

    return hmac.compare_digest(
        expected_hash,
        stored_hash,
    )
def create_fisher_onboarding_token(
    phone_number: str,
) -> str:
    expires_at = datetime.now(timezone.utc) + timedelta(
        minutes=15
    )

    payload = {
        "sub": phone_number,
        "type": "fisher_onboarding",
        "exp": expires_at,
    }

    return jwt.encode(
        payload,
        settings.jwt_secret_key,
        algorithm=settings.jwt_algorithm,
    )
def decode_fisher_onboarding_token(
    token: str,
) -> dict:
    payload = jwt.decode(
        token,
        settings.jwt_secret_key,
        algorithms=[settings.jwt_algorithm],
    )

    if payload.get("type") != "fisher_onboarding":
        raise jwt.InvalidTokenError(
            "Invalid onboarding token."
        )

    return payload