void printError({required String errorMessage, int? statusCode}) {
  final statusText = statusCode != null ? 'Status: $statusCode - ' : '';
  print('\x1B[31mError: $statusText$errorMessage\x1B[0m');
}
