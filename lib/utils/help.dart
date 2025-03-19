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
    if (!cleanedNumber.startsWith('0') ||
        cleanedNumber.length < 9 ||
        cleanedNumber.length > 10) {
      return false;
    }
    if (!RegExp(r'^\d+$').hasMatch(cleanedNumber)) {
      return false;
    }
    const validPrefixes = [
      '010',
      '011',
      '012',
      '015',
      '016',
      '017',
      '031',
      '060',
      '061',
      '067',
      '068',
      '069',
      '070',
      '076',
      '077',
      '078',
      '079',
      '080',
      '081',
      '085',
      '086',
      '087',
      '088',
      '089',
      '090',
      '092',
      '093',
      '095',
      '096',
      '097',
      '098',
      '099'
    ];
    return validPrefixes.any((prefix) => cleanedNumber.startsWith(prefix));
  }

  static String getFormattedCurrentDateTime() {
    DateTime now = DateTime.now();
    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  static String convertDateFormat(String inputDate) {
    // Split the input string "17/3/2025" into day, month, year
    List<String> parts = inputDate.split('/');

    // Extract day, month, and year
    String day =
        parts[0].padLeft(2, '0'); // Ensure 2 digits (e.g., "7" -> "07")
    String month =
        parts[1].padLeft(2, '0'); // Ensure 2 digits (e.g., "3" -> "03")
    String year = parts[2];

    // Format the output as "yyyy-MM-dd"
    return '$year-$month-$day';
  }
}
