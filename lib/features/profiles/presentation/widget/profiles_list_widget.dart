import 'package:flutter/material.dart';
import 'package:professional_profiles/core/main_store/main_store.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/presentation/store/profile_store.dart';
import 'package:professional_profiles/features/profiles/presentation/widget/profile_card_widget.dart';

class ProfilesListWidget extends StatefulWidget {
  const ProfilesListWidget({super.key});

  @override
  State<ProfilesListWidget> createState() => _ProfilesListWidgetState();
}

class _ProfilesListWidgetState extends State<ProfilesListWidget> {
  late final ProfileStore store;
  List<ProfileEntity> profiles = [];
  List<ProfileEntity> filteredProfiles = [];
  final TextEditingController searchController = TextEditingController();

  void _onSearchChanged(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredProfiles = profiles.where((profile) {
        final nameMatch = profile.name.toLowerCase().contains(lowerQuery);
        final skillMatch = profile.skills.any((skill) => skill.toLowerCase().contains(lowerQuery));
        return nameMatch || skillMatch;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    store = GetStore.get<ProfileStore>(context);
    profiles = store.profilesLoadingState.data ?? [];
    filteredProfiles = profiles;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth >= 600;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchField(),
              const SizedBox(height: 16),
              Expanded(
                child: filteredProfiles.isEmpty
                    ? const Center(child: Text('No profiles found'))
                    : isWideScreen
                        ? _gridViewForBigScreen(filteredProfiles)
                        : _listViewForSmallScreen(filteredProfiles),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search by name or skills...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: _onSearchChanged,
    );
  }

  Widget _gridViewForBigScreen(List<ProfileEntity> profiles) {
    return GridView.builder(
      itemCount: profiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        return ProfileCardWidget(profile: profiles[index]);
      },
    );
  }

  Widget _listViewForSmallScreen(List<ProfileEntity> profiles) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return ProfileCardWidget(profile: profiles[index]);
      },
    );
  }
}
