class Outlet {
  final String code;
  final String name;

  Outlet({
    required this.code,
    required this.name,
  });

  // Factory constructor to create an Outlet from JSON
  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  // Method to convert Outlet back to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}