import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/editRoomScreen.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class MyRoomScreen extends StatefulWidget {
  const MyRoomScreen({Key? key}) : super(key: key);

  @override
  _MyRoomScreenState createState() => _MyRoomScreenState();
}

class _MyRoomScreenState extends State<MyRoomScreen> {
  String? userinput;
  String? roomid;
  var image;

  final PrefService _prefService = PrefService();
  //this holds all the data of rooms
  List? roomlist = [];

  Future getData() async {
    var url = Uri.parse("http://192.168.1.70/rentalapp/myRooms.php");
    var response = await http.get(url);
    //var dataResponse = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        roomlist = json.decode(response.body);
      });
      return roomlist;
    } else {
      Fluttertoast.showToast(
        msg: "No Room has been added by the user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.blueAccent[200],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _prefService.readCache("username").then((value) {
      setState(() {
        userinput = value.toString();
      });
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Rooms"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
        height: MediaQuery.of(context).size.height - 200,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: roomlist!.length,
          itemBuilder: (context, index) {
            image = roomlist![index]['image'];
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
                            image,
                            //roomlist?[index]['image'],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Room ID: ${roomlist![index]['roomid']}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Username: ${roomlist![index]['username']}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Address : ${roomlist![index]['address']}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Phone Number: ${roomlist![index]['phone']}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Price: ${roomlist![index]['price']}",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green)),
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              onPressed: () {
                                roomid = roomlist?[index]['roomid'].toString();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditRoomScreen(
                                      roomId: roomid.toString(),
                                      image: image,
                                      address: roomlist![index]['address'],
                                      latitude: roomlist![index]['latitude'],
                                      longitude: roomlist![index]['longitude'],
                                      phone: roomlist![index]['phone'],
                                      price: roomlist![index]['price'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red)),
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              onPressed: () {
                                deleteRoom(roomid.toString());
                              },
                            ),
                          ),
                        ],
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

  Future deleteRoom(String room) async {
    var url = Uri.parse("http://192.168.1.70/rentalapp/deleteRoom.php");
    var response = await http.post(
      url,
      body: {
        "roomid": room,
      },
    );
    var data = json.decode(response.body);
    if (data == "success") {
      Fluttertoast.showToast(
        msg: "Room Successfully removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.blueAccent[200],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyRoomScreen(),
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Failed to delete Room",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
