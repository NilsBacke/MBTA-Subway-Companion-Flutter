import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/stateless_screens/about_screen.dart';
import 'package:mbta_companion/src/screens/stateless_screens/map_image_screen.dart';
import 'package:mbta_companion/src/utils/send_feedback.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  shareApp() {
    Share.share(
        "meTro: MBTA Subway and Companion App\niOS: https://apps.apple.com/pg/app/boston-subway-companion/id1464397684 \n Android: https://play.google.com/store/apps/details?id=com.plushundred.boston_t_companion&hl=en_US");
  }

  launchTwitter() async {
    const url = 'https://twitter.com/meTroBostonApp';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.map),
            title: Text('See Map'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MapImageScreen()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            subtitle: Text(
              'Build info, version number, acknowledgements',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutScreen()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Manage Permissions'),
            onTap: () {
              PermissionHandler().openAppSettings();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Send Feedback'),
            onTap: () {
              sendFeedback(context);
            },
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                Text("Share"),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.share,
                    size: 22.0,
                  ),
                ),
              ],
            ),
            onTap: shareApp,
          ),
          Divider(),
          ListTile(
            title: GestureDetector(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Follow us on Twitter for updates!",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Image.asset(
                      "assets/twitter.png",
                      height: 40,
                      width: 40,
                    ),
                  ],
                ),
              ),
              onTap: launchTwitter,
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
