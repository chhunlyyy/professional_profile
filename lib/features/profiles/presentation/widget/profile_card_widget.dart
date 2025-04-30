import 'dart:io';

import 'package:flutter/material.dart';
import 'package:professional_profiles/core/helper/navigator.dart';
import 'package:professional_profiles/core/helper/ui_helper.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/presentation/screen/profile_detail_screen.dart';

class ProfileCardWidget extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileCardWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => pushWithSlide(context, ProfileDetailScreen(profile: profile)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleText(context, profile.name, isMainTitle: true),
                      _buildSubText(context, profile.role, color: Colors.grey[600]),
                    ],
                  )),
                  const SizedBox(width: 20),
                  if (profile.imagePath != null)
                    Center(
                      child: Hero(
                        tag: profile.id,
                        child: SizedBox(width: 60, height: 60, child: UIHelper.userProfileImage(context, profile.imagePath!)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
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
            ],
          ),
        ),
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
}
