import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/mainPage.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List? roomlist = [];
  var userinput;
  final PrefService _prefService = PrefService();
  Future getData() async {
    var url = Uri.parse("http://192.168.1.70/rentalapp/viewBookmark.php");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        roomlist = json.decode(response.body);
      });
      return roomlist;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
        appBar: AppBar(
          leading: Icon(
            Icons.bookmark,
            size: 30,
          ),
          title: Text(
            "Bookmarks",
            style: TextStyle(
              fontSize: 24,
              foreground: Paint()..shader = noticeTextGradient,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              dataRooms(context, roomlist),
            ],
          ),
        ),
      ),
    );
  }

  Widget dataRooms(BuildContext context, List? collection) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: roomlist?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  height: 400.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFFF9000),
                          blurRadius: 5,
                          spreadRadius: 3),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 180.0,
                          width: 300.0,
                          child: Image.memory(
                            base64Decode(
                              roomlist?[index]['image'],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Room ID: ${roomlist?[index]['roomid']}",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Username: ${roomlist?[index]['username']}",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "address : ${roomlist?[index]['address']}",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Phone Number: ${roomlist?[index]['phone']}",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Price: ${roomlist?[index]['price']}",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                            onPressed: () {
                              deleteBookmark(userinput);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Remove Bookmark",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future deleteBookmark(String user) async {
    var url = Uri.parse("http://192.168.1.70/rentalapp/deleteBookmark.php");
    var response = await http.post(
      url,
      body: {
        "username": user,
      },
    );
    var data = json.decode(response.body);
    if (data == "success") {
      Fluttertoast.showToast(
        msg: "Bookmark Successfully removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.blueAccent[200],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      //navigation
    } else {
      Fluttertoast.showToast(
          msg: "Failed to delete bookmark",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
