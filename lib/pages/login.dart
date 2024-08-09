import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ui_2/config/config.dart';
import 'package:flutter_ui_2/config/internal_config.dart';
import 'package:flutter_ui_2/models/request/customer_login_post_req.dart';
import 'package:flutter_ui_2/models/response/customer_login_post_res.dart';
import 'package:flutter_ui_2/pages/register.dart';
import 'package:flutter_ui_2/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phoneNo = '';
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  

  // InitState คือ Function ที่ทำงานเมื่อเปิดหน้านี้
  // 1.InitState จะทำงาน "ครั้งเดียว" เมื่อเปิดหน้านี้
  // 2.มันจะไม่ทำงานเมื่อเราเรียก setState
  // 3.มันไม่สามารถทำงานเป็น async function ได้
   String url = '';
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
        // log(config ['apiEndpoint']);
      },
    ).catchError((err){
      log(err.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () {
                log('Image double tap');
              },
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'หมายเลขโทรศัพท์',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  TextField(
                      // onChanged: (value) {
                      //   phoneNo = value;
                      //   log(value);
                      // },
                      controller: phoneCtl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'รหัสผ่าน',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  TextField(
                      controller: passwordCtl,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => register(),
                      child: const Text('ลงทะเบียนใหม่')),
                  FilledButton(
                      onPressed: login, child: const Text('เข้าสู่ระบบ')),
                ],
              ),
            ),
            Text(text)
          ],
        ),
      ),
    );
  }

  void register() {
    // log('This is Register button');
    // setState(() {
    //    text = 'Hello World!!!';
    // });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }

//   void login() {
//     //   log('This is login');
//     //   setState(() {
//     //     number++;
//     //     text = 'Login time: $number';
//     //   });
//     // }
//     //   if (phoneCtl.text == '0812345678' && passwordCtl.text == '1234') {
//     //     log(phoneCtl.text);
//     //     Navigator.push(
//     //         context,
//     //         MaterialPageRoute(
//     //           builder: (context) => const ShowTropPage(),
//     //         ));
//     //     setState(() {
//     //       text = ' ';
//     //     });
//     //   } else {
//     //     setState(() {
//     //       text = 'phone no or password incorrect';
//     //     });
//     //   }
//     // }

//     // Call login api
//     var data = {"phone": "0817399999", "password": "1111"};
//     http
//         .post(Uri.parse("http://10.34.40.79:3000/customers/login"),
//             headers: {"Content-Type": "application/json; charset=utf-8"},
//             body: jsonEncode(data))
//         .then(
//       (value) {
//         log(value.body);
//       },
//     ).catchError((error) {
//       log('Error $error');
//     });
//   }
// }

  void login() async {
    try {
      // var data = {"phone": "0817399999", "password": "1111"};
      var data = CustomerLoginPostRequest(
          phone: phoneCtl.text, password: passwordCtl.text);
      var value = await http.post(
          Uri.parse('$API_ENDPOINT/customers/login'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(data));
      CustomersLoginPostResponse customer =
          customersLoginPostResponseFromJson(value.body);
      log(customer.customer.email);
       setState(() {
        text = '';
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  ShowTropPage(idx: customer.customer.idx),
          ));
    } catch (eeee) {
      log(eeee.toString());
      setState(() {
        text = 'phone no or password incorrect';
      });
    }
    // http
    //     .post(Uri.parse("http://10.34.40.42:3000/customers/login"),
    //         headers: {"Content-Type": "application/json; charset=utf-8"},
    //         body: customerLoginPostRequestToJson(data))
    //     .then(
    //   (value) {
    // CustomersLoginPostResponse customer =
    //     customersLoginPostResponseFromJson(value.body);
    // log(customer.customer.email);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const ShowTropPage(),
    //     ));
    //     // var jsonRes = jsonDecode(value.body);
    //     // log(jsonRes['customer']['email']);
    //   },
    // ).catchError((error) {
    //   setState(() {
    //     text = 'phone no or password incorrect';
    //   });
    // });
  }
}
