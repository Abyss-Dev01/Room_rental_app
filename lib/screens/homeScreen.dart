import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/addRoomScreen.dart';
import 'package:myapp/screens/searchScreen.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userinput;
  String? roomid;
  var imageString;
  final PrefService _prefService = PrefService();
  //this holds all the data of rooms
  List? roomlist = [];
  List? bookmarklist;
  Future getData() async {
    var url = Uri.parse("http://192.168.1.70/rentalapp/viewRoom.php");
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
    CircularProgressIndicator();
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
          toolbarHeight: 40,
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          ),
          title: Text(
            "Click search icon for searching",
            style: TextStyle(fontSize: 14),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              dataRooms(context, roomlist),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRoomScreen(),
              ),
            );
          },
          tooltip: 'Add Room',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget dataRooms(BuildContext context, List? collection) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 200,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: roomlist!.length,
          itemBuilder: (context, index) {
            imageString = roomlist![index]['image'];
            roomid = roomlist![index]['roomid'];
            return Padding(
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
                          "Address : ${roomlist?[index]['address']}",
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green)),
                          child: Text(
                            "Bookmark",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            addBookmark(
                              roomid.toString(),
                              imageString,
                              roomlist![index]['address'].toString(),
                              roomlist![index]['latitude'].toString(),
                              roomlist![index]['longitude'].toString(),
                              roomlist![index]['phone'].toString(),
                              roomlist![index]['price'].toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future addBookmark(String id, var image, String address, String latitude,
      String longitude, String phone, String price) async {
    var url = Uri.parse("http://192.168.1.70/rentalapp/addBookmark.php");
    var response = await http.post(
      url,
      body: {
        "roomid": id,
        "image": image,
        "username": userinput,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "phone": phone,
        "price": price,
      },
    );
    var data = json.decode(response.body);
    if (data == "success") {
      Fluttertoast.showToast(
        msg: "Bookmark Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.white,
        textColor: Colors.green,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Bookmark could not be added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
