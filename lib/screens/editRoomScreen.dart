import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/screens/myRoomScreen.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/utils/sharedPreferenceService.dart';

class EditRoomScreen extends StatefulWidget {
  final String roomId;
  final image;
  final String address;
  final String latitude;
  final String longitude;
  final String phone;
  final String price;

  const EditRoomScreen({
    Key? key,
    required this.roomId,
    required this.image,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.price,
  }) : super(key: key);

  @override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final PrefService _prefService = PrefService();
  String _roomid = "";
  String _username = "";
  var localimage = '';
  Double? currentlatitude;
  Double? currentlongitude;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _latitude = TextEditingController();
  TextEditingController _longitude = TextEditingController();
  TextEditingController _price = TextEditingController();

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

  Future updateRoom(BuildContext cont) async {
    if (_phone.text == "" || _address.text == "" || _price.text == "") {
      Fluttertoast.showToast(
        msg: "Fields should not be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      var url = Uri.parse("http://192.168.1.70/rentalapp/updateRoom.php");
      var response = await http.post(
        url,
        body: {
          "roomid": _roomid,
          "image": localimage,
          "username": _username,
          "address": _address.text,
          "phone": _phone.text,
          "latitude": _latitude.text,
          "longitude": _longitude.text,
          "price": _price.text,
        },
      );
      var data = json.decode(response.body);
      if (data == "success") {
        Fluttertoast.showToast(
          msg: "Room Successfully Updated",
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
            msg: "Failed to update room",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _roomid = widget.roomId.toString();
    localimage = widget.image;
    _address.text = widget.address;
    _latitude.text = widget.latitude;
    _longitude.text = widget.longitude;
    _phone.text = widget.phone;
    _price.text = widget.price;
    _prefService.readCache("username").then((value) {
      setState(() {
        _username = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Details"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    chooseImage();
                  },
                  child: Icon(Icons.add_a_photo),
                ),
                SizedBox(
                  height: 20,
                ),
                localimage.isNotEmpty
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: MemoryImage(
                          base64Decode(localimage),
                        ),
                      )
                    : CircleAvatar(
                        radius: 60,
                      ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Room ID: -" + _roomid,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Username: -" + _username,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _getCurrentLocation();
                        },
                        child: Text(
                          "Click here to get accurate location info",
                          style: TextStyle(
                            foreground: Paint()..shader = noticeTextGradient,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _address,
                        //enabled: false,
                        decoration: InputDecoration(
                          hintText: "Your address here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter address";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _latitude,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Your latitude here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter latitude";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: _longitude,
                        decoration: InputDecoration(
                          hintText: "your longitude here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter longitude";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter Phone number here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 10 ||
                              value.length > 10) {
                            return "Invalid phone number";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Price here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.monetization_on,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Price";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text("Update"),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          updateRoom(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    final postion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final lastPosition = await Geolocator.getLastKnownPosition();
    print("last Position = $lastPosition");
    setState(() {
      _latitude.text = postion.latitude.toString();
      _longitude.text = postion.longitude.toString();
      _address.text = "Dharan-11, Nepal";
      //_getAddressFromLatLng();
    });
  }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(26.806416, 87.2842323);

  //     Placemark place = placemarks[0];

  //     setState(() {
  //       _currentAddress = "${place.locality}, ${place.country}";
  //       print(_currentAddress);
  //       _address.text = _currentAddress.toString();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  chooseImage() async {
    localimage = await pickImage();
  }
}
