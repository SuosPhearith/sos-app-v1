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
    String phone2 = '',
    String phone3 = '',
    String streetNo = '',
    String houseNo = '',
    required String addressName,
    required String villageCode,
    required String outletType,
    String lat = '',
    String lng = '',
    String hotspot = '',
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/api/mobile/register-customer",
        data: {
          "name": name,
          "name_kh": null,
          "phone_number": phone,
          "outlet_type": outletType,
          "village_code": villageCode,
          "phone_number_2": phone2,
          "phone_number_3": phone3,
          "street_no": streetNo,
          "house_no": houseNo,
          "address_name": addressName,
          "lat": lat,
          "lng": lng,
          "hotspot": hotspot,
        },
      );
      return response.data;
    } on DioException catch (_) {
      rethrow;
      // if (dioError.response != null) {
      //   printError(
      //     errorMessage: ErrorType.requestError,
      //     statusCode: dioError.response!.statusCode,
      //   );
      //   throw Exception(ErrorType.requestError);
      // } else {
      //   printError(
      //     errorMessage: ErrorType.networkError,
      //     statusCode: null,
      //   );
      //   throw Exception(ErrorType.networkError);
      // }
    } catch (e) {
      printError(errorMessage: 'Something went wrong.', statusCode: 500);
      throw Exception(ErrorType.unexpectedError);
    }
  }

  Future<Map<String, dynamic>> removeCustomer({
    required String id,
  }) async {
    try {
      final response = await DioClient.dio.delete(
        "/api/mobile/customer/$id/safe",
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
