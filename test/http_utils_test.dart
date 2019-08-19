import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/src/model/exception/HttpResponseException.dart';
import 'package:http/http.dart';
import "package:test/test.dart";
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  test('Test addQueryParameterToUrl', () {
    Map<String, dynamic> queryParameters = new Map();
    queryParameters.putIfAbsent("hello", () => "world");
    queryParameters.putIfAbsent("list[]", () => ["item1", "item2"]);
    expect(
        HttpUtils.addQueryParameterToUrl(
            "super-api.com/dosomething", queryParameters),
        "super-api.com/dosomething?hello=world&list%5B%5D=item1&list%5B%5D=item2");
  });

  test('Test getQueryParameterFromUrl', () {
    expect(
        HttpUtils.getQueryParameterFromUrl("super-api.com/dosomething"), null);
    Map<String, dynamic> queryParameters = HttpUtils.getQueryParameterFromUrl(
        "super-api.com/dosomething?hello=world");
    expect(queryParameters.length, 1);
    expect(queryParameters.containsKey("hello"), true);
    expect(queryParameters["hello"], "world");

    queryParameters = HttpUtils.getQueryParameterFromUrl(
        "super-api.com/dosomething?hello=world&list[]=value1&list[]=value2");
    expect(queryParameters.length, 2);
    expect(queryParameters.containsKey("hello"), true);
    expect(queryParameters.containsKey("list[]"), true);
    expect(queryParameters["list[]"] is List<String>, true);
    expect(queryParameters["list[]"].length, 2);
  });

  test("Test get", () async {
    HttpUtils.client = MockClient((request) async {
      final mapJson = {'id': 123};
      return Response(json.encode(mapJson), 200);
    });
    final item = await HttpUtils.getForJson("api.com/item");
    expect(item["id"], 123);
  });

  test("Test delete", () async {
    HttpUtils.client = MockClient((request) async {
      return Response(json.encode({}), 200);
    });
    Map<String, dynamic> response =
        await HttpUtils.deleteForJson("api.com/item/1");
    expect(response.isEmpty, true);
  });

  test("Test get with 404", () async {
    HttpUtils.client = MockClient((request) async {
      return Response(json.encode({}), 404);
    });
    expect(HttpUtils.getForJson("api.com/item"),
        throwsA(TypeMatcher<HttpResponseException>()));
  });

  test("Test get with 500", () async {
    HttpUtils.client = MockClient((request) async {
      return Response(json.encode({}), 500);
    });
    expect(HttpUtils.getForJson("api.com/item"),
        throwsA(TypeMatcher<HttpResponseException>()));
  });

  test("Test post", () async {
    HttpUtils.client = MockClient((request) async {
      final mapJson = {'id': 123};
      return Response(json.encode(mapJson), 200);
    });
    final item = await HttpUtils.postForJson("api.com/item", "{'id': 123}");
    expect(item["id"], 123);
  });

  test("Test put", () async {
    HttpUtils.client = MockClient((request) async {
      final mapJson = {'id': 124};
      return Response(json.encode(mapJson), 200);
    });
    final item = await HttpUtils.putForJson("api.com/item", "{'id': 124}");
    expect(item["id"], 124);
  });

  test("Test response headers", () async {
    Map<String, String> headers = {
      "authorization":
          "ShelfAuthJwtSession eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXV..."
    };
    HttpUtils.client = MockClient((request) async {
      final mapJson = {'id': 123};
      return Response(json.encode(mapJson), 200, headers: headers);
    });
    Response response = await HttpUtils.getForFullResponse("api.com/item");
    expect(response.headers["authorization"],
        "ShelfAuthJwtSession eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXV...");
  });
}
