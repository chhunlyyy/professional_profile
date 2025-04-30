// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  Computed<DataState<List<ProfileEntity>>>? _$profilesLoadingStateComputed;

  @override
  DataState<List<ProfileEntity>> get profilesLoadingState =>
      (_$profilesLoadingStateComputed ??=
              Computed<DataState<List<ProfileEntity>>>(
                  () => super.profilesLoadingState,
                  name: '_ProfileStore.profilesLoadingState'))
          .value;

  late final _$_profilesLoadingStateAtom =
      Atom(name: '_ProfileStore._profilesLoadingState', context: context);

  @override
  DataState<List<ProfileEntity>> get _profilesLoadingState {
    _$_profilesLoadingStateAtom.reportRead();
    return super._profilesLoadingState;
  }

  @override
  set _profilesLoadingState(DataState<List<ProfileEntity>> value) {
    _$_profilesLoadingStateAtom.reportWrite(value, super._profilesLoadingState,
        () {
      super._profilesLoadingState = value;
    });
  }

  late final _$getAllProfilesAsyncAction =
      AsyncAction('_ProfileStore.getAllProfiles', context: context);

  @override
  Future<void> getAllProfiles(bool isRefresh) {
    return _$getAllProfilesAsyncAction
        .run(() => super.getAllProfiles(isRefresh));
  }

  late final _$createSampleProfilesInFirstStartAsyncAction = AsyncAction(
      '_ProfileStore.createSampleProfilesInFirstStart',
      context: context);

  @override
  Future<void> createSampleProfilesInFirstStart() {
    return _$createSampleProfilesInFirstStartAsyncAction
        .run(() => super.createSampleProfilesInFirstStart());
  }

  @override
  String toString() {
    return '''
profilesLoadingState: ${profilesLoadingState}
    ''';
  }
}
