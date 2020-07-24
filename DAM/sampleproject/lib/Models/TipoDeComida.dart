import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';

class TipoDeComida extends Model{

  int id;
  String tipo;


  TipoDeComida({int idd, String t})
  {
    this.id = idd;
    this.tipo = t;
    
  }

  factory TipoDeComida.fromJson(Map<String,dynamic> json){

    return TipoDeComida(
      
      idd: json['id'] as int,
      t: json['tipo'] as String,
     
    );

  }

 Future<List> getTipoDeComida() async {


  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/TipoDeComida"),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<TipoDeComida> listau = new List<TipoDeComida>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(TipoDeComida.fromJson(lista[i]));
  

  return listau;
}

Future<int> createTipoDeComida(TipoDeComida prop) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/TipoDeComida';
  var body = json.encode(<String, String>{
      'Id': prop.id.toString(),
      'Tipo': prop.tipo

    });



  http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  ).then((http.Response response) {
    
    return int.parse(json.decode(response.body));

  });
  
}

Future<TipoDeComida> getTipoDeComidaid(int idt) async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/TipoDeComida/"+ idt.toString()),
    headers:{
      "Accept":"application/json"
    }
  );


  TipoDeComida user = TipoDeComida.fromJson(json.decode(response.body));

  return user;
}

}