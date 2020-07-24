import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';

class PreferenciasModel extends Model{

  int idt;
  int idc;
  DateTime dataadd;

  PreferenciasModel({int idtt,int idcc, DateTime da})
  {

   this.idt = idtt;
   this.idc = idcc;
   this.dataadd = da;
    

  }

  factory PreferenciasModel.fromJson(Map<String,dynamic> json){

    return PreferenciasModel(
      idtt: json['idT'] as int,
      idcc: json['idC'] as int,
      da: DateTime.parse(json['dataAdd'])
    );

  }



Future<int> createPreferencia(PreferenciasModel pref) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Preferencia';
  var body = json.encode(<String, String>{
      'IdT': pref.idt.toString(),
      'IdC': pref.idc.toString(),
      'DataAdd':pref.dataadd.toString()
    
    });


  http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
}
  
Future<List> getPreferencias(int idcc, int idtt) async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Preferencia/"+ idcc.toString()+"/"+idtt.toString()),
    headers:{
      "Accept":"application/json"
    }
  );


  if(response.statusCode == 200)
  {

    List lista = json.decode(response.body);

    List<PreferenciasModel> listau = new List<PreferenciasModel>();

    
    for(int i = 0; i < lista.length; i++)
      listau.add(PreferenciasModel.fromJson(lista[i]));
    

    return listau;
  }
  else
  {
    return [];
  }
  
}

Future<int> deletePreferencia(int idt, int idc) async {

print(idt);
print(idc);

  var url ='http://3b61d9bbb70d.ngrok.io/api/Preferencia/'+idt.toString()+"/"+idc.toString();

  var body = json.encode("");


   http.Response response = await http.delete(url,
      headers: {"Content-Type": "application/json"},
  );

  return response.statusCode;
  
}


}