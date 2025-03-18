import 'package:dio/dio.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/invoice_modal.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';

class InvoiceService {
  Future<PaginatedResponse<Invoice>> getInvoices({
    String keyword = '',
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final response = await DioClient.dio.get("/api/mini/sale-order/history",
          queryParameters: {
            'keyword': keyword,
            'page': page,
            'perPage': perPage,
          },
          options: Options(headers: {'x-lang': 'kh'}));
      final Map<String, dynamic> json = response.data as Map<String, dynamic>;
      PaginatedResponse<Invoice> data = PaginatedResponse<Invoice>.fromJson(
        json,
        (itemJson) =>
            Invoice.fromJson(itemJson), // Function to parse each product
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

  Future<Map<String, dynamic>> getInvoicesDetail({
    required String orderNo,
  }) async {
    try {
      final response = await DioClient.dio.get(
          "/api/mini/sale-order/$orderNo/detail",
          options: Options(headers: {'x-lang': 'kh'}));
      final Map<String, dynamic> json = response.data as Map<String, dynamic>;
      return json;
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
}
