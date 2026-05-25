from django.core.exceptions import ValidationError as DjangoValidationError
from rest_framework.views import exception_handler
from rest_framework.exceptions import ValidationError

def _get_error_message(exc) -> str:
    if isinstance(exc, ValidationError):
        if isinstance(exc.detail, dict) and "detail" in exc.detail:
            val = exc.detail["detail"]
            return str(val[0] if isinstance(val, list) and val else val)
        if isinstance(exc.detail, list) and exc.detail:
            return str(exc.detail[0])
        return "Validation failed"

    if hasattr(exc, "detail"):
        if isinstance(exc.detail, dict) and "detail" in exc.detail:
            return str(exc.detail["detail"])
        if isinstance(exc.detail, str):
            return exc.detail
        if isinstance(exc.detail, list) and exc.detail:
            return str(exc.detail[0])

    return "An error occurred."

def custom_exception_handler(exc, context):
    if isinstance(exc, DjangoValidationError):
        detail = exc.message_dict if hasattr(exc, "message_dict") else exc.messages
        exc = ValidationError(detail)

    response = exception_handler(exc, context)
    if response is None:
        return None

    message = _get_error_message(exc)
    response.data = {
        "success": False,
        "error": {
            "status_code": response.status_code,
            "message": message,
            "details": response.data,
        },
    }
    return response
