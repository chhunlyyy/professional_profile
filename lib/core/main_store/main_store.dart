import 'package:injectable/injectable.dart';
import 'package:professional_profiles/core/main_store/register_store.dart';
import 'package:professional_profiles/injection.dart';
import 'package:provider/provider.dart';

@injectable
class MainStore {
  final Map<Type, dynamic> _stores = {};

  MainStore() {
    this.register();
  }

  void register() {
    List<Type> storeTypes = RegisterStore.getStores();

    for (var storeType in storeTypes) {
      _stores[storeType] = locator.get(type: storeType);
    }
  }

  T getStore<T>() {
    return _stores[T] as T;
  }
}

class GetStore {
  static T get<T>(context) {
    return Provider.of<MainStore>(context, listen: false).getStore<T>();
  }
}
