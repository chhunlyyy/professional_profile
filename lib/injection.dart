import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:professional_profiles/injection.config.dart';

final locator = GetIt.instance;

@InjectableInit(asExtension: false)
FutureOr<GetIt> configureDependencies(GetIt getIt) => init(getIt);
