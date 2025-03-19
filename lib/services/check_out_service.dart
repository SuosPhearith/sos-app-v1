import 'package:dio/dio.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/check_in_modal.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';

class CheckOutService {
  Future<Map<String, dynamic>> checkOut(
      {required CheckIn checkIn,
      required int checkInId,
      required List<String> ordered}) async {
    List<Map<String, dynamic>> items = ordered.map((item) {
      return {
        'type': 'Order',
        'id': item,
      };
    }).toList();
    try {
      final response = await DioClient.dio.post(
        "/api/mobile/checkin/$checkInId/checkout",
        data: {"customer_id": checkIn.customerId, "actions": items},
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

  Future<Map<String, dynamic>> checkOutAdvance(
      {required CheckIn checkIn, required List<String> ordered}) async {
    List<Map<String, dynamic>> items = ordered.map((item) {
      return {
        'type': 'Order',
        'id': item,
      };
    }).toList();
    try {
      final response = await DioClient.dio.post(
        "/api/mobile/advance-checkin",
        data: {
          "checkin_at": checkIn.checkinAt,
          "lat": checkIn.lat,
          "lng": checkIn.lng,
          "customer_id": checkIn.customerId,
          "actions": items
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
