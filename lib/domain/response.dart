/// Enumeration representing different types of responses.
enum ResponseType {
  /// Indicates an error response.
  error,

  /// Indicates a warning response.
  warning,

  /// Indicates a success response.
  success,
}

/// A class representing a response from an operation,
/// containing a type, message, and optional value.
class Response<T> {
  /// The type of the response.
  final ResponseType type;

  /// A message describing the response.
  final String message;

  /// An optional value associated with the response.
  final T? value;

  /// Constructs a [Response] instance with the given parameters.
  Response({
    required this.type,
    required this.message,
    required this.value,
  });

  Response.error(this.message) : type = ResponseType.error, value = null;
  Response.warning(this.message) : type = ResponseType.warning, value = null;
  Response.success(this.value) : type = ResponseType.success, message = '';
}
