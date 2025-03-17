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
    int perPage = 50,
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
        "/api/mobile/register-customer",
        data: {
          "name": name,
          "name_kh": null,
          "phone_number": phone,
          "village_code": null,
          "phone_number_2": null,
          "phone_number_3": null,
          "street_no": null,
          "house_no": null,
          "address_name": null,
          "lat": null,
          "lng": null
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
}
