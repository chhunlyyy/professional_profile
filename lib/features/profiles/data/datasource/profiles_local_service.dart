import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:professional_profiles/features/profiles/data/models/profile_model.dart';

@injectable
class ProfilesLocalService {
  static const String _fileName = 'profiles.json';

  Future<String> get _localFilePath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/$_fileName';
    } catch (e) {
      throw Exception('Error fetching application directory: $e');
    }
  }

  Future<File> get _localFile async {
    try {
      final path = await _localFilePath;
      final file = File(path);

      if (!await file.exists()) {
        await file.writeAsString(jsonEncode([]));
      }
      return file;
    } catch (e) {
      throw Exception('Error accessing local file: $e');
    }
  }

  Future<void> _saveAllProfiles(List<ProfileModel> profiles) async {
    try {
      final file = await _localFile;

      final data = profiles.map((e) => e.toJson()).toList();

      final jsonString = jsonEncode(data);

      await file.writeAsString(jsonString, flush: true);
    } catch (e) {
      throw Exception('Error saving profiles to file: $e');
    }
  }

  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      final file = await _localFile;
      final content = await file.readAsString();
      final List<dynamic> data = jsonDecode(content);
      return data.map((e) => ProfileModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error reading profiles from file: $e');
    }
  }

  Future<void> createProfile(ProfileModel profile) async {
    try {
      final profiles = await getAllProfiles();
      profiles.add(profile);
      await _saveAllProfiles(profiles);
    } catch (e) {
      throw Exception('Error creating new profile: $e');
    }
  }

  Future<void> updateProfile(ProfileModel updatedProfile) async {
    try {
      final profiles = await getAllProfiles();
      final index = profiles.indexWhere((p) => p.id == updatedProfile.id);
      if (index != -1) {
        profiles[index] = updatedProfile;
        await _saveAllProfiles(profiles);
      } else {
        throw Exception('Profile with id ${updatedProfile.id} not found');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      final profiles = await getAllProfiles();
      profiles.removeWhere((p) {
        if (p.id == id) {
          if (p.imagePath != null) {
            deletePhoto(p.imagePath!);
          }
        }
        return p.id == id;
      });
      await _saveAllProfiles(profiles);
    } catch (e) {
      throw Exception('Error deleting profile: $e');
    }
  }

  Future<void> deletePhoto(String path) async {
    await File(path).delete();
  }
}
