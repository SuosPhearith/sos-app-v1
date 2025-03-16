import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Help {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static Future<String?> readTokenSafely() {
    return _storage.read(key: 'token').catchError((error) {
      return null;
    });
  }

  static String priceValueWithCurrency(double value, String currency) {
    String currencySymbol = currency == 'USD' ? "\$" : "$currency ";
    return "$currencySymbol${value.toStringAsFixed(2)}";
  }

  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  static String formatNumber(int number) {
    return number.toString().padLeft(3, '0');
  }

  static String getDayOfYear({DateTime? date, int digits = 3}) {
    // Use provided date or current date if null
    DateTime currentDate = date ?? DateTime.now();

    // Get January 1st of the year
    DateTime startOfYear = DateTime(currentDate.year, 1, 1);

    // Calculate day of year (1-based)
    int dayOfYear = currentDate.difference(startOfYear).inDays + 1;

    // Ensure it doesn't exceed 366 (max days in a leap year)
    if (dayOfYear > 366) dayOfYear = 366;

    // Format with leading zeros
    return dayOfYear.toString().padLeft(digits, '0');
  }

  static String generateOrderNumber(int number, int no) {
    String dayOfYear = getDayOfYear();
    String invoiceNo = formatNumber(number);
    String current = DateTime.now().millisecondsSinceEpoch.toString();
    return '$current-$dayOfYear$no$invoiceNo';
  }

  static String extractNumberAfterHyphen(String input) {
    if (input.contains('-')) {
      List<String> parts = input.split('-');
      String orderNumber = parts[1];
      if (orderNumber[3] == "1") {
        return parts.length > 1 ? 'SI-${parts[1]}' : '';
      } else {
        return parts.length > 1 ? 'SO-${parts[1]}' : '';
      }
    }
    return '';
  }

  static bool isValidKhmerPhoneNumber(String phoneNumber) {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[\s-]'), '');
    if (!cleanedNumber.startsWith('0') || cleanedNumber.length < 9 || cleanedNumber.length > 10) {
      return false;
    }
    if (!RegExp(r'^\d+$').hasMatch(cleanedNumber)) {
      return false;
    }
    const validPrefixes = [
      '010',
      '012',
      '013',
      '014',
      '015',
      '016',
      '017',
      '061',
      '066',
      '069',
      '070',
      '071',
      '077',
      '078',
      '080',
      '086',
      '087',
      '088',
      '089',
      '092',
      '093',
      '095',
      '097',
      '098',
    ];
    return validPrefixes.any((prefix) => cleanedNumber.startsWith(prefix));
  }
}
