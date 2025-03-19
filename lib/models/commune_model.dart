class Commune {
  final String communeCode;
  final String name;

  Commune({
    required this.communeCode,
    required this.name,
  });

  // Factory constructor to create a Commune from JSON
  factory Commune.fromJson(Map<String, dynamic> json) {
    return Commune(
      communeCode: json['commune_code'] as String,
      name: json['name'] as String,
    );
  }

  // Method to convert Commune back to JSON
  Map<String, dynamic> toJson() {
    return {
      'commune_code': communeCode,
      'name': name,
    };
  }
}