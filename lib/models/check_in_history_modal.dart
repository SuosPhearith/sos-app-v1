class CheckInHistory {
  int id;
  String customerId;
  String checkinAt;
  String checkoutAt;
  int userId;
  double lat;
  double lng;

  // Constructor
  CheckInHistory({
    required this.id,
    required this.customerId,
    required this.checkinAt,
    required this.checkoutAt,
    required this.userId,
    required this.lat,
    required this.lng,
  });

  // Factory method to create an instance from JSON
  factory CheckInHistory.fromJson(Map<String, dynamic> json) {
    return CheckInHistory(
      id: json['id'] as int,
      customerId:
          json['customer_id'] == null ? '' : json['customer_id'] as String,
      checkinAt: json['checkin_at'] as String,
      checkoutAt:
          json['checkout_at'] == null ? "" : json['checkout_at'] as String,
      userId: json['user_id'] as int,
      lat: (json['lat'] as num).toDouble(), // Handle both int and double
      lng: (json['lng'] as num).toDouble(), // Handle both int and double
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'checkin_at': checkinAt,
      'checkout_at': checkoutAt,
      'user_id': userId,
      'lat': lat,
      'lng': lng,
    };
  }
}
