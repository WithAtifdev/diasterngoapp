
abstract class BaseApiServices {

  Future<dynamic> getApi(
      String url, {
        Map<String, String>? headers,
      });
  Future<dynamic> postApi(dynamic data,String url);

}