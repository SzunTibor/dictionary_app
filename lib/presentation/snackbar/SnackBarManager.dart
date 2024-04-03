import 'package:flutter/material.dart';

import 'SnackBarService.dart';

/// Presents a [SnackBar] when a [SnackBarService] asks for it.
class SnackBarManager extends StatefulWidget {
  final Widget child;
  final SnackBarService snackBarService;

  /// Shows a [SnackBar] when the listener gets called by [snackBarService].
  const SnackBarManager(
      {super.key, required this.child, required this.snackBarService});

  @override
  State  createState() => _SnackBarManagerState();
}

class _SnackBarManagerState extends State<SnackBarManager> {
  @override
  void initState() {
    super.initState();
    widget.snackBarService.registerListener(_showSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showSnackBar(SnackBarRequest request) {
    final snackBar = SnackBar(
      backgroundColor: request.color,
      content: Text(
        request.message,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
