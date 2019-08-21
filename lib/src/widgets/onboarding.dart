import 'package:flutter/material.dart';
import '../home.dart';
import 'dots_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("meTro Boston"),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index % _pages.length];
              },
              onPageChanged: (int i) {
                setState(() {
                  _currentIndex = i % _pages.length;
                });
              },
            ),
            new Positioned(
              bottom: 60.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                child: new DotsIndicator(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageSelected: (int page) {
                    _controller.animateToPage(
                      page,
                      duration: _kDuration,
                      curve: _kCurve,
                    );
                  },
                ),
              ),
            ),
            new Positioned(
              bottom: 46.0,
              right: 20.0,
              child: Container(
                height: 40.0,
                width: 100.0,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: _currentIndex == 3
                        ? [
                            Colors.greenAccent[400],
                            Colors.greenAccent[700],
                          ]
                        : [
                            Colors.blue[600],
                            Colors.blue[900],
                          ],
                    begin: Alignment(0.5, -1.0),
                    end: Alignment(0.5, 1.0),
                  ),
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  child: MaterialButton(
                    child: Text(_currentIndex == 3 ? "Continue" : "Skip"),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          maintainState: false, builder: (context) => Home()));
                    },
                    highlightColor: _currentIndex == 3
                        ? Colors.green.withOpacity(0.5)
                        : Colors.blue.withOpacity(0.5),
                    splashColor: _currentIndex == 3
                        ? Colors.green.withOpacity(0.5)
                        : Colors.blue.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _pages = [
    welcomePage(),
    page(
      title: "Commute",
      subtitle:
          "Enter your subway work commute to receive train arrival times and estimated arrival times at work",
      iconData: Icons.train,
      imageWidget: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(
              "assets/home.png",
              scale: 1.2,
            ),
            Image.asset(
              "assets/subway2.png",
              scale: 0.85,
            ),
            Image.asset(
              "assets/briefcase.png",
              scale: 1.2,
            ),
          ],
        ),
      ),
    ),
    page(
      title: "Saved",
      subtitle:
          "Create a list of frequently visited stops for easy access to stop information, alerts, and arrival times",
      iconData: Icons.star,
      imageWidget: Container(
        child: Image.asset("assets/subway1.png"),
      ),
    ),
    page(
      title: "Nearby",
      subtitle: "View nearby stops on a map to best calculate your trip",
      iconData: Icons.near_me,
      imageWidget: Container(
        child: Image.asset("assets/location.png"),
      ),
    ),
  ];

  static Widget welcomePage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Text(
              "Welcome your new Boston subway assistant",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Hind'),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text("Swipe to continue"),
                ),
                Container(
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget page(
      {@required String title,
      @required String subtitle,
      @required IconData iconData,
      @required Widget imageWidget}) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Container(),
          ),
          Flexible(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                imageWidget,
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(12.0),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                iconData,
                                size: 40.0,
                              ),
                            ),
                            Container(
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontSize: 21.0, fontFamily: 'Hind'),
                              ),
                            ),
                            Container(
                              height: 10.0,
                            ),
                            Container(
                              child: Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Hind',
                                    color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
