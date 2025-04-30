import 'package:flutter/material.dart';
import 'package:professional_profiles/injection.dart';
import 'package:professional_profiles/prefesstional_profiles_app.dart';

void main() {
  //
  configureDependencies(locator);
  //
  runApp(const PrefesstionalProfilesApp());
}
