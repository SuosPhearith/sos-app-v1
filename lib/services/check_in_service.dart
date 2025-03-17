import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    int perPage = 50,
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
}
