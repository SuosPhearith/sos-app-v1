import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/category_model.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/models/product_model.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';

class CheckInService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Category>> getCategories() async {
    try {
      final response = await DioClient.dio.get("/api/mini/product/categories",
          options: Options(headers: {'x-lang': 'kh'}));
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<PaginatedResponse<Product>> getProducts({
    String categoryId = '',
    String keyword = '',
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      String? posId = await _storage.read(key: 'posId');
      if (posId == null) {
        throw Exception();
      }
      final response = await DioClient.dio.get(
        "/api/mini/$posId/product/search",
        queryParameters: {
          'category_id': categoryId,
          'keyword': keyword,
          'page': page,
          'perPage': perPage,
        },
        options: Options(headers: {'x-lang': 'kh'}),
      );
      final Map<String, dynamic> json = response.data as Map<String, dynamic>;
      PaginatedResponse<Product> data = PaginatedResponse<Product>.fromJson(
        json,
        (itemJson) =>
            Product.fromJson(itemJson), // Function to parse each product
      );

      return data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Map<String, dynamic>?> getCurrentLatLng() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return null;
      }
    } else if (permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = placemarks.isNotEmpty
          ? '${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}'
          : 'Unknown location';

      return {
        'lat': position.latitude,
        'lng': position.longitude,
        'address': address,
      };
    } catch (e) {
      // Fallback to last known position if timeout occurs
      final lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        // Get address for last known position
        // List<Placemark> placemarks = await placemarkFromCoordinates(
        //   lastPosition.latitude,
        //   lastPosition.longitude,
        // );

        // String address = placemarks.isNotEmpty
        //     ? '${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}'
        //     : 'Unknown location';

        return {
          'lat': lastPosition.latitude,
          'lng': lastPosition.longitude,
          'address': "Unknown",
        };
      }
      return null;
    }
  }

  Future<Map<String, dynamic>> makeCheckIn(
      {required String lat, required String lng}) async {
    try {
      final response = await DioClient.dio.post(
        "/api/mobile/checkin",
        data: {
          "lat": lat,
          "lng": lng,
        },
      );
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<Map<String, dynamic>> cancelCheckIn({required int id}) async {
    try {
      final response = await DioClient.dio.delete(
        "/api/mobile/checkin/$id",
      );
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<Map<String, dynamic>> getCheckInDetail({required String id}) async {
    try {
      final response = await DioClient.dio.get(
        "/api/mobile/visit/$id",
      );
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<Map<String, dynamic>> voidOrder({required String id}) async {
    try {
      final response = await DioClient.dio.post(
        "/api/mobile/order/$id/void",
      );
      return response.data;
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        printError(
          errorMessage: ErrorType.requestError,
          statusCode: dioError.response!.statusCode,
        );
        throw Exception(ErrorType.requestError);
      } else {
        printError(
          errorMessage: ErrorType.networkError,
          statusCode: null,
        );
        throw Exception(ErrorType.networkError);
      }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }
}
