import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/user.dart';

class BusModel extends Equatable {
  final String? id;
  final String plate_number;
  final String bus_number;
  final List<UserModel>? current_driver;
  final UserModel? today_driver;
  final double? speed;
  final double? milage;
  final double? lat;
  final double? lng;

  const BusModel({
    this.id,
    required this.plate_number,
    required this.bus_number,
    this.current_driver,
    this.today_driver,
    this.speed,
    this.milage,
    this.lat,
    this.lng,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return BusModel(
      id: json['_id'],
      plate_number: json['plate_number'],
      bus_number: json['bus_number'],
      current_driver: json['current_driver'] != null
          ? (json['current_driver'] as List)
              .map((j) => UserModel.fromJson(j['user_id']))
              .toList()
          : null,
      today_driver: json['today_driver'] != null
          ? UserModel.fromJson(json['today_driver']['user_id'])
          : null,
      speed: parseDouble(json['speed']),
      milage: parseDouble(json['milage']),
      lat: parseDouble(json['lat']),
      lng: parseDouble(json['lng']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'plate_number': plate_number,
      'bus_number': bus_number,
      'current_driver': current_driver,
      'today_driver': today_driver,
      'speed': speed,
      'milage': milage,
      'lat': lat,
      'lng': lng,
    };
  }

  BusModel copyWith({
    String? id,
    String? plate_number,
    String? bus_number,
    List<UserModel>? current_driver,
    UserModel? today_driver,
    double? speed,
    double? milage,
    double? lat,
    double? lng,
  }) {
    return BusModel(
      id: id ?? this.id,
      plate_number: plate_number ?? this.plate_number,
      bus_number: bus_number ?? this.bus_number,
      current_driver: current_driver ?? this.current_driver,
      today_driver: today_driver ?? this.today_driver,
      speed: speed ?? this.speed,
      milage: milage ?? this.milage,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  @override
  List<Object> get props => [plate_number, bus_number];
}
