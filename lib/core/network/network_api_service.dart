import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_exceptions/app_exception.dart';
import 'base_api_service.dart';



class NetworkApiService extends BaseApiServices {

  ///GetApi
  @override
  Future getApi(String url,  {
    Map<String, String>? headers,
  }) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        'No Internet Connection',
      );
    } on TimeoutException {
      throw FetchDataException(
          'Request Time Out');
    }
    return responseJson;
  }


  ///PostApi
  @override
  Future postApi(dynamic data, String url) async {
    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        'No Internet Connection',
      );
    } on TimeoutException {
      throw FetchDataException(
        'Request Time Out',
      );
    }
    return responseJson;
  }



  dynamic returnResponse(
      http.Response response,
      ) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(
          response.body.toString(),
        );
      case 401:
      case 403:
        throw UnauthorizedException(
          response.body.toString(),
        );
      default:
        throw FetchDataException(
          'Error occurred while communicating with server '
              'with status code ${response.statusCode}',
        );
    }
  }
}