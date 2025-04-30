// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:professional_profiles/core/main_store/main_store.dart' as _i742;
import 'package:professional_profiles/features/profiles/data/datasource/profiles_local_service.dart'
    as _i746;
import 'package:professional_profiles/features/profiles/data/repositories/profiles_repo_impl.dart'
    as _i859;
import 'package:professional_profiles/features/profiles/domain/repositories/profiles_repo.dart'
    as _i72;
import 'package:professional_profiles/features/profiles/domain/usecases/create_profile.dart'
    as _i345;
import 'package:professional_profiles/features/profiles/domain/usecases/create_sample_profiles.dart'
    as _i4;
import 'package:professional_profiles/features/profiles/domain/usecases/delete_profile.dart'
    as _i870;
import 'package:professional_profiles/features/profiles/domain/usecases/get_all_profiles.dart'
    as _i137;
import 'package:professional_profiles/features/profiles/domain/usecases/update_profile.dart'
    as _i541;
import 'package:professional_profiles/features/profiles/presentation/store/profile_store.dart'
    as _i975;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i742.MainStore>(() => _i742.MainStore());
  gh.factory<_i746.ProfilesLocalService>(() => _i746.ProfilesLocalService());
  gh.factory<_i72.ProfilesRepo>(
      () => _i859.ProfilesRepoImpl(gh<_i746.ProfilesLocalService>()));
  gh.factory<_i345.CreateProfile>(
      () => _i345.CreateProfile(gh<_i72.ProfilesRepo>()));
  gh.factory<_i4.CreateSampleProfiles>(
      () => _i4.CreateSampleProfiles(gh<_i72.ProfilesRepo>()));
  gh.factory<_i870.DeleteProfile>(
      () => _i870.DeleteProfile(gh<_i72.ProfilesRepo>()));
  gh.factory<_i137.GetAllProfiles>(
      () => _i137.GetAllProfiles(gh<_i72.ProfilesRepo>()));
  gh.factory<_i541.UpdateProfile>(
      () => _i541.UpdateProfile(gh<_i72.ProfilesRepo>()));
  gh.factory<_i975.ProfileStore>(() => _i975.ProfileStore(
        gh<_i137.GetAllProfiles>(),
        gh<_i4.CreateSampleProfiles>(),
      ));
  return getIt;
}
