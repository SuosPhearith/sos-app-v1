import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/cart_modal.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';

class CartService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> makeOrder(
      {required List<Cart> cart,
      required String customerId,
      required String deliveryDate,
      required String timeSlot,
      String remark = ""}) async {
    try {
      String? posId = await _storage.read(key: 'posId');
      if (posId == null) {
        throw Exception();
      }
      List<Map<String, dynamic>> items = cart.map((cartItem) {
        return {
          'product_id': cartItem.productId,
          'qty': cartItem.qty,
          'note': "N/A",
        };
      }).toList();
      final response = await DioClient.dio.post(
        "/api/mobile/order",
        data: {
          "items": items,
          "pos_app_id": posId,
          "customer_id": customerId,
          "delivery_date": deliveryDate,
          "time_slot": timeSlot,
          "remark": remark
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
