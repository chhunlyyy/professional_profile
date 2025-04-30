import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:professional_profiles/core/helper/navigator.dart';
import 'package:professional_profiles/features/image_editor/image_editor.dart';

class ProfileFormHelper {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController githubController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;

  void dispose() {
    nameController.dispose();
    roleController.dispose();
    skillsController.dispose();
    emailController.dispose();
    linkedinController.dispose();
    githubController.dispose();
  }

  void navigateToImageEditor(BuildContext context, XFile picked, Function(XFile) onImagePicked) {
    pushWithSlide(
      context,
      ImageEditorWidget(
        image: File(picked.path),
        onSaveCallBack: (image) {
          Future.delayed(Duration(milliseconds: 100), () => onImagePicked(XFile(image.path)));
        },
      ),
    );
  }

  Future<void> pickImageFromGallery(BuildContext context, Function(XFile) onImagePicked) async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      navigateToImageEditor(context, picked, onImagePicked);
    }
  }

  Future<void> takePhoto(BuildContext context, Function(XFile) onImagePicked) async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      navigateToImageEditor(context, picked, onImagePicked);
    }
  }

  void showImagePickerOptions(BuildContext context, Function(XFile) onImagePicked) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromGallery(context, onImagePicked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  takePhoto(context, onImagePicked);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
