from uuid import UUID


def generate_fisher_id(user_id: UUID) -> str:
    short_id = user_id.hex[:12].upper()

    return f"ORCA-F-{short_id}"