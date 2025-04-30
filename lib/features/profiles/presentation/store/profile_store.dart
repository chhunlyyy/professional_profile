import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:professional_profiles/core/resource/data_loading_state.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/domain/usecases/create_sample_profiles.dart';
import 'package:professional_profiles/features/profiles/domain/usecases/get_all_profiles.dart';
part 'profile_store.g.dart';

@injectable
class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final GetAllProfiles _getAllProfiles;
  final CreateSampleProfiles _createSampleProfiles;
  _ProfileStore(this._getAllProfiles, this._createSampleProfiles);
  //
  @observable
  DataState<List<ProfileEntity>> _profilesLoadingState = const DataLoading();
  //
  @action
  Future<void> getAllProfiles(bool isRefresh) async {
    if (isRefresh || _profilesLoadingState is DataLoading) {
      _profilesLoadingState = const DataLoading();
      _profilesLoadingState = await _getAllProfiles.call(params: null);
    }
  }

  @action
  Future<void> createSampleProfilesInFirstStart() async {
    await _createSampleProfiles.call(params: null);
  }

  //
  @computed
  DataState<List<ProfileEntity>> get profilesLoadingState => _profilesLoadingState;
}
