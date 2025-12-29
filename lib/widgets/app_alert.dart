import 'package:flutter/material.dart';
import '../constants/colors_app.dart';

Future<void> showAppAlert(
  BuildContext context, {
  required String title,
  required String message,
  IconData? icon,
  Color? color,
}) {
  // Auto-detect success alerts and add green check icon
  final bool isSuccessTitle =
      title == 'Berhasil' ||
      title == 'Tersimpan' ||
      title == 'Terhapus' ||
      title == 'Pendaftaran Berhasil!';
  final IconData? resolvedIcon =
      icon ?? (isSuccessTitle ? Icons.check_circle_outline : null);

  // For check icons, always use green. For other icons, use provided color or default.
  final Color iconColor;
  if (resolvedIcon == Icons.check_circle_outline) {
    iconColor = AppColors.successGreen;
  } else if (color != null) {
    iconColor = color;
  } else {
    iconColor = AppColors.deepTeal;
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (resolvedIcon != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(resolvedIcon, size: 36, color: iconColor),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepTeal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
