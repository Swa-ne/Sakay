import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/user.dart';

class BusModel extends Equatable {
  final String? id;
  final String plate_number;
  final String bus_number;
  final UserModel? current_driver;
  final double? speed;
  final double? milage;

  const BusModel({
    this.id,
    required this.plate_number,
    required this.bus_number,
    this.current_driver,
    this.speed,
    this.milage,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['_id'],
      plate_number: json['plate_number'],
      bus_number: json['bus_number'],
      current_driver: json['current_driver'] != null
          ? UserModel.fromJson(json['current_driver']['user_id'])
          : null,
      speed: json['speed'],
      milage: json['milage'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'plate_number': plate_number,
      'bus_number': bus_number,
      'current_driver': current_driver,
      'speed': speed,
      'milage': milage,
    };
  }

  @override
  List<Object> get props => [plate_number, bus_number];
}
