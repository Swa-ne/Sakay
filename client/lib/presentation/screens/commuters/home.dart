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
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a location...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Perform search action
                    final query = _searchController.text;
                    if (query.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Searching for "$query"...')),
                      );
                    }
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () async =>
                      _trackerBloc.add(StartTrackMyVehicleEvent()),
                  child: Text("pindot mo lang"),
                ),
                TextButton(
                  onPressed: () => _trackerBloc.add(StopTrackMyVehicleEvent()),
                  child: Text("stop mo lang"),
                )
              ],
            ),
          ),

          // Mock Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0), // Same as parent
                child: const Center(
                  child: MyMapWidget(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
