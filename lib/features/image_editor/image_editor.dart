import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:professional_profiles/features/image_editor/helper/image_editor_helper.dart';

class ImageEditorWidget extends StatefulWidget {
  final File image;
  final Function(File image) onSaveCallBack;

  const ImageEditorWidget({Key? key, required this.image, required this.onSaveCallBack}) : super(key: key);

  @override
  _ImageEditorWidgetState createState() => _ImageEditorWidgetState();
}

class _ImageEditorWidgetState extends State<ImageEditorWidget> {
  PainterController? controller;
  bool isTextMode = false;
  bool isDrawingMode = false;
  late Size imageSize;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final data = await widget.image.readAsBytes();
    final uiImage = await decodeImageFromList(data);

    imageSize = Size(uiImage.width.toDouble(), uiImage.height.toDouble());

    setState(() {
      controller = PainterController(
        background: ImageBackgroundDrawable(image: uiImage),
        settings: const PainterSettings(
          freeStyle: FreeStyleSettings(
            color: Colors.red,
            strokeWidth: 3,
            mode: FreeStyleMode.none,
          ),
          text: TextSettings(
            textStyle: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      );
    });
  }

  void _enableDrawing() {
    if (controller == null) return;
    setState(() {
      isDrawingMode = true;
      isTextMode = false;
      controller!.freeStyleMode = FreeStyleMode.draw;
    });
  }

  Future<void> _addText() async {
    if (controller == null) return;
    setState(() {
      isDrawingMode = false;
      isTextMode = true;
      controller!.freeStyleMode = FreeStyleMode.none;
    });

    // Use image size instead of screen size
    final centerPosition = Offset(imageSize.width / 2, imageSize.height / 2);

    final textDrawable = TextDrawable(
      text: 'Write Here',
      position: centerPosition,
      style: const TextStyle(
        fontSize: 200, // Increased font size
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );

    setState(() {
      controller!.addDrawables([textDrawable]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Image Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: controller != null
                ? () => ImageEditorHelper.saveAndReturnFile(
                      context: context,
                      controller: controller!,
                      onSaveCallBack: widget.onSaveCallBack,
                      imageSize: imageSize,
                    )
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: controller != null
                ? () => ImageEditorHelper.saveToGallery(
                      context: context,
                      controller: controller!,
                      imageSize: imageSize,
                    )
                : null,
          ),
        ],
      ),
      body: controller == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(width: imageSize.width, height: imageSize.height, child: FlutterPainter(controller: controller!)),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton.icon(onPressed: () => controller!.undo(), label: const Icon(Icons.undo)),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTextMode ? Colors.blue : null,
                          ),
                          onPressed: _addText,
                          icon: const Icon(Icons.text_fields),
                          label: Text("Add Text", style: TextStyle(color: isTextMode ? Colors.white : Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDrawingMode ? Colors.blue : null,
                          ),
                          onPressed: _enableDrawing,
                          icon: const Icon(Icons.brush),
                          label: Text("Drawing", style: TextStyle(color: isDrawingMode ? Colors.white : Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
