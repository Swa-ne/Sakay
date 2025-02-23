import 'package:flutter/material.dart';

class AdminManageAccount extends StatefulWidget {
  const AdminManageAccount({super.key});

  @override
  State<AdminManageAccount> createState() => _AdminManageAccountState();
}

class _AdminManageAccountState extends State<AdminManageAccount>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Manage Accounts",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFEFEFEF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // TAB BAR
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(text: "Commuter"),
              Tab(text: "PWD"),
              Tab(text: "Driver"),
            ],
          ),

          // TAB BAR VIEWS
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAccountList(),
                _buildAccountList(),
                _buildAccountList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FUNCTION TO BUILD ACCOUNT LIST
  Widget _buildAccountList() {
    List<Map<String, String>> dummyAccounts = [
      {"name": "John Doe", "phone": "09123456789"},
      {"name": "Jane Smith", "phone": "09234567890"},
      {"name": "Alex Johnson", "phone": "09345678901"},
    ];

    return ListView.builder(
      itemCount: dummyAccounts.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4), // Reduced spacing
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 247, 247),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF00A3FF),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(dummyAccounts[index]["name"]!),
            subtitle: Text(dummyAccounts[index]["phone"]!),
            trailing: const Icon(Icons.delete, color: Colors.red),
          ),
        );
      },
    );
  }
}
