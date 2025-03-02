import 'package:sakay_app/data/models/bus.dart';

abstract class BusRepo {
  Future<bool> saveBus(BusModel bus);
  Future<List<BusModel>> getAllBuses();
  Future<BusModel> getBus(String bus_id);
  Future<bool> editBus(BusModel bus);
  Future<bool> deleteBus(String bus_id);
  Future<bool> assignUserToBus(String user_id, String bus_id);
  Future<bool> reassignUserToBus(String user_id, String bus_id);
}
