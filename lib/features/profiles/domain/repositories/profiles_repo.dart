import 'package:professional_profiles/core/resource/data_loading_state.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';

abstract class ProfilesRepo {
  Future<DataState<List<ProfileEntity>>> listProfiles();
  //
  Future<DataState<void>> createProfile(ProfileEntity profile);
  //
  Future<DataState<void>> deleteProfile(String id);
  //
  Future<DataState<void>> update(ProfileEntity profile);
}
