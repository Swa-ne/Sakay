import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final double speed;
  final DateTime timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.timestamp,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
      speed: json['speed'],
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [latitude, longitude, speed, timestamp];
}
