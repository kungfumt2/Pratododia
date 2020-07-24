import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sampleproject/Models/Utilizador.dart';
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'dart:typed_data';



class Cliente extends Model{

int iduser;

Cliente({int idu})
{
  iduser = idu;
}

factory Cliente.fromJson(Map<String,dynamic> json){

    return Cliente(
      
    idu: json['idUser'] as int
      

    );

  }

Future<List> getClientes() async {

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Cliente"),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Cliente> listau = new List<Cliente>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Cliente.fromJson(lista[i]));
  

  return listau;
}

Future<Utilizador> getcliente(int id) async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Cliente/"+ id.toString()),
    headers:{
      "Accept":"application/json"
    }
  );


  Utilizador user = Utilizador.fromJson(json.decode(response.body));

  
  

  return user;
}

Future<int> createCliente(Cliente cliente) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Cliente';
  var body = json.encode(<String, String>{
      'IdUser': cliente.iduser.toString()
      

    });



   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}

}