class Province {
  final String provinceCode;
  final String name;

  Province({
    required this.provinceCode,
    required this.name,
  });

  // Factory constructor to create a Province from JSON
  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      provinceCode: json['province_code'] as String,
      name: json['name'] as String,
    );
  }

  // Method to convert Province back to JSON
  Map<String, dynamic> toJson() {
    return {
      'province_code': provinceCode,
      'name': name,
    };
  }
}