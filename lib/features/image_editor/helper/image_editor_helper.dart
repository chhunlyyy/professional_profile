import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:professional_profiles/core/helper/ui_helper.dart';

class ImageEditorHelper {
  static Future<void> saveToGallery({
    required BuildContext context,
    required PainterController controller,
    required Size imageSize,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final baseSize = imageSize;
      const scale = 2.0;
      final image = await controller.renderImage(baseSize * scale);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception("Failed to convert image to bytes");

      final pngBytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaverPlus.saveImage(pngBytes);

      Navigator.of(context, rootNavigator: true).pop();

      await UIHelper.showSuccessDialog(
        context,
        message: 'Saved to gallery:\n${result['filePath'] ?? 'Image saved successfully!'}',
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();

      await UIHelper.showErrorDialog(
        context,
        message: 'Failed to save image: $e',
      );
    }
  }

  static Future<void> saveAndReturnFile({
    required BuildContext context,
    required PainterController controller,
    required Function(File image) onSaveCallBack,
    required Size imageSize,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final baseSize = imageSize;
      const scale = 2.0;
      final image = await controller.renderImage(baseSize * scale);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception("Failed to convert image to bytes");

      final pngBytes = byteData.buffer.asUint8List();

      final tempDir = Directory.systemTemp;
      final file = await File('${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(pngBytes);

      onSaveCallBack(file);

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();

      await UIHelper.showErrorDialog(
        context,
        message: 'Failed to export image: $e',
      );
    }
  }
}
