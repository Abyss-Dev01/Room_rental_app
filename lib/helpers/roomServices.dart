import 'package:http/http.dart' as http;
import 'package:myapp/models/roomModel.dart';

class RoomService {
  static const ADD_URL = "http://192.168.1.70/rentalapp/addRoom.php";
  static const VIEW_URL = "http://192.168.1.70/rentalapp/viewRoom.php";
  static const ADD_BOOKMARK_URL =
      "http://192.168.1.70/rentalapp/addBookmark.php";

  Future<String> addRoom(RoomModel roomModel) async {
    final response =
        await http.post(Uri.parse(ADD_URL), body: roomModel.toJsonAddRoom());
    if (response.statusCode == 200) {
      print('Add Response : ' + response.body);
      return response.body;
    } else {
      return "error";
    }
  }

  // List<RoomModel> roomFromJson(String jsonString) {
  //   final data = json.decode(jsonString);
  //   return List<RoomModel>.from(data.map((item) => RoomModel.fromJson(item)));
  // }

  // Future<List<RoomModel>> getRooms() async {
  //   final response = await http.get(Uri.parse(VIEW_URL));
  //   if (response.statusCode == 200) {
  //     List<RoomModel> list = roomFromJson(response.body);
  //     return list;
  //   } else {
  //     return <RoomModel>[];
  //   }
  // }
}
