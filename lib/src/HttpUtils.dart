part of basic_utils;

///
/// Helper class for http requests
///
class HttpUtils {
  static http.Client client = http.Client();
  static const String TAG = "HttpUtils";

  ///
  /// Sends a HTTP GET request to the given [url] with the given [queryParameters] and [headers].
  ///
  static Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic> queryParameters,
      Map<String, String> headers}) async {
    String finalUrl = addQueryParameterToUrl(url, queryParameters);
    Logger(TAG).info("GET $finalUrl");
    var response = await client.get(finalUrl, headers: headers);
    Logger(TAG).finest("Got response: " + response.body);
    return _responseHandler(response);
  }

  ///
  /// Sends a HTTP POST request to the given [url] with the given [body], [queryParameters] and [headers].
  ///
  static Future<Map<String, dynamic>> post(String url, String body,
      {Map<String, String> queryParameters,
      Map<String, String> headers}) async {
    String finalUrl = addQueryParameterToUrl(url, queryParameters);
    Logger(TAG).info("POST $finalUrl");
    Logger(TAG).finest("Request body: " + body);
    var response = await client.post(finalUrl, body: body, headers: headers);
    Logger(TAG).finest("Response body: " + response.body);
    return _responseHandler(response);
  }

  ///
  /// Sends a HTTP PUT request to the given [url] with the given [body], [queryParameters] and [headers].
  ///
  static Future<Map<String, dynamic>> put(String url, String body,
      {Map<String, String> queryParameters,
      Map<String, String> headers}) async {
    String finalUrl = addQueryParameterToUrl(url, queryParameters);
    Logger(TAG).info("PUT $finalUrl");
    Logger(TAG).finest("Request body: " + body);
    var response = await client.put(finalUrl, body: body, headers: headers);
    Logger(TAG).finest("Response body: " + response.body);
    return _responseHandler(response);
  }

  ///
  /// Sends a HTTP DELETE request to the given [url] with the given [queryParameters] and [headers].
  ///
  static Future<Map<String, dynamic>> delete(String url,
      {Map<String, String> queryParameters,
      Map<String, String> headers}) async {
    String finalUrl = addQueryParameterToUrl(url, queryParameters);
    Logger(TAG).info("DELETE $finalUrl");
    var response = await client.delete(finalUrl, headers: headers);
    Logger(TAG).finest("Response body: " + response.body);
    return _responseHandler(response);
  }

  ///
  /// Basic function which handle response and decode JSON. Throws [HttpClientException] if status code not 200-290
  ///
  static Object _responseHandler(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return json.decode(response.body);
    } else {
      throw HttpResponseException(
          "Response error ...", response.statusCode.toString(),
          body: response.body, headers: response.headers);
    }
  }

  ///
  /// Add the given [queryParameters] to the given [url].
  ///
  static String addQueryParameterToUrl(
      String url, Map<String, dynamic> queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) return url;
    return Uri.parse(url).replace(queryParameters: queryParameters).toString();
  }

  ///
  /// Fetches the query parameter from the given [url]. Returns null if none exist.
  ///
  static Map<String, dynamic> getQueryParameterFromUrl(String url) {
    Map<String, dynamic> queryParameters = new Map();
    List<String> splitted = url.split("?");
    if (splitted.length != 2) {
      return null;
    }
    String query = splitted.elementAt(1);

    List<String> splittedQuery = query.split("&");
    splittedQuery.forEach((String q) {
      List<String> pair = q.split("=");
      String key = Uri.decodeFull(pair[0]);
      String value = "";
      if (pair.length > 1) {
        value = Uri.decodeFull(pair[1]);
      }

      if (key.contains("[]")) {
        if (queryParameters.containsKey(key)) {
          List<String> values = queryParameters[key];
          values.add(value);
        } else {
          List<String> values = [];
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
