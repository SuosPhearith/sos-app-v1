import 'package:flutter/foundation.dart';

void printError({required String errorMessage, int? statusCode}) {
  final statusText = statusCode != null ? 'Status: $statusCode - ' : '';
  if (kDebugMode) print('\x1B[31mError: $statusText$errorMessage\x1B[0m');
}
