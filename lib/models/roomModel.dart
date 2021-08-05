class RoomModel {
  String? roomid;
  String? username;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? price;
  String? image;

  RoomModel({
    this.roomid,
    this.username,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.price,
    this.image,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
        roomid: json['roomid'] as String,
        username: json['username'] as String,
        image: json['image'] as String,
        address: json['address'] as String,
        latitude: json['latitude'] as String,
        longitude: json['longitude'] as String,
        phone: json['phone'] as String,
        price: json['price'] as String);
  }

  Map<String, dynamic> toJsonAddRoom() {
    return {
      "roomid": roomid,
      "username": username,
      "image": image,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "phone": phone,
      "price": price
    };
  }
}
