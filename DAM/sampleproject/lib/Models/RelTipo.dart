import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';

class RelTipo extends Model{

  int idp;
  int idt;

  RelTipo({int idpp,int idtt})
  {

   this.idp = idpp;
   this.idt = idtt;
    

  }

  factory RelTipo.fromJson(Map<String,dynamic> json){

    return RelTipo(
      idpp: json['idP'] as int,
      idtt: json['idT'] as int
    );

  }



Future<int> createRelTipo(RelTipo rel) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/RelTipo';
  var body = json.encode(<String, String>{
      'IdP': rel.idp.toString(),
      'IdT': rel.idt.toString()
    
    });


   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}
  
Future<List> getRelTipo(int idpp, int idtt) async {
  
  http.Response response;

  if(idpp == 0 && idtt == 0)
  {
    response = await http.get(
      Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/RelTipo"),
      headers:{
        "Accept":"application/json"
      }
    );
  }
  else
  {
    response = await http.get(
      Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/RelTipo/"+ idpp.toString()+"/"+idtt.toString()),
      headers:{
        "Accept":"application/json"
      }
    );
  }


  List lista = json.decode(response.body);

  List<RelTipo> listau = new List<RelTipo>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(RelTipo.fromJson(lista[i]));
  

  return listau;
}
Future<int> deleteRelTipo(int idt,int idp) async {
print(idp);
  var url ='http://3b61d9bbb70d.ngrok.io/api/RelTipo/'+idt.toString()+"/"+idp.toString();

  


   http.Response response = await http.delete(url,
      headers: {"Content-Type": "application/json"},
  );

  return response.statusCode;
  
}


}