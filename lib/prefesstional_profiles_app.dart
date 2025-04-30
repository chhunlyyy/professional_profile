import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:professional_profiles/core/main_store/main_store.dart';
import 'package:professional_profiles/features/splash/presentaion/screen/splash_screen.dart';
import 'package:provider/provider.dart';

class PrefesstionalProfilesApp extends StatelessWidget {
  const PrefesstionalProfilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MainStore>(create: (_) => GetIt.instance.get()),
      ],
      child: Consumer<MainStore>(
        builder: ((_, mainStore, __) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              title: 'Prefesstional Profiles',
              debugShowCheckedModeBanner: false,
              home: const Material(child: SplashScreen()),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
            ),
          );
        }),
      ),
    );
  }
}
