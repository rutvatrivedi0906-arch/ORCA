from getpass import getpass

from sqlalchemy import select

from app.core.security import hash_password
from app.database import SessionLocal
from app.models.user import User


ALLOWED_ROLES = {"AUTHORITY", "ADMIN"}


def main():
    print("ORCA privileged account provisioning")
    print("-----------------------------------")

    role = input("Role (AUTHORITY or ADMIN): ").strip().upper()
    if role not in ALLOWED_ROLES:
        raise SystemExit("Role must be AUTHORITY or ADMIN.")

    full_name = input("Full name: ").strip()
    email = input("Email: ").strip().lower()
    preferred_language = (
        input("Preferred language code [en]: ").strip().lower()
        or "en"
    )

    password = getpass("Password (minimum 8 characters): ")
    confirm = getpass("Confirm password: ")

    if len(full_name) < 2:
        raise SystemExit("Full name is too short.")
    if "@" not in email:
        raise SystemExit("Enter a valid email.")
    if len(password) < 8:
        raise SystemExit(
            "Password must contain at least 8 characters."
        )
    if password != confirm:
        raise SystemExit("Passwords do not match.")

    db = SessionLocal()

    try:
        existing = db.scalar(
            select(User).where(User.email == email)
        )

        if existing is not None:
            raise SystemExit(
                f"An account already exists for {email}."
            )

        user = User(
            full_name=full_name,
            email=email,
            password_hash=hash_password(password),
            role=role,
            auth_method="PASSWORD",
            preferred_language=preferred_language,
            is_active=True,
        )

        db.add(user)
        db.commit()
        db.refresh(user)

        print()
        print("Account created successfully.")
        print(f"Role: {user.role}")
        print(f"Email: {user.email}")
        print(f"User ID: {user.id}")

    finally:
        db.close()


if __name__ == "__main__":
    main()
