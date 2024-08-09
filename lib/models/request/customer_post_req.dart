// To parse this JSON data, do
//
//     final customerPostRequest = customerPostRequestFromJson(jsonString);

import 'dart:convert';

CustomerPostRequest customerPostRequestFromJson(String str) => CustomerPostRequest.fromJson(json.decode(str));

String customerPostRequestToJson(CustomerPostRequest data) => json.encode(data.toJson());

class CustomerPostRequest {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomerPostRequest({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomerPostRequest.fromJson(Map<String, dynamic> json) => CustomerPostRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
