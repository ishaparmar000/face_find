import 'package:get/get.dart';
import '../../models/home_model.dart';
import '../../repository/api_services.dart';
import '../../repository/network_function.dart';

class HomeController extends GetxController {
  Rx<HomeModel?> homeModel = Rx<HomeModel?>(null);
  RxBool isLoading = false.obs;

  void getHomeData() {
    isLoading.value = true;
    NetworkFunctions.apiRequest(
      url: ApiServices.homeApi,
      isShowLoader: true,
      method: 'get',
    ).then((response) {
      isLoading.value = false;
      if (response != null) {
        final model = HomeModel.fromJson(response);
        if (model.status == true) {
          homeModel.value = model;
        }
      }
    });
  }
}
