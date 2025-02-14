import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';
import 'package:sakay_app/presentation/screens/driver/driver_inb.dart';
import 'package:sakay_app/presentation/screens/driver/driver_location.dart';
import 'package:sakay_app/presentation/screens/driver/driver_notifcation.dart';
import 'package:sakay_app/presentation/screens/driver/driver_prof.dart';

class DriverManageVehicle extends StatefulWidget {
  const DriverManageVehicle({super.key});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<DriverManageVehicle> {
  bool isContainerVisible = false;
  int? selectedIndex = -1;

  void toggleContainer() {
    setState(() {
      isContainerVisible = !isContainerVisible;
      print("Container visibility: $isContainerVisible");
    });
  }

  void hideContainer() {
    setState(() {
      isContainerVisible = false;
    });
  }

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
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    iconSize: 22,
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
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
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey, size: 22),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! > 0) {
                      hideContainer();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 8),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.location_on,
                                    color: Colors.black, size: 20),
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phinma University of Pangasinan',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '28WV+R2R, Arellano St, Downtown District',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFE4E4E4),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.speed,
                                      color: Colors.black, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    '2.3 km',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: !isContainerVisible,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: toggleContainer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00A1F8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                "Manage Vehicle",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isContainerVisible
                      ? SingleChildScrollView(
                          child: Container(
                            key: UniqueKey(),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.route, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "Route",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Row(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(Icons.location_on, size: 15),
                                        SizedBox(width: 8),
                                        Text(
                                          "Dagupan",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Divider(
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Icon(Icons.location_on, size: 15),
                                        SizedBox(width: 8),
                                        Text(
                                          "Lingayen",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Seat Status",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 13),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceAround,
                                //   children: [
                                //     _statusButton("Full", Colors.red),
                                //     _statusButton("Half", Colors.orange),
                                //     _statusButton("Empty", Colors.green),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(3, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = selectedIndex == index
                                              ? null
                                              : index;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: selectedIndex == index
                                                  ? const Color(0xFF00A3FF)
                                                  : Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey, width: 2),
                                            ),
                                            child: Center(
                                              child: index == 0
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 2),
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  selectedIndex ==
                                                                          index
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                              width: 2,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children:
                                                              List.generate(2,
                                                                  (boxIndex) {
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          2),
                                                              width: 10,
                                                              height: 10,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: selectedIndex ==
                                                                          index
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    )
                                                  : index == 1
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children:
                                                              List.generate(2,
                                                                  (boxIndex) {
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          2),
                                                              width: 10,
                                                              height: 10,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: selectedIndex ==
                                                                          index
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                        )
                                                      : Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 2),
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  selectedIndex ==
                                                                          index
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                              width: 2,
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            index == 0
                                                ? 'Full'
                                                : index == 1
                                                    ? 'Half'
                                                    : 'Empty',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navBarItem(Icons.map, "Map", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverLocation()
                      ),
                    );
                  }),
                  _navBarItem(Icons.inbox, "Inbox", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DriverChatPage()),
                    );
                  }),
                  _navBarItem(Icons.notifications, "Notification", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverNotification()),
                    );
                  }),
                  _navBarItem(Icons.person, "Profile", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverProfile()),
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _statusButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _navBarItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF00A1F8)),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00A1F8),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
