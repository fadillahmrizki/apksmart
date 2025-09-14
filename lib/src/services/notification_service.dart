import 'package:flutter/material.dart';
import '../widgets/custom_notification.dart';

class NotificationService {
  static OverlayEntry? _overlayEntry;

  static void showNotification(
    BuildContext context, {
    required String message,
    Color color = Colors.green,
    IconData icon = Icons.check_circle_outline,
  }) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: CustomNotification(
          message: message,
          backgroundColor: color,
          icon: icon,
          onDismiss: () {
            if (_overlayEntry != null) {
              _overlayEntry!.remove();
              _overlayEntry = null;
            }
          },
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}
