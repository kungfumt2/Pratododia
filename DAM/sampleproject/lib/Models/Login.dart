import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';


class Login extends Model{

  String username;
  String password;

  Login({String usern , String pw})
  {

    this.username = usern;
    this.password = pw;
  }

  

Future<List> makelogin(Login user) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Login';
  var body = json.encode(<String, String>{
      'username': user.username,
      'password': user.password,

    });

  print(body);



   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );
 print("lalalala");
    if(response.statusCode == 200)
    {
      int userid = int.parse(json.decode(response.body)["user"]);
      String role = json.decode(response.body)["role"] as String;
print("esta");
      return [userid,role];
    }
    else
    {  print("Entrou");
      return [];
    }
  
}
  
Future<String> getlogin(String what) async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Login/"+ what),
    headers:{
      "Accept":"application/json"
    }
  );


  String result = json.decode(response.body);

  
  return result;
}


}