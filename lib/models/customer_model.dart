class Customer {
  final String id;
  final String phoneNumber;
  final String? avatar;
  final String name;
  final String? gender;
  final DateTime? birthday;
  final String? email;
  final String? nationality;
  final String wholesaleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.phoneNumber,
    this.avatar,
    required this.name,
    this.gender,
    this.birthday,
    this.email,
    this.nationality,
    required this.wholesaleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String,
      avatar: json['avatar'] as String?,
      name: json['name'] as String,
      gender: json['gender'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
      email: json['email'] as String?,
      nationality: json['nationality'] as String?,
      wholesaleId: json['wholesale_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'avatar': avatar,
      'name': name,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'email': email,
      'nationality': nationality,
      'wholesale_id': wholesaleId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
