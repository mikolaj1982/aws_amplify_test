import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

final storageServiceProvider = Provider<StorageService>((ref) {
  final storageService = StorageService(
    ref: ref,
  );
  return storageService;
});

// final imageUrlProvider =
//     FutureProvider.autoDispose.family<String, String>((ref, key) async {
//   final storageService = ref.watch(storageServiceProvider);
//   return storageService.getImageUrl(key);
// });

class StorageService {
  StorageService({
    required Ref ref,
  });

  final uploadProgress = ValueNotifier<double>(0);

  // Future<String> getImageUrl(String key) async {
  //   final GetUrlResult result = await Amplify.Storage.getUrl(
  //     key: key,
  //     options: S3GetUrlOptions(expires: 60000),
  //   );
  //   debugPrint('Image URL: ${result.url}');
  //   return result.url;
  // }

  ValueNotifier<double> getUploadProgress() {
    return uploadProgress;
  }

  // Future<String?> uploadFile(File file) async {
  //   try {
  //     final extension = p.extension(file.path);
  //     final key = const Uuid().v1() + extension;
  //     await Amplify.Storage.uploadFile(
  //         local: file,
  //         key: key,
  //         onProgress: (progress) {
  //           uploadProgress.value = progress.getFractionCompleted();
  //         });
  //
  //     return key;
  //   } on Exception catch (e) {
  //     debugPrint(e.toString());
  //     return null;
  //   }
  // }

  void resetUploadProgress() {
    uploadProgress.value = 0;
  }
}
