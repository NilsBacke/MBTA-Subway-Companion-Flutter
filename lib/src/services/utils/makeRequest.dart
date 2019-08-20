import 'dart:convert';
import 'package:mbta_companion/src/utils/api_request_counter.dart';
import 'executeCall.dart';

class Result {
  final dynamic payload;
  final bool hasError;
  final String error;

  Result(this.payload, this.hasError, this.error);
}

Future<Result> makeRequest(Method method, String route,
    {Map<String, String> headers, String body}) async {
  if (APIRequestCounter.debug) {
    print("request url: $route");
    APIRequestCounter.incrementCalls(route);
  }

  var result;
  try {
    result = await executeCall(
        new GenericRequest(method, route, headers: headers, body: body));
  } catch (e) {
    var jsonResult;
    if (result != null && result.body) {
      jsonResult = json.decode(result.body);
    }
    print(
        'Error making $method request to $route: ${result.statusCode}, ${result.reasonPhrase}');
    return new Result(jsonResult ?? null, true,
        'Error making $method request to $route: ${result.statusCode}, ${result.reasonPhrase}');
  }

  if (result.statusCode != 200) {
    final jsonResult = json.decode(result.body);
    print(
        'Error making $method request to $route: ${result.statusCode}, ${result.reasonPhrase}');
    return new Result(jsonResult, true,
        'Error making $method request to $route: ${result.statusCode}, ${result.reasonPhrase}');
  }

  final jsonResult = json.decode(result.body);

  return new Result(jsonResult, false, '');
}
