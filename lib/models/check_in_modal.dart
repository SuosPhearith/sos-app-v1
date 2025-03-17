class CheckIn {
  final String checkinAt; // DateTime for timestamp
  final double lat; // Latitude as double
  final double lng; // Longitude as double
  final String customerId; // Customer ID as String

  CheckIn({
    required this.checkinAt,
    required this.lat,
    required this.lng,
    required this.customerId,
  });

  // Factory constructor to create a CheckIn from JSON
  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      checkinAt: json['checkin_at'] as String,
      lat: double.parse(json['lat'] as String),
      lng: double.parse(json['lng'] as String),
      customerId: json['customer_id'] as String,
    );
  }

  // Method to convert CheckIn to JSON
  Map<String, dynamic> toJson() {
    return {
      'checkin_at': checkinAt,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'customer_id': customerId,
    };
  }

  // Optional: Override toString for better debugging
  @override
  String toString() {
    return 'CheckIn(checkinAt: $checkinAt, lat: $lat, lng: $lng, customerId: $customerId)';
  }
}
