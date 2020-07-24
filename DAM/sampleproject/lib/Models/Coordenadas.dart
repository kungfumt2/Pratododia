import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_util/google_maps_util.dart';

class Coordenadas extends Model{

  int idprop;
  double clong;
  double clat;
  String cor;

  Coordenadas({int idp,double clo, double cla,String color})
  {

   this.idprop = idp;
   this.clong = clo;
   this.clat = cla;
   this.cor = color;

  }

  factory Coordenadas.fromJson(Map<String,dynamic> json){

    return Coordenadas(
      idp: json['idProp'] as int,
      clo: json['clong'] as double,
      cla: json['clat'] as double,
      color: json['cor'] as String
    );

  }



Future<int> createCoordenadas(Coordenadas coor) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Coordenadas';
  var body = json.encode(<String, String>{
      'IdProp': coor.idprop.toString(),
      'Clong': coor.clong.toString(),
      'Clat': coor.clat.toString(),
      'Cor':coor.cor
    
    });


   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}
  
Future<List> getCoordenadas() async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Coordenadas"),
    headers:{
      "Accept":"application/json"
    }
  );


  List lista = json.decode(response.body);

  List<Coordenadas> listau = new List<Coordenadas>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Coordenadas.fromJson(lista[i]));
  

  return listau;
}

Future<Coordenadas> getCoordenada(int idp) async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Coordenadas/"+idp.toString()),
    headers:{
      "Accept":"application/json"
    }
  );


   Coordenadas cor = Coordenadas.fromJson(json.decode(response.body));


  return cor;
}

Future<List> getrestaurantesGPS(double lat, double long, String prd, String pru, int iduser) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/GPS';



  http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(<String, String>{
      'Clat': lat.toString(),
      'Clong': long.toString(),
      'prefdia': prd,
      'prefutil':pru,
      'idcliente':iduser.toString(),
      
    
    }));

   List lista = json.decode(response.body);

  List<Coordenadas> listau = new List<Coordenadas>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Coordenadas.fromJson(lista[i]));

print(listau);
 return listau;


}


}