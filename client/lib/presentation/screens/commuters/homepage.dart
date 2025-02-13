import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/common/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Tracker {
  final TextEditingController _searchController = TextEditingController();
  late TrackerBloc _trackerBloc;

  @override
  void initState() {
    super.initState();
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
    _trackerBloc.add(ConnectEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: MyMapWidget(),
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for a location...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Searching for "$query"...')),
                        );
                      }
                    },
                  ),
                  // TextButton(
                  //   onPressed: () async =>
                  //       _trackerBloc.add(StartTrackMyVehicleEvent()),
                  //   child: Text("pindot mo lang"),
                  // ),
                  // TextButton(
                  //   onPressed: () =>
                  //       _trackerBloc.add(StopTrackMyVehicleEvent()),
                  //   child: Text("stop mo lang"),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
