import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:myapp/helpers/roomServices.dart';
import 'package:myapp/models/roomModel.dart';
import 'package:myapp/pages/mainPage.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/functions.dart';
import 'package:myapp/utils/sharedPreferenceService.dart';

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  String _roomid = DateTime.now().millisecondsSinceEpoch.toString();
  var userinput;
  final PrefService _prefService = PrefService();
  String localimage = '';
  Double? currentlatitude;
  Double? currentlongitude;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _latitude = TextEditingController();
  TextEditingController _longitude = TextEditingController();
  TextEditingController _price = TextEditingController();

  addRoom(RoomModel roomModel) async {
    await RoomService().addRoom(roomModel).then(
      (success) {
        Fluttertoast.showToast(
          msg: "Room Added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
        //print("added successfully");
      },
    );
  }

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
        appBar: AppBar(
          title: Text("Add Room here"),
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
                        "Username: -" + userinput,
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter Price here",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.monetization_on,
                            color: Colors.blue[200],
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length > 5 ||
                              value.length < 4) {
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
                        child: Text("Add"),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          RoomModel roomModel = RoomModel(
                            roomid: _roomid,
                            username: userinput,
                            image: localimage,
                            address: _address.text,
                            latitude: _latitude.text,
                            longitude: _longitude.text,
                            phone: _phone.text,
                            price: _price.text,
                          );
                          addRoom(roomModel);
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
