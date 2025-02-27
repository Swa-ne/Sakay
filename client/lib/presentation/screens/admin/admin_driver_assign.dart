import 'package:flutter/material.dart';

void main() {
  runApp(const BusManagementApp());
}

class BusManagementApp extends StatelessWidget {
  const BusManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Management',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shadowColor: Colors.lightBlue.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.lightBlue.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.lightBlue.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.lightBlue.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const AdminDriverAssign(),
    );
  }
}

class Bus {
  final String name;
  String? driverName;

  Bus({required this.name, this.driverName});
}

class Driver {
  final String name;
  bool isAssigned;

  Driver({required this.name, this.isAssigned = false});
}

class AdminDriverAssign extends StatefulWidget {
  const AdminDriverAssign({Key? key}) : super(key: key);

  @override
  _AdminDriverAssignState createState() => _AdminDriverAssignState();
}

class _AdminDriverAssignState extends State<AdminDriverAssign> with SingleTickerProviderStateMixin {
  final TextEditingController _busController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;
  
  List<Bus> buses = [];
  List<Driver> drivers = [];
  
  Bus? selectedBus;
  Driver? selectedDriver;
  
  String searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    _addSampleData();
  }
  
  void _addSampleData() {
    buses.add(Bus(name: "UNIT-17A"));
    buses.add(Bus(name: "UNIT-24K"));
    
    drivers.add(Driver(name: "Samnple Driver A"));
    drivers.add(Driver(name: "Samnple Driver B"));
  }
  
  @override
  void dispose() {
    _busController.dispose();
    _driverController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _addBus() {
    if (_busController.text.trim().isEmpty) {
      _showSnackBar('Please enter a bus name');
      return;
    }
    
    if (buses.any((bus) => bus.name.toLowerCase() == _busController.text.trim().toLowerCase())) {
      _showSnackBar('A bus with this name already exists');
      return;
    }
    
    setState(() {
      buses.add(Bus(name: _busController.text.trim()));
      _busController.clear();
    });
    _showSnackBar('Bus added successfully');
  }

  void _addDriver() {
    if (_driverController.text.trim().isEmpty) {
      _showSnackBar('Please enter a driver name');
      return;
    }
    
    if (drivers.any((driver) => driver.name.toLowerCase() == _driverController.text.trim().toLowerCase())) {
      _showSnackBar('A driver with this name already exists');
      return;
    }
    
    setState(() {
      drivers.add(Driver(name: _driverController.text.trim()));
      _driverController.clear();
    });
    _showSnackBar('Driver added successfully');
  }

  void _assignDriver() {
    if (selectedBus == null || selectedDriver == null) {
      _showSnackBar('Please select both a bus and a driver');
      return;
    }
    
    if (selectedDriver!.isAssigned) {
      _showSnackBar('This driver is already assigned to another bus');
      return;
    }
    
    setState(() {
      selectedBus!.driverName = selectedDriver!.name;
      
      int driverIndex = drivers.indexWhere((d) => d.name == selectedDriver!.name);
      drivers[driverIndex].isAssigned = true;
      
      selectedBus = null;
      selectedDriver = null;
    });
    _showSnackBar('Driver assigned successfully');
  }

  void _removeAssignment(Bus bus) {
    if (bus.driverName == null) return;
    
    setState(() {
      int driverIndex = drivers.indexWhere((d) => d.name == bus.driverName);
      if (driverIndex != -1) {
        drivers[driverIndex].isAssigned = false;
      }
      
      bus.driverName = null;
    });
    _showSnackBar('Assignment removed');
  }

  void _removeBus(Bus bus) {
    setState(() {
      if (bus.driverName != null) {
        int driverIndex = drivers.indexWhere((d) => d.name == bus.driverName);
        if (driverIndex != -1) {
          drivers[driverIndex].isAssigned = false;
        }
      }
      
      buses.remove(bus);
    });
    _showSnackBar('Bus removed');
  }

  void _removeDriver(Driver driver) {
    if (driver.isAssigned) {
      _showSnackBar('Cannot remove an assigned driver. Please remove the assignment first.');
      return;
    }
    
    setState(() {
      drivers.remove(driver);
    });
    _showSnackBar('Driver removed');
  }

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

  List<Bus> get filteredBuses {
    if (searchQuery.isEmpty) return buses;
    return buses.where((bus) => 
      bus.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      (bus.driverName != null && bus.driverName!.toLowerCase().contains(searchQuery.toLowerCase()))
    ).toList();
  }

  List<Driver> get filteredDrivers {
    if (searchQuery.isEmpty) return drivers;
    return drivers.where((driver) => 
      driver.name.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  List<Driver> get availableDrivers {
    return drivers.where((driver) => !driver.isAssigned).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
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
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: Colors.lightBlue,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Manage Buses & Drivers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.lightBlue,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search buses or drivers...',
            prefixIcon: Icon(Icons.search, color: Colors.lightBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        labelColor: Colors.lightBlue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.lightBlue,
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
              fontSize: 18,
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
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Bus',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _busController,
              decoration: const InputDecoration(
                labelText: 'Bus Name/Number',
                hintText: 'e.g., Bus 101, School Bus A',
                prefixIcon: Icon(Icons.directions_bus, color: Colors.lightBlue),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addBus,
              icon: const Icon(Icons.add),
              label: const Text('Add Bus'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusCard(Bus bus) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.directions_bus, color: Colors.lightBlue, size: 30),
        ),
        title: Text(
          bus.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          bus.driverName != null ? 'Driver: ${bus.driverName}' : 'No driver assigned',
          style: TextStyle(
            color: bus.driverName != null ? Colors.green : Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeBus(bus),
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
              fontSize: 18,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Driver',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _driverController,
              decoration: const InputDecoration(
                labelText: 'Driver Name',
                hintText: 'e.g., John Smith',
                prefixIcon: Icon(Icons.person, color: Colors.lightBlue),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addDriver,
              icon: const Icon(Icons.add),
              label: const Text('Add Driver'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Card(
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
          driver.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          driver.isAssigned ? 'Assigned' : 'Available',
          style: TextStyle(
            color: driver.isAssigned ? Colors.orange : Colors.green,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeDriver(driver),
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
              fontSize: 18,
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Assign Driver to Bus',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Bus>(
              decoration: const InputDecoration(
                labelText: 'Select Bus',
                prefixIcon: Icon(Icons.directions_bus, color: Colors.lightBlue),
              ),
              value: selectedBus,
              hint: const Text('Select a bus'),
              isExpanded: true,
              items: buses.isEmpty
                  ? []
                  : buses.map((bus) {
                      return DropdownMenuItem(
                        value: bus,
                        child: Text(bus.name),
                      );
                    }).toList(),
              onChanged: buses.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        selectedBus = value;
                      });
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Driver>(
              decoration: const InputDecoration(
                labelText: 'Select Driver',
                prefixIcon: Icon(Icons.person, color: Colors.lightBlue),
              ),
              value: selectedDriver,
              hint: const Text('Select a driver'),
              isExpanded: true,
              items: availableDrivers.isEmpty
                  ? []
                  : availableDrivers.map((driver) {
                      return DropdownMenuItem(
                        value: driver,
                        child: Text(driver.name),
                      );
                    }).toList(),
              onChanged: availableDrivers.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        selectedDriver = value;
                      });
                    },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _assignDriver,
              icon: const Icon(Icons.link),
              label: const Text('Assign Driver to Bus'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsList() {
    final assignedBuses = buses.where((bus) => bus.driverName != null).toList();
    
    if (assignedBuses.isEmpty) {
      return _buildEmptyState('No assignments yet', Icons.assignment);
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assignedBuses.length,
      itemBuilder: (context, index) {
        final bus = assignedBuses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.assignment, color: Colors.lightBlue, size: 30),
            ),
            title: Text(
              bus.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Driver: ${bus.driverName}',
              style: const TextStyle(color: Colors.green),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.link_off, color: Colors.red),
              tooltip: 'Remove assignment',
              onPressed: () => _removeAssignment(bus),
            ),
          ),
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
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

