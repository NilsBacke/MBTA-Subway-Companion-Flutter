import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mbta_companion/src/screens/CommuteScreen/commute_screen.dart';
import 'package:mbta_companion/src/screens/ExploreScreen/explore_screen.dart';
import 'package:mbta_companion/src/screens/NearbyScreen/nearby_screen.dart';
import 'package:mbta_companion/src/screens/SavedStopsScreen/saved_screen.dart';
import 'package:mbta_companion/src/state/actions/allStopsActions.dart';
import 'package:mbta_companion/src/state/actions/commuteActions.dart';
import 'package:mbta_companion/src/state/actions/nearestStopActions.dart';
import 'package:mbta_companion/src/state/actions/polylinesActions.dart';
import 'package:mbta_companion/src/state/actions/savedStopsActions.dart';
import 'package:mbta_companion/src/state/actions/vehiclesActions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:mbta_companion/src/widgets/onboarding.dart';
import 'screens/stateless_screens/settings_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.train),
      title: Text('Commute'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      title: Text('Saved'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text('Explore'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.near_me),
      title: Text('Nearby'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
    )
  ];

  final List<Widget> _children = [
    CommuteScreen(),
    SavedScreen(),
    ExploreScreen(),
    NearbyScreen(),
    SettingsScreen()
  ];

  var _currentIndex = 0;
  static final _keyInitialLaunch = "initial_launch";

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectionSubscription;
  ConnectivityResult _connectionState = ConnectivityResult.mobile;
  bool initialLaunch;

  @override
  void initState() {
    super.initState();
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionState = result;
      });
    });
    SharedPreferences.getInstance().then((pref) {
      if (!pref.containsKey(_keyInitialLaunch)) {
        pref.setBool(_keyInitialLaunch, false);
        if (this.mounted) {
          setState(() {
            this.initialLaunch = true;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            this.initialLaunch = pref.getBool(_keyInitialLaunch);
          });
        }
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    _connectionSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (this.initialLaunch == null) {
      return Container();
    }

    if (this.initialLaunch == true) {
      return OnboardingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(titleForScreen(_currentIndex)),
      ),
      body: _connectionState == ConnectivityResult.none
          ? noInternetWidget()
          : _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: items,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget noInternetWidget() {
    return Container(
      child: Center(
        child: Text("No Internet Connection"),
      ),
    );
  }

  void onTabTapped(int index) {
    var store = StoreProvider.of(context);

    switch (_currentIndex) {
      case 0:
        store.dispatch(CommuteClearError());
        store.dispatch(NearestStopClearError());
        break;
      case 1:
        store.dispatch(SavedStopsClearError());
        break;
      case 2:
        store.dispatch(AllStopsClearError());
        break;
      case 3:
        store.dispatch(PolylinesClearError());
        store.dispatch(VehiclesClearError());
    }

    setState(() {
      _currentIndex = index;
    });
  }

  String titleForScreen(int index) {
    switch (index) {
      case 0:
        return 'Commute';
      case 1:
        return 'Saved';
      case 2:
        return 'Explore';
      case 3:
        return 'Nearby';
      case 4:
        return 'Settings';
      default:
        return 'meTro Boston';
    }
  }
}
