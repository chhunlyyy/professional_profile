import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SaveImageToLocal {
  static Future<String> saveAndGetPath(File imageFile) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String newPath = '${appDocDir.path}/profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final File savedImage = await imageFile.copy(newPath);

    return savedImage.path;
  }
}
