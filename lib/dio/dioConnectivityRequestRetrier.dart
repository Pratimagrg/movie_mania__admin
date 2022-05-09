import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier(
      {required this.dio, required this.connectivity});

  late StreamSubscription streamSubscription;

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    final responseCompleter = Completer<Response>();
    streamSubscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        responseCompleter.complete(dio.request(requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
              contentType: requestOptions.contentType,
              responseType: requestOptions.responseType,
              responseDecoder: requestOptions.responseDecoder,
            )));
      }
    });
    return responseCompleter.future;
  }

  void dispose() {
    streamSubscription.cancel();
  }
}
