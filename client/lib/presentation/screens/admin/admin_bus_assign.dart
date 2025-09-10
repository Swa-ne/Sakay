import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/bus/bus_bloc.dart';
import 'package:sakay_app/bloc/bus/bus_event.dart';
import 'package:sakay_app/bloc/bus/bus_state.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/presentation/screens/admin/admin_create_account.dart';

class AdminDriverAssign extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminDriverAssign({super.key, required this.openDrawer});

  @override
  _AdminDriverAssignState createState() => _AdminDriverAssignState();
}

class _AdminDriverAssignState extends State<AdminDriverAssign>
    with SingleTickerProviderStateMixin {
  late BusBloc _busBloc;

  final TextEditingController _busController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;

  List<BusModel> buses = [];
  List<UserModel> drivers = [];

  BusModel? selectedBus;
  UserModel? selectedDriver;

  Color _getCardColor(BuildContext context, Color originalColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (originalColor == Colors.white && isDark) {
      return Colors.grey[850]!;
    }
    return originalColor;
  }

  Color _getTextColor(BuildContext context, Color originalColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (originalColor == Colors.black || originalColor == Colors.grey) {
      return isDark ? Colors.white : originalColor;
    }
    if (originalColor == Colors.lightBlue) {
      return isDark ? Colors.lightBlueAccent : originalColor;
    }
    return originalColor;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _busBloc = BlocProvider.of<BusBloc>(context);

    _busBloc.add(GetAllBusesAndDriversEvent(DateTime.now()));
    _busBloc.add(GetAllDriversEvent(DateTime.now()));
  }

  @override
  void dispose() {
    _busController.dispose();
    _driverController.dispose();
    _searchController.dispose();
    _plateController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _saveBusChanges(BusModel updatedBus) {
    final int busIndex = buses.indexWhere((bus) => bus.id == updatedBus.id);

    if (busIndex == -1) {
      _showSnackBar('Bus not found');
      return;
    }

    if (buses.any((bus) =>
        bus.bus_number.toLowerCase() == updatedBus.bus_number.toLowerCase() &&
        bus.bus_number != buses[busIndex].bus_number)) {
      _showSnackBar('A bus with this name already exists');
      return;
    }

    if (buses.any((bus) =>
        bus.plate_number == updatedBus.plate_number &&
        bus.plate_number != buses[busIndex].plate_number)) {
      _showSnackBar('A bus with this plate number already exists');
      return;
    }

    setState(() {
      buses[busIndex] = updatedBus;
    });

    _showSnackBar('Bus updated successfully');
  }

  void _addBus() {
    final String name = _busController.text.trim();
    final String plate_number = _plateController.text.trim().toUpperCase();

    if (name.isEmpty || plate_number.isEmpty) {
      _showSnackBar('Please enter both bus name and plate number');
      return;
    }

    final RegExp plateFormat = RegExp(r'^[A-Z]{3}-\d{4}$');
    if (!plateFormat.hasMatch(plate_number)) {
      _showSnackBar('Invalid plate number format. Use format: ABC-1234');
      return;
    }

    if (buses
        .any((bus) => bus.bus_number.toLowerCase() == name.toLowerCase())) {
      _showSnackBar('A bus with this name already exists');
      return;
    }

    if (buses.any((bus) => bus.plate_number == plate_number)) {
      _showSnackBar('A bus with this plate number already exists');
      return;
    }

    _busBloc.add(
        PostBusEvent(BusModel(bus_number: name, plate_number: plate_number)));
  }

  void _addDriver() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminCreateDriverAccountPage(),
      ),
    );
  }

  void _assignDriver() {
    if (selectedBus == null || selectedDriver == null) {
      _showSnackBar('Please select both a bus and a driver');
      return;
    }

    if (_isDriverAssigned(selectedDriver!)) {
      _showSnackBar('This driver is already assigned to another bus');
      return;
    }
    _busBloc.add(AssignUserToBusEvent(selectedDriver!.id, selectedBus!.id!));
  }

  void _removeAssignment(BusModel bus, UserModel driver) {
    setState(() {
      int busIndex = buses.indexWhere((b) => b == bus);
      if (busIndex != -1) {
        List<UserModel> updatedDrivers = [...buses[busIndex].current_driver!];
        updatedDrivers.removeWhere((d) => d.id == driver.id);

        buses[busIndex] =
            buses[busIndex].copyWith(current_driver: updatedDrivers);
      }
    });

    _showSnackBar('Assignment removed successfully');
  }

  void _removeBus(BusModel bus) {
    setState(() {
      buses.remove(bus);
    });
    _showSnackBar('Bus removed');
  }

  // void _removeDriver(UserModel driver) {
  //   if (_isDriverAssigned(driver)) {
  //     _showSnackBar(
  //         'Cannot remove an assigned driver. Please remove the assignment first.');
  //     return;
  //   }

  //   setState(() {
  //     drivers.remove(driver);
  //   });
  //   _showSnackBar('Driver removed');
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  List<BusModel> get filteredBuses {
    return buses;
  }

  List<UserModel> get filteredDrivers {
    return drivers;
  }

  List<UserModel> get availableDrivers {
    return drivers
        .where((driver) => _isDriverAssigned(selectedDriver!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BusBloc, BusState>(
      listener: (context, state) {
        if (state is GetAllBusesAndDriversSuccess) {
          setState(() {
            buses.addAll(state.buses);
          });
        } else if (state is GetAllBusesAndDriversError) {
          _showSnackBar(state.error);
        }
        if (state is GetAllDriversSuccess) {
          setState(() {
            drivers.addAll(state.drivers);
          });
        } else if (state is GetAllDriversError) {
          _showSnackBar(state.error);
        }
        if (state is AssignUserToBusSuccess) {
          setState(() {
            int busIndex = buses.indexWhere((b) => b == selectedBus);
            if (busIndex != -1) {
              List<UserModel> updatedDrivers = [
                ...buses[busIndex].current_driver ?? []
              ];
              updatedDrivers.add(selectedDriver!);

              buses[busIndex] =
                  buses[busIndex].copyWith(current_driver: updatedDrivers);
            }

            selectedBus = null;
            selectedDriver = null;
          });

          _showSnackBar('Driver assigned successfully');
        } else if (state is AssignUserToBusError) {
          _showSnackBar(state.error);
        }
        if (state is SaveBusSuccess) {
          setState(() {
            buses.add(state.bus);
            _busController.clear();
            _plateController.clear();
          });
          _showSnackBar('Bus added successfully');
        } else if (state is SaveBusError) {
          _showSnackBar(state.error);
        }
        if (state is RemoveAssignUserToBusSuccess) {
          _removeAssignment(state.bus, state.driver);
        } else if (state is RemoveAssignUserToBusError) {
          _showSnackBar(state.error);
        }
        if (state is EditBusSuccess) {
          _saveBusChanges(state.bus);
        } else if (state is EditBusError) {
          _showSnackBar(state.error);
        }
        if (state is DeleteBusSuccess) {
          _removeBus(state.bus);
        } else if (state is DeleteBusError) {
          _showSnackBar(state.error);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBusesTab(),
                    _buildDriversTab(),
                    _buildAssignmentsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: Colors.lightBlue,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              widget.openDrawer();
            },
          ),
          const SizedBox(width: 8),
          const Text(
            'Manage Buses & Drivers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[850]
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor:
            isDark ? Colors.white : Colors.lightBlue,
        unselectedLabelColor:
            isDark ? Colors.white70 : Colors.grey,
        indicatorColor: isDark ? Colors.lightBlueAccent : Colors.lightBlue,
        labelStyle: const TextStyle(fontSize: 13),
        tabs: const [
          Tab(icon: Icon(Icons.directions_bus), text: 'Buses'),
          Tab(icon: Icon(Icons.person), text: 'Drivers'),
          Tab(icon: Icon(Icons.assignment), text: 'Assignments'),
        ],
      ),
    );
  }

  Widget _buildBusesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddBusCard(),
          const SizedBox(height: 20),
          Text(
            'Registered Buses (${filteredBuses.length})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.lightBlue,
            ),
          ),
          const SizedBox(height: 10),
          filteredBuses.isEmpty
              ? _buildEmptyState('No buses found', Icons.directions_bus)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredBuses.length,
                  itemBuilder: (context, index) {
                    final bus = filteredBuses[index];
                    return _buildBusCard(bus);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildAddBusCard() {
    return Card(
      color: _getCardColor(context, Colors.white),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Bus',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _getTextColor(context, Colors.lightBlue),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _busController,
              decoration: InputDecoration(
                labelText: 'Bus Name/Number',
                labelStyle: TextStyle(
                    fontSize: 13, color: _getTextColor(context, Colors.grey)),
                hintText: 'e.g., 001, 002, 003',
                prefixIcon: Icon(Icons.directions_bus,
                    color: _getTextColor(context, Colors.lightBlue)),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _plateController,
              decoration: InputDecoration(
                labelText: 'Plate Number',
                labelStyle: TextStyle(
                    fontSize: 13, color: _getTextColor(context, Colors.grey)),
                hintText: 'e.g., ABC-1234',
                prefixIcon: Icon(Icons.credit_card,
                    color: _getTextColor(context, Colors.lightBlue)),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addBus,
              icon: const Icon(Icons.add, color: Colors.white, size: 15),
              label: const Text(
                'Add Bus',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editBus(BusModel bus) {
    final oldBusNumber = bus.bus_number;
    final oldPlateNumber = bus.plate_number;
    final TextEditingController busNumberController =
        TextEditingController(text: bus.bus_number);
    final TextEditingController plateNumberController =
        TextEditingController(text: bus.plate_number);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Bus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: busNumberController,
                decoration: const InputDecoration(
                  labelText: 'Bus Name',
                  hintText: 'Enter bus name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: plateNumberController,
                decoration: const InputDecoration(
                  labelText: 'Plate Number',
                  hintText: 'Enter plate number',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bus = bus.copyWith(
                  bus_number: busNumberController.text,
                  plate_number: plateNumberController.text,
                );
                final RegExp plateFormat = RegExp(r'^[A-Z]{3}-\d{4}$');
                if (!plateFormat.hasMatch(bus.plate_number)) {
                  _showSnackBar(
                      'Invalid plate number format. Use format: ABC-1234');
                  return;
                }
                if (bus.bus_number != oldBusNumber ||
                    bus.plate_number != oldPlateNumber) {
                  _busBloc.add(EditBusEvent(bus));
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBusCard(BusModel bus) {
    return Card(
      elevation: 2,
      color: _getCardColor(context, Colors.white),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getCardColor(context, Colors.lightBlue.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(Icons.directions_bus,
              color: _getTextColor(context, Colors.lightBlue), size: 30),
        ),
        title: Text(
          "${bus.bus_number} - ${bus.plate_number}",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _getTextColor(context, Colors.black)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bus.current_driver != null && bus.current_driver!.isNotEmpty)
              ...bus.current_driver!.map((driver) => Text(
                    'Driver: ${driver.first_name} ${driver.last_name}',
                    style: TextStyle(color: Colors.green, fontSize: 13),
                  ))
            else
              Text(
                'No driver assigned',
                style: TextStyle(
                    color: _getTextColor(context, Colors.grey), fontSize: 13),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon:
                  Icon(Icons.edit, color: _getTextColor(context, Colors.blue)),
              onPressed: () => _editBus(bus),
            ),
            IconButton(
              icon:
                  Icon(Icons.delete, color: _getTextColor(context, Colors.red)),
              onPressed: () {
                _busBloc.add(DeleteBusEvent(bus));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriversTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddDriverCard(),
          const SizedBox(height: 20),
          Text(
            'Registered Drivers (${filteredDrivers.length})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.lightBlue,
            ),
          ),
          const SizedBox(height: 10),
          filteredDrivers.isEmpty
              ? _buildEmptyState('No drivers found', Icons.person)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDrivers.length,
                  itemBuilder: (context, index) {
                    final driver = filteredDrivers[index];
                    return _buildDriverCard(driver);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildAddDriverCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? Colors.grey[850] : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _addDriver,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
              icon: Icon(Icons.add, color: Colors.white, size: 25),
              label: const Text(
                'Add Driver',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDriverAssigned(UserModel driver) {
    for (var bus in buses) {
      if (bus.current_driver != null) {
        if (bus.current_driver!.any((d) => d.id == driver.id)) {
          return true;
        }
      }
    }
    return false;
  }

  Widget _buildDriverCard(UserModel driver) {
    bool isAssigned = _isDriverAssigned(driver);
    bool isWhiteCard = true;

    final cardColor = isWhiteCard
        ? (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white)
        : Colors.white;

    final textColor =
        Theme.of(context).brightness == Brightness.dark && isWhiteCard
            ? Colors.white
            : Colors.black;

    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.person, color: Colors.lightBlue, size: 30),
        ),
        title: Text(
          "${driver.first_name} ${driver.last_name}",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
            color: textColor,
          ),
        ),
        subtitle: Text(
          isAssigned ? 'Assigned' : 'Available',
          style: TextStyle(
            color: isAssigned ? Colors.orange : Colors.green,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssignmentForm(),
          const SizedBox(height: 20),
          const Text(
            'Current Assignments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.lightBlue,
            ),
          ),
          const SizedBox(height: 10),
          _buildAssignmentsList(),
        ],
      ),
    );
  }

  Widget _buildAssignmentForm() {
    bool isWhiteCard = true;

    final cardColor = isWhiteCard
        ? (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white)
        : Colors.white;

    final titleColor =
        Theme.of(context).brightness == Brightness.dark && isWhiteCard
            ? Colors.white
            : Colors.lightBlue;

    final labelColor =
        Theme.of(context).brightness == Brightness.dark && isWhiteCard
            ? Colors.white70
            : Colors.grey;

    final dropdownTextColor =
        Theme.of(context).brightness == Brightness.dark && isWhiteCard
            ? Colors.white
            : Colors.black;

    return Card(
      color: cardColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Assign Driver to Bus',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),
            // Dropdown for selecting a bus
            DropdownButtonFormField<BusModel>(
              decoration: InputDecoration(
                labelText: 'Select Bus',
                labelStyle: TextStyle(fontSize: 13, color: labelColor),
                prefixIcon:
                    const Icon(Icons.directions_bus, color: Colors.lightBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Colors.lightBlue.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Colors.lightBlue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      const BorderSide(color: Colors.lightBlue, width: 2),
                ),
              ),
              value: selectedBus,
              onChanged: (BusModel? newValue) {
                setState(() {
                  selectedBus = newValue;
                });
              },
              items: buses.map<DropdownMenuItem<BusModel>>((BusModel bus) {
                return DropdownMenuItem<BusModel>(
                  value: bus,
                  child: Text(
                    "${bus.bus_number} - ${bus.plate_number}",
                    style: TextStyle(fontSize: 13, color: dropdownTextColor),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Dropdown for selecting a driver
            DropdownButtonFormField<UserModel>(
              decoration: InputDecoration(
                labelText: 'Select Driver',
                labelStyle: TextStyle(fontSize: 13, color: labelColor),
                prefixIcon: const Icon(Icons.person, color: Colors.lightBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Colors.lightBlue.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Colors.lightBlue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      const BorderSide(color: Colors.lightBlue, width: 2),
                ),
              ),
              value: selectedDriver,
              onChanged: (UserModel? newValue) {
                setState(() {
                  selectedDriver = newValue;
                });
              },
              items:
                  drivers.map<DropdownMenuItem<UserModel>>((UserModel driver) {
                return DropdownMenuItem<UserModel>(
                  value: driver,
                  child: Text(
                    "${driver.first_name} ${driver.last_name}",
                    style: TextStyle(fontSize: 13, color: dropdownTextColor),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (selectedBus == null && selectedDriver == null) {
                  _showSnackBar("Please select both a bus and a driver");
                  return;
                }
                _assignDriver();
              },
              icon: const Icon(Icons.link, color: Colors.white, size: 15),
              label: const Text(
                'Assign Driver to Bus',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsList() {
    final assignedBuses = buses
        .where((bus) =>
            bus.current_driver != null && bus.current_driver!.isNotEmpty)
        .toList();

    if (assignedBuses.isEmpty) {
      return _buildEmptyState('No assignments yet', Icons.assignment);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assignedBuses.length,
      itemBuilder: (context, busIndex) {
        final bus = assignedBuses[busIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "${bus.bus_number} - ${bus.plate_number}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ...bus.current_driver!.map((driver) {
              return Card(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.assignment,
                        color: Colors.lightBlue, size: 30),
                  ),
                  title: Text(
                    'Driver: ${driver.first_name} ${driver.last_name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Assigned to ${bus.bus_number}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.link_off, color: Colors.red),
                    tooltip: 'Remove assignment',
                    onPressed: () {
                      _busBloc.add(RemoveAssignUserToBusEvent(bus, driver));
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.lightBlue.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
