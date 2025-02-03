import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final double speed;
  final String timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.timestamp,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] is int)
          ? (json['latitude'] as int).toDouble()
          : json['latitude'] as double,
      longitude: (json['longitude'] is int)
          ? (json['longitude'] as int).toDouble()
          : json['longitude'] as double,
      speed: (json['speed'] is int)
          ? (json['speed'] as int).toDouble()
          : json['speed'] as double,
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'timestamp': timestamp,
    };
  }

  @override
  List<Object> get props => [latitude, longitude, speed, timestamp];
}
