import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/mainPage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // This list holds the data for the list view
  List? _foundrooms;
  //this holds all the data of rooms
  List? roomlist;

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

  void _runFilter(String enteredKeyword) {
    List? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = roomlist;
    } else {
      results = roomlist
          ?.where((room) => room['address']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
      print(results);
    }

    // Refresh the UI
    setState(() {
      _foundrooms = results;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _runFilter("");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search by address'),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: _foundrooms?.length != null
                    ? ListView.builder(
                        itemCount: _foundrooms?.length,
                        itemBuilder: (context, index) => Card(
                          color: Colors.amberAccent,
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    height: 100,
                                    width: 145,
                                    child: Image.memory(
                                      base64Decode(
                                        _foundrooms?[index]['image'],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Username: ${roomlist?[index]['username']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Address: ${roomlist?[index]['address']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Phone: ${roomlist?[index]['phone']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Price: ${roomlist?[index]['price']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
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
                        Stack(
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
                            Positioned(
                              left: 225.0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.bookmark_add,
                                  color: Colors.blue[700],
                                  size: 42,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
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
}
