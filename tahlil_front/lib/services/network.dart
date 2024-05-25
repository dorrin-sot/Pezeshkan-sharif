import 'package:get/get.dart';

class NetworkService extends GetConnect {
  static NetworkService get instance {
    Get.put(NetworkService());
    return Get.find<NetworkService>();
  }

  @override
  void onInit() {
    withCredentials = true;
    maxAuthRetries = 3;
    httpClient.baseUrl = 'https://pezeshkan-sharif.liara.run';
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    Response<T> response = await super.get(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
    if (response.statusCode == 401 &&
        !url.contains('login') &&
        !url.contains('register') &&
        !url.contains('refresh') &&
        !url.contains('is_logged_in')) {
      for (int i = 0; i < maxAuthRetries; i++) {
        if ((await post('/auth/refresh', {})).statusCode == 200) break;
      }
      response = await super.get(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );
    }
    return response;
  }

  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    Response<T> response = await super.post(
      url,
      body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
    if (response.statusCode == 401 &&
        url != null &&
        !url.contains('login') &&
        !url.contains('register') &&
        !url.contains('refresh') &&
        !url.contains('is_logged_in')) {
      for (int i = 0; i < maxAuthRetries; i++) {
        if ((await super.post('/auth/refresh', {})).statusCode == 200) break;
      }
      response = await super.post(
        url,
        body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
    }
    return response;
  }
}
