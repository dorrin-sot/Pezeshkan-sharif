import 'package:get/get.dart';

class NetworkService extends GetConnect {
  static NetworkService get instance {
    Get.put(NetworkService());
    return Get.find<NetworkService>();
  }

  @override
  void onInit() {
    print('NetworkService:: onInit()');
    httpClient.baseUrl = 'https://pezeshkan-sharif.liara.run';
  }
}
