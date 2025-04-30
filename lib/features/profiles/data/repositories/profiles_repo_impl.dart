import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:professional_profiles/core/resource/data_loading_state.dart';
import 'package:professional_profiles/features/profiles/data/datasource/profiles_local_service.dart';
import 'package:professional_profiles/features/profiles/data/models/profile_model.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/domain/repositories/profiles_repo.dart';

@Injectable(as: ProfilesRepo)
class ProfilesRepoImpl implements ProfilesRepo {
  //
  final ProfilesLocalService _service;
  ProfilesRepoImpl(this._service);
  //
  @override
  Future<DataState<List<ProfileEntity>>> listProfiles() async {
    try {
      final List<ProfileEntity> profiles = await _service.getAllProfiles();
      return DataSuccess(profiles);
    } catch (e) {
      final DioException error = DioException(requestOptions: RequestOptions(path: ''), error: e, type: DioExceptionType.unknown);
      return DataFailed(error);
    }
  }

  //
  @override
  Future<DataState<void>> createProfile(ProfileEntity profile) async {
    try {
      await _service.createProfile(ProfileModel.fromEntity(profile));
      return const DataSuccess(null);
    } catch (e) {
      final DioException error = DioException(requestOptions: RequestOptions(path: ''), error: e, type: DioExceptionType.unknown);
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<void>> deleteProfile(String id) async {
    try {
      await _service.deleteProfile(id);
      return const DataSuccess(null);
    } catch (e) {
      final DioException error = DioException(requestOptions: RequestOptions(path: ''), error: e, type: DioExceptionType.unknown);
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<void>> update(ProfileEntity profile) async {
    try {
      await _service.updateProfile(ProfileModel.fromEntity(profile));
      return const DataSuccess(null);
    } catch (e) {
      final DioException error = DioException(requestOptions: RequestOptions(path: ''), error: e, type: DioExceptionType.unknown);
      return DataFailed(error);
    }
  }
}
