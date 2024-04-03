import 'package:flutter/material.dart';

typedef ShowDialogListener = void Function(SnackBarRequest);

/// A controller for showing [SnackBar]s.
class SnackBarService {
  late ShowDialogListener _showDialogListener;

  /// Registers a listener to be called when a [SnackBar] is requested.
  void registerListener(ShowDialogListener showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Requests to show a [SnackBar] specified by [snackRequest].
  void showSnackBar(SnackBarRequest snackRequest) {
    _showDialogListener(snackRequest);
  }
}

/// A class describing a [SnackBar] request.
abstract class SnackBarRequest {
  final Color color;
  final String message;

  SnackBarRequest({required this.message, required this.color});
}

/// A [SnackBarRequest] representing a success event.
class SuccessSnackBarRequest extends SnackBarRequest {
  /// Creates a new [SnackBarRequest] representing a success event.
  SuccessSnackBarRequest(String message)
      : super(message: message, color: Colors.greenAccent);
}

/// A [SnackBarRequest] representing an info event.
class InfoSnackBarRequest extends SnackBarRequest {
  /// Creates a new [SnackBarRequest] representing an info event.
  InfoSnackBarRequest(String message)
      : super(message: message, color: Colors.blueAccent);
}

/// A [SnackBarRequest] representing a warning event.
class WarningSnackBarRequest extends SnackBarRequest {
  /// Creates a new [SnackBarRequest] representing a warning event.
  WarningSnackBarRequest(String message)
      : super(message: message, color: Colors.orangeAccent);
}

/// A [SnackBarRequest] representing an error event.
class ErrorSnackBarRequest extends SnackBarRequest {
  /// Creates a new [SnackBarRequest] representing an error event.
  ErrorSnackBarRequest(String message)
      : super(message: message, color: Colors.redAccent);
}
