import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/user.dart';

abstract class BusRepo {
  Future<String> saveBus(BusModel bus);
  Future<List<BusModel>> getAllBuses();
  Future<List<BusModel>> getAllBusesAndAllDrivers();
  Future<BusModel> getBus(String bus_id);
  Future<bool> editBus(BusModel bus);
  Future<bool> deleteBus(String bus_id);
  Future<List<UserModel>> getAllDrivers();
  Future<UserModel> getDriver(String user_id);
  Future<bool> assignUserToBus(String user_id, String bus_id);
  Future<bool> removeAssignUserToBus(String user_id);
}
