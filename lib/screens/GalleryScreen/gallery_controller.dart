import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/scan_photo_model.dart';
import '../../repository/api_services.dart';
import '../../repository/network_function.dart';
import '../../widgets/common_widgets.dart';

class GalleryController extends GetxController {
  final ImagePicker picker = ImagePicker();
  RxBool isUploading = false.obs;
  RxBool isLoading = false.obs;
  Rx<ScanPhotoModel?> galleryModel = Rx<ScanPhotoModel?>(null);
  RxList<PhotoItem> galleryPhotos = <PhotoItem>[].obs;
  RxInt totalPhotos = 0.obs;

  void getGalleryData() {
    isLoading.value = true;
    NetworkFunctions.apiRequest(
      url: ApiServices.galleryApi,
      isShowLoader: true,
      method: 'get',
    ).then((response) {
      isLoading.value = false;
      if (response != null) {
        final model = ScanPhotoModel.fromJson(response);
        if (model.status == true) {
          galleryModel.value = model;
          galleryPhotos.assignAll(model.data?.photos ?? []);
          totalPhotos.value = model.data?.count ?? galleryPhotos.length;
        } else if (model.message != null && model.message!.isNotEmpty) {
          showToast(message: model.message!);
        }
      }
    });
  }

  void pickImageFromCamera() {
    picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    ).then((photo) {
      if (photo != null && photo.path.isNotEmpty) {
        uploadImages(imagePaths: [photo.path]);
      }
    });
  }

  void pickImagesFromGallery() {
    picker.pickMultiImage(
      imageQuality: 80,
    ).then((pickedImages) {
      if (pickedImages.isNotEmpty) {
        final List<String> paths = pickedImages.map((file) => file.path).where((path) => path.isNotEmpty).toList();
        if (paths.isNotEmpty) {
          uploadImages(imagePaths: paths);
        }
      }
    });
  }

  void uploadImages({required List<String> imagePaths}) {
    if (imagePaths.isEmpty) return;

    isUploading.value = true;
    NetworkFunctions.multiPartApiRequestWithMultiImages(
      url: ApiServices.uploadImgApi,
      isShowLoader: true,
      imageParam: 'images',
      imagePaths: imagePaths,
    ).then((response) {
      isUploading.value = false;
      if (response != null) {
        final model = ScanPhotoModel.fromJson(response);
        if (model.status == true) {
          showToast(message: model.message ?? 'Images uploaded successfully');
          if (model.data?.photos != null && model.data!.photos!.isNotEmpty) {
            galleryModel.value = model;
            galleryPhotos.addAll(model.data?.photos ?? []);
            totalPhotos.value += model.data!.count ?? galleryPhotos.length;
          } else {
            getGalleryData();
          }
        } else if (model.message != null && model.message!.isNotEmpty) {
          showToast(message: model.message!);
        }
      }
    });
  }

  void deletePhoto({required int id}) {
    NetworkFunctions.apiRequest(
      url: ApiServices.deleteApi,
      isShowLoader: true,
      body: {'id': id},
    ).then((response) {
      if (response != null) {
        if (response['status'] == true) {
          showToast(message: response['message']?.toString() ?? 'Photo deleted successfully');
          galleryPhotos.removeWhere((photo) => photo.id == id);
          totalPhotos.value = galleryPhotos.length;
        } else if (response['message'] != null) {
          showToast(message: response['message'].toString());
        }
      }
    });
  }

  void deleteAllPhotos() {
    NetworkFunctions.apiRequest(
      url: ApiServices.deleteAllApi,
      isShowLoader: true,
    ).then((response) {
      if (response != null) {
        if (response['status'] == true) {
          showToast(message: response['message']?.toString() ?? 'All photos deleted successfully');
          galleryPhotos.clear();
          totalPhotos.value = 0;
        } else if (response['message'] != null) {
          showToast(message: response['message'].toString());
        }
      }
    });
  }
}