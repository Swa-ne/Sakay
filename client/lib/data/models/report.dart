import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/user.dart';

class ReportModel extends Equatable {
  final String? id;
  final BusModel? bus;
  final String? bus_id;
  final UserModel? reporter;
  final UserModel? investigator;
  final UserModel? driver;
  final String type_of_report;
  final String description;
  final String? place_of_incident;
  final String? time_of_incident;
  final String? date_of_incident;
  final int? driving_rate;
  final int? service_rate;
  final int? reliability_rate;
  final bool is_open;
  final DateTime? created_at;
  final DateTime? updated_at;

  const ReportModel({
    this.id,
    this.bus,
    this.bus_id,
    this.reporter,
    this.investigator,
    this.driver,
    required this.type_of_report,
    required this.description,
    this.place_of_incident,
    this.time_of_incident,
    this.date_of_incident,
    this.driving_rate,
    this.service_rate,
    this.reliability_rate,
    required this.is_open,
    this.created_at,
    this.updated_at,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['_id'],
      bus: json['bus'] != null ? BusModel.fromJson(json['bus']) : null,
      bus_id: json['bus_id'],
      reporter: json['reporter'] != null
          ? UserModel.fromJson(json['reporter'])
          : null,
      investigator: json['investigator'] != null
          ? UserModel.fromJson(json['investigator'])
          : null,
      driver:
          json['driver'] != null ? UserModel.fromJson(json['driver']) : null,
      type_of_report: json['type_of_report'],
      description: json['description'],
      place_of_incident: json['place_of_incident'],
      time_of_incident: json['time_of_incident'],
      date_of_incident: json['date_of_incident'],
      driving_rate: (json['driving_rate'] as num?)?.toInt(),
      service_rate: (json['service_rate'] as num?)?.toInt(),
      reliability_rate: (json['reliability_rate'] as num?)?.toInt(),
      is_open: json['is_open'],
      created_at:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updated_at:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bus': bus?.toJson(),
      'bus_id': bus_id,
      'reporter': reporter?.toJson(),
      'investigator': investigator?.toJson(),
      'driver': driver?.toJson(),
      'type_of_report': type_of_report,
      'description': description,
      'place_of_incident': place_of_incident,
      'time_of_incident': time_of_incident,
      'date_of_incident': date_of_incident,
      'driving_rate': driving_rate,
      'service_rate': service_rate,
      'reliability_rate': reliability_rate,
      'is_open': is_open,
      'createdAt': created_at?.toIso8601String(),
      'updatedAt': updated_at?.toIso8601String(),
    };
  }

  ReportModel copyWith({
    String? id,
    BusModel? bus,
    String? bus_id,
    UserModel? reporter,
    UserModel? investigator,
    UserModel? driver,
    String? type_of_report,
    String? description,
    String? place_of_incident,
    String? time_of_incident,
    String? date_of_incident,
    int? driving_rate,
    int? service_rate,
    int? reliability_rate,
    bool? is_open,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return ReportModel(
      id: id ?? this.id,
      bus: bus ?? this.bus,
      bus_id: bus_id ?? this.bus_id,
      reporter: reporter ?? this.reporter,
      investigator: investigator ?? this.investigator,
      driver: driver ?? this.driver,
      type_of_report: type_of_report ?? this.type_of_report,
      description: description ?? this.description,
      place_of_incident: place_of_incident ?? this.place_of_incident,
      time_of_incident: time_of_incident ?? this.time_of_incident,
      date_of_incident: date_of_incident ?? this.date_of_incident,
      driving_rate: driving_rate ?? this.driving_rate,
      service_rate: service_rate ?? this.service_rate,
      reliability_rate: reliability_rate ?? this.reliability_rate,
      is_open: is_open ?? this.is_open,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  List<Object?> get props => [id, type_of_report, description, is_open];
}
