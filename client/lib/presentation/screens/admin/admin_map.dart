import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';

class AdminMap extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminMap({super.key, required this.openDrawer});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<AdminMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey),
            ),
            child: const ClipRRect(
              child: Center(
                child: MyMapWidget(),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () {
                    widget.openDrawer();
                  },
                );
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 70,
            right: 20,
            child: Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
