class PaginatedResponse<T> {
  final int currentPage;
  final List<T> data;
  final String firstPageUrl;
  final int? from; // Changed to nullable
  final String? nextPageUrl;
  final String path;
  final String perPage; // Kept as String per your design; see notes below
  final String? prevPageUrl;
  final int? to; // Changed to nullable

  PaginatedResponse({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from, // Now optional
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to, // Now optional
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    // Validate required fields
    if (!json.containsKey('current_page')) {
      throw FormatException('Missing required field: current_page');
    }
    if (!json.containsKey('data')) {
      throw FormatException('Missing required field: data');
    }
    if (!json.containsKey('first_page_url')) {
      throw FormatException('Missing required field: first_page_url');
    }
    if (!json.containsKey('path')) {
      throw FormatException('Missing required field: path');
    }
    if (!json.containsKey('per_page')) {
      throw FormatException('Missing required field: per_page');
    }

    // Parse fields with type checking and null safety
    final int currentPage = json['current_page'] is int
        ? json['current_page'] as int
        : throw FormatException(
            'current_page must be an integer, got ${json['current_page']} (${json['current_page'].runtimeType})');

    final List<dynamic> dataList = json['data'] is List<dynamic>
        ? json['data'] as List<dynamic>
        : throw FormatException(
            'data must be a list, got ${json['data']} (${json['data'].runtimeType})');
    final List<T> parsedData = dataList.map((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException(
            'data item must be a map, got $item (${item.runtimeType})');
      }
      try {
        return fromJsonT(item);
      } catch (e) {
        throw FormatException('Failed to parse data item $item: $e');
      }
    }).toList();

    final String firstPageUrl = json['first_page_url'] is String
        ? json['first_page_url'] as String
        : throw FormatException(
            'first_page_url must be a string, got ${json['first_page_url']} (${json['first_page_url'].runtimeType})');

    final int? from = json['from'] is int ? json['from'] as int : null;

    final String? nextPageUrl = json['next_page_url'] is String
        ? json['next_page_url'] as String
        : null;

    final String path = json['path'] is String
        ? json['path'] as String
        : throw FormatException(
            'path must be a string, got ${json['path']} (${json['path'].runtimeType})');

    final String perPage = json['per_page'] != null
        ? json['per_page'].toString()
        : throw FormatException(
            'per_page must be a string, got ${json['per_page']} (${json['per_page'].runtimeType})');

    final String? prevPageUrl = json['prev_page_url'] is String
        ? json['prev_page_url'] as String
        : null;

    final int? to = json['to'] is int ? json['to'] as int : null;

    return PaginatedResponse<T>(
      currentPage: currentPage,
      data: parsedData,
      firstPageUrl: firstPageUrl,
      from: from,
      nextPageUrl: nextPageUrl,
      path: path,
      perPage: perPage,
      prevPageUrl: prevPageUrl,
      to: to,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'current_page': currentPage,
      'data': data.map((item) => toJsonT(item)).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
    };
  }
}