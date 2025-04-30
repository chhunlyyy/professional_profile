import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:professional_profiles/core/helper/navigator.dart';
import 'package:professional_profiles/core/helper/ui_helper.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/domain/usecases/delete_profile.dart';
import 'package:professional_profiles/features/profiles/presentation/screen/profile_form_screen.dart';
import 'package:professional_profiles/injection.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetailScreen extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileDetailScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _updateButton(context, profile),
          _deleteButton(context, profile.id),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            if (profile.imagePath != null) Hero(tag: profile.id, child: UIHelper.userProfileImage(context, profile.imagePath!)),
            const SizedBox(height: 12),
            // Name and Role
            _buildTitleText(context, profile.name, isMainTitle: true),
            _buildSubText(context, profile.role, color: Colors.grey[600]),
            const SizedBox(height: 12),

            // Skills
            if (profile.skills.isNotEmpty)
              _buildSection(
                context,
                title: 'Skills',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.skills.map((skill) => Chip(label: Text(skill))).toList(),
                ),
              ),

            // Bio
            if (profile.bio != null)
              _buildSection(
                context,
                title: 'Bio',
                child: Text(profile.bio!, style: Theme.of(context).textTheme.bodyMedium),
              ),

            // Contact
            if (_hasAnyContact)
              _buildSection(
                context,
                title: 'Contact',
                child: Row(
                  children: [
                    if (profile.contact.email != null)
                      _buildIconButton(
                        FontAwesomeIcons.envelope,
                        const Color(0xffE34133),
                        () => _launchEmail(profile.contact.email!),
                      ),
                    if (profile.contact.linkedIn != null)
                      _buildIconButton(
                        FontAwesomeIcons.linkedin,
                        const Color(0xff0077B5),
                        () => _launchUrl(context, profile.contact.linkedIn!),
                      ),
                    if (profile.contact.github != null)
                      _buildIconButton(
                        FontAwesomeIcons.github,
                        null,
                        () => _launchUrl(context, profile.contact.github!),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _updateButton(BuildContext context, ProfileEntity profile) {
    return IconButton(
      onPressed: () {
        pushWithSlide(context, ProfileFormScreen(profileEntity: profile));
      },
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
    );
  }

  Widget _deleteButton(BuildContext context, String profileId) {
    return IconButton(
      onPressed: () {
        locator<DeleteProfile>().call(params: DeleteProfileParams(context, profileId));
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  Widget _buildTitleText(BuildContext context, String text, {bool isMainTitle = false}) {
    return Text(
      text,
      style: isMainTitle ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold) : Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubText(BuildContext context, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(context, title),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color? color, VoidCallback onPressed) {
    return IconButton(
      icon: FaIcon(icon, color: color),
      onPressed: onPressed,
    );
  }

  bool get _hasAnyContact => profile.contact.email != null || profile.contact.linkedIn != null || profile.contact.github != null;

  void _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      UIHelper.showErrorDialog(context, message: 'Could not launch $url');
    }
  }

  void _launchEmail(String email) {
    final uri = Uri(scheme: 'mailto', path: email);
    launchUrl(uri);
  }
}
