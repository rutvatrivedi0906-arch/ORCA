import phonenumbers
from phonenumbers import NumberParseException


def normalize_indian_phone(phone_number: str) -> str:
    raw_phone = phone_number.strip()

    try:
        if raw_phone.startswith("+"):
            parsed = phonenumbers.parse(raw_phone, None)
        else:
            parsed = phonenumbers.parse(raw_phone, "IN")

    except NumberParseException as exc:
        raise ValueError("Invalid phone number.") from exc

    if not phonenumbers.is_valid_number(parsed):
        raise ValueError("Invalid phone number.")

    return phonenumbers.format_number(
        parsed,
        phonenumbers.PhoneNumberFormat.E164,
    )