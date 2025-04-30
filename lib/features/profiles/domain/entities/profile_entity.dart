import 'package:professional_profiles/features/profiles/domain/entities/profile_contact_info_entity.dart';

class ProfileEntity {
  final String id;
  final String name;
  final String role;
  final List<String> skills;
  final String? bio;
  final String? imagePath;
  final ProfileContactInfoEntity contact;
  ProfileEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.skills,
    required this.bio,
    required this.imagePath,
    required this.contact,
  });
}
