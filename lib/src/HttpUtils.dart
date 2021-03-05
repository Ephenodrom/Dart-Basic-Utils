import 'dart:convert';

import 'package:basic_utils/src/model/HttpRequestReturnType.dart';
import 'package:basic_utils/src/model/exception/HttpResponseException.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

///
/// Helper class for http requests
///
class HttpUtils {
  static Client client = Client();
  static const String TAG = 'HttpUtils';

  ///
  /// Sends a HTTP GET request to the given [url] with the given [queryParameters] and [headers].
  ///
  static Future<dynamic> _get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      HttpRequestReturnType returnType = HttpRequestReturnType.JSON}) async {
    var finalUrl = _getUriUrl(url, queryParameters);
    Logger(TAG).info('GET $finalUrl');
    var response = await client.get(Uri.parse(finalUrl), headers: headers);
    Logger(TAG).finest('Got response: ' + response.body);
    return _handleResponse(response, returnType);
  }

  ///
  /// Sends a HTTP GET request to the given [url] with the given [queryParameters] and [headers].
  /// Returns the full [Response] object.
  ///
  static Future<Response> getForFullResponse(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    return await _get(url,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.FULLRESPONSE) as Response;
  }

  ///
  /// Sends a HTTP GET request to the given [url] with the given [queryParameters] and [headers].
  /// Returns the response as a map using json.decode.
  ///
  static Future<Map<String, dynamic>> getForJson(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    return await _get(url,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.JSON) as Map<String, dynamic>;
  }

  ///
  /// Sends a HTTP GET request to the given [url] with the given [queryParameters] and [headers].
  /// Returns the response as a string.
  ///
  static Future<String> getForString(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    return await _get(url,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.STRING) as String;
  }

  ///
  /// Sends a HTTP POST request to the given [url] with the given [body], [queryParameters] and [headers].
  ///
  static Future<dynamic> _post(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers,
      HttpRequestReturnType returnType = HttpRequestReturnType.JSON}) async {
    var finalUrl = _getUriUrl(url, queryParameters);
    Logger(TAG).info('POST $finalUrl');
    if (body != null) {
      Logger(TAG).finest('Request body: ' + body);
    }
    var response = await client.post(Uri.parse(finalUrl), body: body, headers: headers);
    Logger(TAG).finest('Response body: ' + response.body);
    return _handleResponse(response, returnType);
  }

  ///
  /// Sends a HTTP POST request to the given [url] with the given [body], [queryParameters] and [headers].
  /// Returns the full [Response] object.
  ///
  static Future<Response> postForFullResponse(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _post(url,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.FULLRESPONSE) as Response;
  }

  ///
  /// Sends a HTTP POST request to the given [url] with the given [body], [queryParameters] and [headers].
  /// Returns the response as a map using json.decode.
  ///
  static Future<Map<String, dynamic>> postForJson(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _post(url,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.JSON) as Map<String, dynamic>;
  }

  ///
  /// Sends a HTTP POST request to the given [url] with the given [body], [queryParameters] and [headers].
  /// Returns the response as a string.
  ///
  static Future<String> postForString(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _post(url,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.STRING) as String;
  }

  ///
  /// Sends a HTTP PUT request to the given [url] with the given [body], [queryParameters] and [headers].
  ///
  static Future<dynamic> _put(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers,
      HttpRequestReturnType returnType = HttpRequestReturnType.JSON}) async {
    var finalUrl = _getUriUrl(url, queryParameters);
    Logger(TAG).info('PUT $finalUrl');
    if (body != null) {
      Logger(TAG).finest('Request body: ' + body);
    }
    var response = await client.put(Uri.parse(finalUrl), body: body, headers: headers);
    Logger(TAG).finest('Response body: ' + response.body);
    return _handleResponse(response, returnType);
  }

  ///
  /// Sends a HTTP PUT request to the given [url] with the given [body], [queryParameters] and [headers].
  /// Returns the full [Response] object.
  ///
  static Future<Response> putForFullResponse(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _put(url,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.FULLRESPONSE) as Response;
  }

  ///
  /// Sends a HTTP PUT request to the given [url] with the given [body], [queryParameters] and [headers].
  /// Returns the response as a map using json.decode.
  ///
  static Future<Map<String, dynamic>> putForJson(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _put(url,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.JSON) as Map<String, dynamic>;
  }

  ///
  /// Sends a HTTP PUT request to the given [url] with the given [body], [queryParameters] and [headers].
  /// Returns the response as a string.
  ///
  static Future<String> putForString(String url,
      {String? body,
      Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _put(url,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.STRING) as String;
  }

  ///
  /// Sends a HTTP DELETE request to the given [url] with the given [queryParameters] and [headers].
  ///
  static Future<dynamic> _delete(String url,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers,
      HttpRequestReturnType returnType = HttpRequestReturnType.JSON}) async {
    var finalUrl = _getUriUrl(url, queryParameters);
    Logger(TAG).info('DELETE $finalUrl');
    var response = await client.delete(Uri.parse(finalUrl), headers: headers);
    Logger(TAG).finest('Response body: ' + response.body);
    return _handleResponse(response, returnType);
  }

  ///
  /// Sends a HTTP DELETE request to the given [url] with the given [queryParameters] and [headers].
  /// Returns the full [Response] object.
  ///
  static Future<Response> deleteForFullResponse(String url,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _delete(url,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.FULLRESPONSE) as Response;
  }

  ///
  /// Sends a HTTP DELETE request to the given [url] with the given [queryParameters] and [headers].
  /// Returns the response as a map using json.decode.
  ///
  static Future<Map<String, dynamic>> deleteForJson(String url,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _delete(url,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.JSON) as Map<String, dynamic>;
  }

  ///
  /// Sends a HTTP DELETE request to the given [url] with the given [queryParameters] and [headers].
  /// Returns the response as a string.
  ///
  static Future<String> deleteForString(String url,
      {Map<String, String>? queryParameters,
      Map<String, String>? headers}) async {
    return await _delete(url,
        queryParameters: queryParameters,
        headers: headers,
        returnType: HttpRequestReturnType.STRING) as String;
  }

  ///
  /// Basic function which handle response and decode JSON. Throws [HttpClientException] if status code not 200-290
  ///
  static dynamic _handleResponse(
      Response response, HttpRequestReturnType returnType) {
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      switch (returnType) {
        case HttpRequestReturnType.JSON:
          return json.decode(response.body);
        case HttpRequestReturnType.STRING:
          return response.body;
        case HttpRequestReturnType.FULLRESPONSE:
          return response;
      }
    } else {
      throw HttpResponseException(
          'Error: Received status code ${response.statusCode.toString()}',
          response.statusCode.toString(),
          body: response.body,
          headers: response.headers);
    }
  }

  ///
  /// Add the given [queryParameters] to the given [url].
  ///
  static String addQueryParameterToUrl(
      String url, Map<String, dynamic>? queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) return url;
    return Uri.parse(url).replace(queryParameters: queryParameters).toString();
  }

  static Uri _getUriUrl(
      String url, Map<String, dynamic>? queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) return Uri.parse(url);
    return Uri.parse(url).replace(queryParameters: queryParameters);
  }

  ///
  /// Fetches the query parameter from the given [url]. Returns null if none exist.
  ///
  static Map<String, dynamic>? getQueryParameterFromUrl(String url) {
    var queryParameters = <String, dynamic>{};
    var splitted = url.split('?');
    if (splitted.length != 2) {
      return null;
    }
    var query = splitted.elementAt(1);

    var splittedQuery = query.split('&');
    splittedQuery.forEach((String q) {
      var pair = q.split('=');
      var key = Uri.decodeFull(pair[0]);
      var value = '';
      if (pair.length > 1) {
        value = Uri.decodeFull(pair[1]);
      }

      if (key.contains('[]')) {
        if (queryParameters.containsKey(key)) {
          List<dynamic> values = queryParameters[key];
          values.add(value);
        } else {
          var values = [];
          values.add(value);
          queryParameters.putIfAbsent(key, () => values);
        }
      } else {
        if (queryParameters.containsKey(key)) {
          queryParameters.update(key, (value) => value);
        } else {
          queryParameters.putIfAbsent(key, () => value);
        }
      }
    });
    if (queryParameters.isEmpty) {
      return null;
    } else {
      return queryParameters;
    }
  }
}
