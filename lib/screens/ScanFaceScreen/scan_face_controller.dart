import 'dart:developer';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/scan_photo_model.dart';
import '../../repository/api_services.dart';
import '../../repository/network_function.dart';
import '../../widgets/common_widgets.dart';
import '../SearchResultsScreen/search_results_screen.dart';

class ScanFaceController extends GetxController {
  final ImagePicker picker = ImagePicker();
  RxString selectedImagePath = ''.obs;
  RxBool isScanning = false.obs;
  Rx<ScanPhotoModel?> scanResult = Rx<ScanPhotoModel?>(null);
  RxList<PhotoItem> matchingPhotos = <PhotoItem>[].obs;
  RxInt totalMatchingPhotos = 0.obs;

  void pickImage(ImageSource source) {
    picker.pickImage(
      source: source,
      imageQuality: 85,
    ).then((photo) {
      if (photo != null && photo.path.isNotEmpty) {
        selectedImagePath.value = photo.path;
        scanFaceApi();
      }
    });
  }

  void pickImageFromCamera() {
    pickImage(ImageSource.camera);
  }

  void pickImageFromGallery() {
    pickImage(ImageSource.gallery);
  }

  void scanFaceApi() {
    if (selectedImagePath.value.isEmpty) {
      showToast(message: 'Please select an image first');
      return;
    }

    isScanning.value = true;
    NetworkFunctions.multiPartApiRequestWithImage(
      url: ApiServices.faceScanApi,
      isShowLoader: true,
      imageParam: 'face',
      imagePath: selectedImagePath.value,
    ).then((response) {
      isScanning.value = false;
      if (response != null) {
        log('Face scan response: $response');
        final model = ScanPhotoModel.fromJson(response);
        if (model.status == true) {
          scanResult.value = model;
          matchingPhotos.assignAll(model.data?.photos ?? []);
          totalMatchingPhotos.value = model.data?.count ?? matchingPhotos.length;
          showToast(message: model.message ?? 'Face scanned successfully');
          Get.to(() => const SearchResultsScreen());
        } else if (model.message != null && model.message!.isNotEmpty) {
          showToast(message: model.message!);
        }
      }
    });
  }

  void resetSelectedImage() {
    selectedImagePath.value = '';
    scanResult.value = null;
    matchingPhotos.clear();
    totalMatchingPhotos.value = 0;
  }
}
