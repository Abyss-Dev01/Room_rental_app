import 'package:flutter/material.dart';
import 'package:myapp/screens/logoutScreen.dart';
import 'package:myapp/screens/myRoomScreen.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class ProfileScreem extends StatefulWidget {
  const ProfileScreem({Key? key}) : super(key: key);

  @override
  _ProfileScreemState createState() => _ProfileScreemState();
}

class _ProfileScreemState extends State<ProfileScreem> {
  final PrefService _prefService = PrefService();
  String userinput = "";

  @override
  void initState() {
    super.initState();
    _prefService.readCache("username").then((value) {
      setState(() {
        userinput = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  child: Row(
                    children: [
                      Text(
                        "User: ",
                        style: TextStyle(
                          fontSize: 24,
                          foreground: Paint()..shader = mainTextGradient,
                        ),
                      ),
                      Text(
                        userinput,
                        style: TextStyle(
                          fontSize: 24,
                          foreground: Paint()..shader = noticeTextGradient,
                        ),
                      ),
                    ],
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red.shade50),
                ),
              ),
              SizedBox(
                height: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyRoomScreen(),
                    ),
                  );
                },
                child: Text("My Rooms"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogoutScreen(),
                    ),
                  );
                },
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
