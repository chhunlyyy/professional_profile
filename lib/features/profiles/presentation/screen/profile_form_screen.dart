import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/domain/usecases/create_profile.dart';
import 'package:professional_profiles/features/profiles/domain/usecases/update_profile.dart';
import 'package:professional_profiles/features/profiles/helper/profile_form_helper.dart';
import 'package:professional_profiles/injection.dart';

class ProfileFormScreen extends StatefulWidget {
  final ProfileEntity? profileEntity;
  const ProfileFormScreen({super.key, this.profileEntity});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  late final ProfileFormHelper _formHelper;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Track loading state
  late bool _isUpdate;

  static const double _padding = 16.0;
  static const double _avatarRadius = 50.0;
  static const double _buttonWidth = 250.0;
  static const double _wideScreenThreshold = 600.0;

  void _initUpdateData() {
    final entity = widget.profileEntity;
    if (entity != null) {
      _formHelper.nameController.text = entity.name;
      _formHelper.roleController.text = entity.role;
      _formHelper.skillsController.text = entity.skills.join(',');
      _formHelper.bioController.text = entity.bio ?? "";
      _formHelper.emailController.text = entity.contact.email ?? "";
      _formHelper.linkedinController.text = entity.contact.linkedIn ?? "";
      _formHelper.githubController.text = entity.contact.github ?? "";
      if (entity.imagePath != null) {
        _formHelper.pickedImage = XFile(entity.imagePath!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _formHelper = ProfileFormHelper();
    _isUpdate = widget.profileEntity != null;
    _initUpdateData();
  }

  @override
  void dispose() {
    _formHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > _wideScreenThreshold;

    return Scaffold(
      appBar: AppBar(title: const Text('New Professional Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(_padding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 24),
              isWideScreen ? _buildWideLayout(screenWidth) : _buildNarrowLayout(),
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(double screenWidth) {
    final fields = _buildFormFields();
    final itemWidth = (screenWidth - (_padding * 3)) / 2; // 2 fields per row

    return Wrap(
      spacing: _padding,
      runSpacing: _padding,
      children: fields.map((field) => SizedBox(width: itemWidth, child: field)).toList(),
    );
  }

  Widget _buildNarrowLayout() {
    final fields = _buildFormFields();

    return Column(
      children: fields
          .map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: _padding),
              child: field,
            ),
          )
          .toList(),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      _buildTextField(
        controller: _formHelper.nameController,
        label: 'Name',
        isRequired: true,
      ),
      _buildTextField(
        controller: _formHelper.roleController,
        label: 'Role',
        isRequired: true,
      ),
      _buildTextField(
        controller: _formHelper.skillsController,
        label: 'Skills (comma separated)',
        isRequired: true,
      ),
      _buildTextField(
        controller: _formHelper.bioController,
        label: 'Bio (optional)',
        keyboardType: TextInputType.emailAddress,
      ),
      _buildTextField(
        controller: _formHelper.emailController,
        label: 'Email (optional)',
        keyboardType: TextInputType.emailAddress,
      ),
      _buildTextField(
        controller: _formHelper.linkedinController,
        label: 'LinkedIn URL (optional)',
        keyboardType: TextInputType.url,
      ),
      _buildTextField(
        controller: _formHelper.githubController,
        label: 'GitHub URL (optional)',
        keyboardType: TextInputType.url,
      ),
    ];
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () {
        _formHelper.showImagePickerOptions(context, (picked) {
          setState(() {
            if (_formHelper.pickedImage != null) {
              File(_formHelper.pickedImage!.path).delete();
            }
            _formHelper.pickedImage = picked;
          });
        });
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: _avatarRadius * 2,
            height: _avatarRadius * 2,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue, // Customize the border color
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
                image: _formHelper.pickedImage != null
                    ? DecorationImage(
                        image: FileImage(File(_formHelper.pickedImage!.path)),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
              child: _formHelper.pickedImage == null ? const Center(child: Icon(Icons.add_a_photo, size: 30)) : null,
            ),
          ),
          if (_formHelper.pickedImage != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) return '$label is required';
              return null;
            }
          : null,
    );
  }

  Widget _buildSaveButton() {
    final String buttonTitle = _isUpdate ? 'Update Profile' : 'Save Profile';
    return SizedBox(
      width: _buttonWidth,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onSavePressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : Text(buttonTitle),
        ),
      ),
    );
  }

  void _onSavePressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () async {
        if (_isUpdate) {
          await _doUpdate();
        } else {
          await _doCreate();
        }
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> _doCreate() async {
    await locator<CreateProfile>().call(params: CreateProfileParams(context, _formHelper));
  }

  Future<void> _doUpdate() async {
    await locator<UpdateProfile>().call(params: UpdateProfileParams(context, _formHelper, widget.profileEntity!.id));
  }
}
