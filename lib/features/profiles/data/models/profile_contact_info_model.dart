import 'package:professional_profiles/features/profiles/domain/entities/profile_contact_info_entity.dart';

class ProfileContactInfoModel extends ProfileContactInfoEntity {
  ProfileContactInfoModel({required super.email, required super.linkedIn, required super.github});

  factory ProfileContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfileContactInfoModel(
      email: json['email'],
      linkedIn: json['linkedIn'],
      github: json['github'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'linkedIn': linkedIn,
      'github': github,
    };
  }
}
