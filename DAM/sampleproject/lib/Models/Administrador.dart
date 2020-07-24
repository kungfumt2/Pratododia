import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sampleproject/Models/Utilizador.dart';
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'dart:typed_data';

class Administrador extends Model{

  int id;
  String username;
  String password;


  Administrador({int idd, String usrn, String pass})
  {
    id = idd;
    username = usrn;
    password = pass;
  }

  factory Administrador.fromJson(Map<String,dynamic> json){

    return Administrador(
      
    idd: json['id'] as int,
    usrn: json['username'] as String,
    pass: json['password'] as String

    );

  }

  Future<List> getadmnin(int ida) async {

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Administrador/" + ida.toString()),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Administrador> listau = new List<Administrador>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Administrador.fromJson(lista[i]));
  

  return listau;
}

}