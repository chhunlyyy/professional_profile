import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:professional_profiles/core/helper/navigator.dart';
import 'package:professional_profiles/core/helper/ui_helper.dart';
import 'package:professional_profiles/core/main_store/main_store.dart';
import 'package:professional_profiles/core/resource/data_loading_state.dart';
import 'package:professional_profiles/core/resource/usecase.dart';
import 'package:professional_profiles/features/profiles/domain/repositories/profiles_repo.dart';
import 'package:professional_profiles/features/profiles/presentation/screen/profiles_screen.dart';
import 'package:professional_profiles/features/profiles/presentation/store/profile_store.dart';

class DeleteProfileParams {
  BuildContext context;
  String id;
  DeleteProfileParams(this.context, this.id);
}

@injectable
class DeleteProfile extends UseCase<void, DeleteProfileParams> {
  ProfilesRepo _repo;

  DeleteProfile(this._repo);

  @override
  Future<void> call({required DeleteProfileParams params}) async {
    UIHelper.showConfirmDialog(
      params.context,
      content: 'Are you sure to delete this profile ?',
      onConfirm: () {
        _doDelete(params);
      },
    );
  }

  Future<void> _doDelete(DeleteProfileParams params) async {
    DataState<void> dataState = await _repo.deleteProfile(params.id);
    if (dataState is DataFailed) {
      _onError(params);
    } else {
      _onSuccess(params);
    }
  }

  void _onSuccess(DeleteProfileParams params) {
    Future.delayed(Duration.zero, () async {
      GetStore.get<ProfileStore>(params.context).getAllProfiles(true);

      UIHelper.showSuccessDialog(
        params.context,
        message: 'Successfully delete this professional profile.',
        onDismiss: () {
          pushReplacement(params.context, const ProfilesScreen());
        },
      );
    });
  }

  void _onError(DeleteProfileParams params) {
    UIHelper.showErrorDialog(params.context, message: 'Failed to delete this professional profile.');
  }
}
