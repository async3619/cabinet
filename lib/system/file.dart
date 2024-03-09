import 'dart:io';

import 'package:cabinet/database/image.dart';
import 'package:external_path/external_path.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileSystem {
  static final FileSystem _instance = FileSystem._internal();

  factory FileSystem() {
    return _instance;
  }

  FileSystem._internal();

  final uuid = const Uuid();

  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory('${directory.path}/images');
    if (!imagesDirectory.existsSync()) {
      imagesDirectory.createSync(recursive: true);
    }

    final thumbnailsDirectory = Directory('${directory.path}/thumbnails');
    if (!thumbnailsDirectory.existsSync()) {
      thumbnailsDirectory.createSync(recursive: true);
    }
  }

  Future<Image> saveImage(Image image) async {
    final url = image.url;
    final thumbnailUrl = image.thumbnailUrl;
    if (url == null) {
      throw Exception('Image url is null');
    }

    if (thumbnailUrl == null) {
      throw Exception('Thumbnail url is null');
    }

    final directory = await getApplicationDocumentsDirectory();
    final uuid = this.uuid.v4();
    final imageFileName = '$uuid.${url.split('.').last}';
    final thumbnailFileName = '$uuid.${thumbnailUrl.split('.').last}';

    final imageFile = File('${directory.path}/images/$imageFileName');
    final thumbnailFile =
        File('${directory.path}/thumbnails/$thumbnailFileName');

    if (imageFile.existsSync() && thumbnailFile.existsSync()) {
      throw Exception('Image already exists');
    }

    final imageBuffer =
        await http.get(Uri.parse(url)).then((response) => response.bodyBytes);
    final thumbnailBuffer = await http
        .get(Uri.parse(thumbnailUrl))
        .then((response) => response.bodyBytes);

    await imageFile.writeAsBytes(imageBuffer);
    await thumbnailFile.writeAsBytes(thumbnailBuffer);

    image.path = imageFile.path;
    image.thumbnailPath = thumbnailFile.path;

    return image;
  }

  Future<void> saveImageToGallery(Image image) async {
    final directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    final imagePath = '$directory/cabinet';
    final imageDirectory = Directory(imagePath);
    if (!imageDirectory.existsSync()) {
      imageDirectory.createSync(recursive: true);
    }

    final uuid = this.uuid.v4();
    final imageFileName = '$uuid.${image.extension}';
    final imageFile = File('$imagePath/$imageFileName');

    if (image.path == null) {
      if (!imageFile.existsSync()) {
        imageFile.createSync(recursive: true);
      }

      final imageBuffer = await http
          .get(Uri.parse(image.url!))
          .then((response) => response.bodyBytes);

      await imageFile.writeAsBytes(imageBuffer);
    } else {
      final oldFile = File(image.path!);
      await oldFile.copy(imageFile.path);
    }

    ImageGallerySaver.saveFile(imageFile.path);
  }
}
