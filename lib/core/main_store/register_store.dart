import 'package:professional_profiles/features/profiles/presentation/store/profile_store.dart';

class RegisterStore {
  static List<Type> getStores() {
    return [
      //TODO:: Register Your Store Here And Access By Provider MainStore
      ProfileStore,
    ];
  }
}
