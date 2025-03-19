class District {
  final String districtCode;
  final String name;

  District({
    required this.districtCode,
    required this.name,
  });

  // Factory constructor to create a District from JSON
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      districtCode: json['district_code'] as String,
      name: json['name'] as String,
    );
  }

  // Method to convert District back to JSON
  Map<String, dynamic> toJson() {
    return {
      'district_code': districtCode,
      'name': name,
    };
  }
}