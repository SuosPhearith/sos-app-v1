import 'package:dio/dio.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/customer_model.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';

class CustomerService {
  Future<PaginatedResponse<Customer>> getCustomers({
    String keyword = '',
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await DioClient.dio.get("/api/mini/customer",
          queryParameters: {
            'keyword': keyword,
            'page': page,
            'perPage': perPage,
          },
          options: Options(headers: {'x-lang': 'kh'}));
      final Map<String, dynamic> json = response.data as Map<String, dynamic>;
      PaginatedResponse<Customer> data = PaginatedResponse<Customer>.fromJson(
        json,
        (itemJson) =>
            Customer.fromJson(itemJson), // Function to parse each product
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
      printError(
          errorMessage: 'Something went wrong. ${e.toString()}',
          statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<Map<String, dynamic>> createNewCustomer({
    required String name,
    required String phone,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/api/mini/customer",
        data: {"name": name, "phone_number": phone},
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
