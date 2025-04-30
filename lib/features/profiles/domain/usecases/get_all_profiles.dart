import 'package:injectable/injectable.dart';
import 'package:professional_profiles/core/resource/data_loading_state.dart';
import 'package:professional_profiles/core/resource/usecase.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/domain/repositories/profiles_repo.dart';

@injectable
class GetAllProfiles extends UseCase<DataState<List<ProfileEntity>>, void> {
  //
  //
  final ProfilesRepo _repo;
  GetAllProfiles(this._repo);
  //
  //
  @override
  Future<DataState<List<ProfileEntity>>> call({required void params}) {
    return _repo.listProfiles();
  }
}
