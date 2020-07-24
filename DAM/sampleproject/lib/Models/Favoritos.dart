import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'dart:typed_data';


class Favoritos extends Model{

  int idcliente;
  int idprop;
  DateTime dataadd;


  Favoritos({int idc, int idp, DateTime date})
  {
    idcliente = idc;
    idprop = idp;
    dataadd = date;
  }


  factory Favoritos.fromJson(Map<String,dynamic> json){

    return Favoritos(
      
    idc: json['idCliente'] as int,
    idp: json['idProp'] as int,
    date: DateTime.parse(json['dataAdd']),
      

    );

  }


  Future<List> getFavoritos(int idc, int idp) async {

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Favoritos/"+idc.toString()+"/"+idp.toString()),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Favoritos> listau = new List<Favoritos>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Favoritos.fromJson(lista[i]));
  

  return listau;
}

Future<int> createFavoritos(Favoritos fav) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Favoritos';
  var body = json.encode(<String, String>{
      'IdCliente': fav.idcliente.toString(),
      'IdProp': fav.idprop.toString(),
      'DataAdd':fav.dataadd.toString()
      

    });



   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}

Future<int> deleteFavoritos(int idp, int idc) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Favoritos/'+idp.toString() + "/"+idc.toString();


   http.Response response = await http.delete(url,
      headers: {"Content-Type": "application/json"},
  );

  return response.statusCode;
  
}

}