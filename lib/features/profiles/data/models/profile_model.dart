import 'package:professional_profiles/features/profiles/data/models/profile_contact_info_model.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({required super.id, required super.name, required super.role, required super.skills, required super.bio, required super.contact, required super.imagePath});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      skills: List<String>.from(json['skills']),
      bio: json['bio'],
      contact: ProfileContactInfoModel.fromJson(json['contact'] as Map<String, dynamic>),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'imagePath': imagePath,
      'skills': skills,
      'bio': bio,
      'contact': (contact as ProfileContactInfoModel).toJson(),
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      role: entity.role,
      skills: entity.skills,
      bio: entity.bio,
      contact: ProfileContactInfoModel(
        email: entity.contact.email,
        linkedIn: entity.contact.linkedIn,
        github: entity.contact.github,
      ),
      imagePath: entity.imagePath,
    );
  }
}
