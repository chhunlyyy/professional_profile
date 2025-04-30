import 'package:injectable/injectable.dart';
import 'package:professional_profiles/core/resource/usecase.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_contact_info_entity.dart';
import 'package:professional_profiles/features/profiles/domain/entities/profile_entity.dart';
import 'package:professional_profiles/features/profiles/domain/repositories/profiles_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@injectable
class CreateSampleProfiles extends UseCase<void, void> {
  //
  final ProfilesRepo _repo;
  CreateSampleProfiles(this._repo);
  //

  @override
  Future<void> call({required void params}) async {
    final prefs = await SharedPreferences.getInstance();
    const String isFirstStartAppKey = 'isFirstStartApp';
    bool isFirstStartApp = prefs.getBool(isFirstStartAppKey) ?? true;
    //
    if (isFirstStartApp) {
      for (var sampleProfile in _sampleProfilesData()) {
        await _repo.createProfile(sampleProfile);
      }
      prefs.setBool(isFirstStartAppKey, false);
    }
  }

  List<ProfileEntity> _sampleProfilesData() {
    return [
      ProfileEntity(
        id: const Uuid().v4(),
        name: 'Alice Johnson',
        role: 'Software Engineer',
        skills: ['Dart', 'Flutter', 'Firebase'],
        bio: 'Passionate Flutter developer with 5 years of experience.',
        imagePath: null,
        contact: ProfileContactInfoEntity(
          email: 'alice.johnson@example.com',
          linkedIn: 'https://linkedin.com/in/alicejohnson',
          github: 'https://github.com/alicejohnson',
        ),
      ),
      ProfileEntity(
        imagePath: null,
        id: const Uuid().v4(),
        name: 'Bob Smith',
        role: 'Backend Developer',
        skills: ['Node.js', 'Express', 'MongoDB'],
        bio: 'Backend expert specializing in Node.js and microservices.',
        contact: ProfileContactInfoEntity(
          email: 'bob.smith@example.com',
          linkedIn: 'https://linkedin.com/in/bobsmith',
          github: 'https://github.com/bobsmith',
        ),
      ),
      ProfileEntity(
        imagePath: null,
        id: const Uuid().v4(),
        name: 'Charlie Davis',
        role: 'UI/UX Designer',
        skills: ['Figma', 'Adobe XD', 'Sketch'],
        bio: 'Creative UI/UX designer focused on user-centered design.',
        contact: ProfileContactInfoEntity(
          email: 'charlie.davis@example.com',
          linkedIn: 'https://linkedin.com/in/charliedavis',
          github: 'https://github.com/charliedavis',
        ),
      ),
    ];
  }
}
