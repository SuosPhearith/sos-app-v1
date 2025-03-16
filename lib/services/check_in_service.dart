import 'package:dio/dio.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/category_model.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/models/product_model.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';

class CheckInService {
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
      final response = await DioClient.dio.get(
        "/api/mini/9e5b4d0b-834e-4f31-b8fa-56d6f20fa527/product/search",
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
}
