# HttpUtils

## Examples

### Foo

```dart

```

## All methods

```dart
Future<Map<Response> getForFullResponse(String url, {Map<String, dynamic> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> getForJson(String url, {Map<String, dynamic> queryParameters, Map<String, String> headers});
Future<String> getForString(String url, {Map<String, dynamic> queryParameters, Map<String, String> headers});
Future<Map<Response> postForFullResponse(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> postForJson(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<String> postForString(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Response> putForFullResponse(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> putForJson(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<String> putForString(String url, {String body, Map<String, String> queryParameters, Map<String, String> headers});
Future<Response deleteForFullResponse(String url, {Map<String, String> queryParameters, Map<String, String> headers});
Future<Map<String, dynamic>> deleteForJson(String url, {Map<String, String> queryParameters, Map<String, String> headers});
Future<String> deleteForString(String url, {Map<String, String> queryParameters, Map<String, String> headers});
Map<String, dynamic> getQueryParameterFromUrl(String url);
String addQueryParameterToUrl(String url, Map<String, dynamic> queryParameters);
```
