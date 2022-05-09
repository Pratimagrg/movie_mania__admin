import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:movie_mania_admin/common/api.dart';
import 'package:movie_mania_admin/common/sharedPrefs.dart';
import 'package:movie_mania_admin/dio/dioConnectivityRequestRetrier.dart';

class Api {
  final dio = createDio();
  final tokenDio = Dio(BaseOptions(baseUrl: baseURL));

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() {
    return _singleton;
  }

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: baseURL,
      receiveTimeout: 15000,
      connectTimeout: 15000,
      sendTimeout: 15000,
    ));

    dio.interceptors.addAll({
      AppInterceptors(
          dio,
          DioConnectivityRequestRetrier(
              dio: dio, connectivity: Connectivity())),
    });

    return dio;
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;
  late DioConnectivityRequestRetrier requestRetrier;

  AppInterceptors(this.dio, this.requestRetrier);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? access = await SharedPrefs().getAccess();

    if (access != null) {
      options.headers['authorization'] = 'JWT ' + access;
      return handler.next(options);
    } else {
      return handler.next(options);
    }
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.error is SocketException) {
      return requestRetrier.scheduleRequestRetry(err.requestOptions);
    } else {
      switch (err.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw DeadlineExceededException(err.requestOptions);
        case DioErrorType.response:
          switch (err.response?.statusCode) {
            case 400:
              throw BadRequestException(err.requestOptions);
            case 401:
              throw UnauthorizedException(err.requestOptions);
            case 404:
              throw NotFoundException(err.requestOptions);
            case 409:
              throw ConflictException(err.requestOptions);
            case 500:
              throw InternalServerErrorException(err.requestOptions);
          }
          break;

        case DioErrorType.cancel:
          break;
        case DioErrorType.other:
          throw NoInternetConnectionException(err.requestOptions);
      }
      return handler.next(err);
    }
  }
}

class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
