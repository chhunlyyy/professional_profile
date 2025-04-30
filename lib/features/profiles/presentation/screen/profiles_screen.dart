import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:professional_profiles/core/main_store/main_store.dart';
import 'package:professional_profiles/core/resource/data_loading_state.dart';
import 'package:professional_profiles/features/profiles/presentation/store/profile_store.dart';
import 'package:professional_profiles/features/profiles/presentation/screen/profile_form_screen.dart';
import 'package:professional_profiles/features/profiles/presentation/widget/profile_list_loading_widget.dart';
import 'package:professional_profiles/features/profiles/presentation/widget/profiles_list_widget.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  late ProfileStore _store;

  Future<void> _getAllProfiles() async {
    Future.delayed(Duration(seconds: 3), () async {
      await _store.createSampleProfilesInFirstStart();
      await _store.getAllProfiles(false);
    });
  }

  @override
  void initState() {
    super.initState();
    _store = GetStore.get<ProfileStore>(context);
    if (mounted) {
      _getAllProfiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Observer(builder: (_) => _content())),
      floatingActionButton: _addProfileButton(),
    );
  }

  Widget _addProfileButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
        );
      },
      tooltip: 'Create New Profile',
      child: const Icon(Icons.add),
    );
  }

  Widget _content() {
    if (_store.profilesLoadingState is DataSuccess) {
      return const ProfilesListWidget();
    }
    return ProfileListLoadingWidget();
  }
}
