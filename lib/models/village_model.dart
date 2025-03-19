class Village {
  final String villageCode;
  final String name;
  final String fullName;

  Village({
    required this.villageCode,
    required this.name,
    required this.fullName,
  });

  // Factory constructor to create a Village from JSON
  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      villageCode: json['village_code'] as String,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
    );
  }

  // Method to convert Village back to JSON
  Map<String, dynamic> toJson() {
    return {
      'village_code': villageCode,
      'name': name,
      'full_name': fullName,
    };
  }
}