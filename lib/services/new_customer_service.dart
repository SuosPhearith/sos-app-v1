import 'package:dio/dio.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/commune_model.dart';
import 'package:wsm_mobile_app/models/district_model.dart';
import 'package:wsm_mobile_app/models/outlet_model.dart';
import 'package:wsm_mobile_app/models/provice_model.dart';
import 'package:wsm_mobile_app/models/village_model.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';

class NewCustomerService {
  Future<List<Outlet>> getOutlets() async {
    try {
      final response = await DioClient.dio.get(
        "/api/mobile/outlet-type",
        options: Options(headers: {'x-lang': 'kh'}),
      );
      final List<dynamic> jsonData = response.data as List<dynamic>;
      final List<Outlet> outlets = jsonData
          .map((item) => Outlet.fromJson(item as Map<String, dynamic>))
          .toList();

      return outlets;
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

  Future<List<Province>> getProvices() async {
    try {
      final response = await DioClient.dio.get(
        "/api/address/provinces",
        options: Options(headers: {'x-lang': 'kh'}),
      );
      final List<dynamic> jsonData = response.data as List<dynamic>;
      final List<Province> provinces = jsonData
          .map((item) => Province.fromJson(item as Map<String, dynamic>))
          .toList();

      return provinces;
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

  Future<List<District>> getDistricts({required String code}) async {
    try {
      final response = await DioClient.dio.get(
        "/api/address/districts/$code",
        options: Options(headers: {'x-lang': 'kh'}),
      );
      final List<dynamic> jsonData = response.data as List<dynamic>;
      final List<District> districts = jsonData
          .map((item) => District.fromJson(item as Map<String, dynamic>))
          .toList();

      return districts;
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
  Future<List<Commune>> getCommunes({required String code}) async {
    try {
      final response = await DioClient.dio.get(
        "/api/address/communes/$code",
        options: Options(headers: {'x-lang': 'kh'}),
      );
      final List<dynamic> jsonData = response.data as List<dynamic>;
      final List<Commune> data = jsonData
          .map((item) => Commune.fromJson(item as Map<String, dynamic>))
          .toList();

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
  Future<List<Village>> getVillages({required String code}) async {
    try {
      final response = await DioClient.dio.get(
        "/api/address/villages/$code",
        options: Options(headers: {'x-lang': 'kh'}),
      );
      final List<dynamic> jsonData = response.data as List<dynamic>;
      final List<Village> data = jsonData
          .map((item) => Village.fromJson(item as Map<String, dynamic>))
          .toList();

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
}
