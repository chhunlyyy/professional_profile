import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:professional_profiles/core/helper/navigator.dart';
import 'package:professional_profiles/core/helper/ui_helper.dart';
import 'package:professional_profiles/core/main_store/main_store.dart';
import 'package:professional_profiles/core/resource/data_loading_state.dart';
import 'package:professional_profiles/core/resource/usecase.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_contact_info_entity.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/domain/repositories/profiles_repo.dart';
import 'package:professional_profiles/features/profiles/domain/usecases/save_image_to_local.dart';
import 'package:professional_profiles/features/profiles/helper/profile_form_helper.dart';
import 'package:professional_profiles/features/profiles/presentation/screen/profiles_screen.dart';
import 'package:professional_profiles/features/profiles/presentation/store/profile_store.dart';

class UpdateProfileParams {
  BuildContext context;
  ProfileFormHelper formHelper;
  String profileId;

  UpdateProfileParams(this.context, this.formHelper, this.profileId);
}

@injectable
class UpdateProfile extends UseCase<void, UpdateProfileParams> {
  //
  final ProfilesRepo _repo;
  UpdateProfile(this._repo);

  @override
  Future<void> call({required UpdateProfileParams params}) async {
    final formHelper = params.formHelper;
    final profileEntity = await _profileEntity(formHelper, params.profileId);
    DataState<void> dataState = await _repo.update(profileEntity);
    if (dataState is DataFailed) {
      _onError(params);
    } else {
      _onSuccess(params);
    }
  }

  void _onSuccess(UpdateProfileParams params) {
    Future.delayed(Duration.zero, () async {
      GetStore.get<ProfileStore>(params.context).getAllProfiles(true);

      UIHelper.showSuccessDialog(
        params.context,
        message: 'Successfully update professional profile.',
        onDismiss: () {
          pushReplacement(params.context, const ProfilesScreen());
        },
      );
    });
  }

  void _onError(UpdateProfileParams params) {
    UIHelper.showErrorDialog(params.context, message: 'Failed to update professional profile.');
  }

  Future<ProfileEntity> _profileEntity(ProfileFormHelper formHelper, String profileId) async {
    String? imagePath = formHelper.pickedImage == null ? null : await SaveImageToLocal.saveAndGetPath(File(formHelper.pickedImage!.path));
    return ProfileEntity(
      id: profileId,
      name: formHelper.nameController.text.trim(),
      role: formHelper.roleController.text.trim(),
      bio: formHelper.bioController.text.trim(),
      skills: formHelper.skillsController.text.trim().split(',').map((e) => e.trim()).toList(),
      imagePath: imagePath,
      contact: _contactInfoEntity(formHelper),
    );
  }

  ProfileContactInfoEntity _contactInfoEntity(ProfileFormHelper formHelper) {
    String? email = formHelper.emailController.text.trim().isEmpty ? null : formHelper.emailController.text.trim();

    String? linkedIn = formHelper.linkedinController.text.trim().isEmpty ? null : formHelper.linkedinController.text.trim();

    String? github = formHelper.githubController.text.trim().isEmpty ? null : formHelper.githubController.text.trim();

    return ProfileContactInfoEntity(
      email: email,
      linkedIn: linkedIn,
      github: github,
    );
  }
}
