import 'dart:io';

import 'package:flutter/material.dart';
import 'package:professional_profiles/core/helper/navigator.dart';
import 'package:professional_profiles/features/image_editor/image_view_screen.dart';

class UIHelper {
  static Future<void> showSuccessDialog(BuildContext context, {required String message, String title = 'Success', VoidCallback? onDismiss}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ).whenComplete(() {
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }

  static Future<void> showErrorDialog(BuildContext context, {required String message, String title = 'Error', VoidCallback? onDismiss}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ).whenComplete(() {
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }

  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    String title = 'Confirm',
    String content = 'Are you sure?',
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              if (onCancel != null) {
                onCancel();
              }
              Navigator.of(ctx).pop(false);
            },
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              }
              Navigator.of(ctx).pop(true);
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Widget userProfileImage(BuildContext context, String imagePath) {
    return Center(
      child: GestureDetector(
        onTap: () {
          pushWithSlide(context, ImageViewScreen(image: File(imagePath)));
        },
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: FileImage(File(imagePath)),
                  fit: BoxFit.contain,
                )),
          ),
        ),
      ),
    );
  }
}
