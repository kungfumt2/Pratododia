import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'dart:typed_data';



class Proprietario extends Model{

  int iduser;
  String nomerestaurante;
  double avaliacao;
  String descricao;

  bool premium;


  Proprietario({int idu, String nr, double ava, String dsc, bool p })
  {
    iduser = idu;
    nomerestaurante = nr;
    avaliacao = ava;
    descricao = dsc;
    premium = p;
  }

  factory Proprietario.fromJson(Map<String,dynamic> json){

    return Proprietario(
      
      idu: json['idUser'] as int,
      nr: json['nomeRestaurante'] as String,
      ava: json['avaliacao'] as double,
      dsc: json['descricao'] as String,
      p: json['premium'] as bool

    );

  }

 Future<List> getProprietarios() async {


  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Proprietario"),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Proprietario> listau = new List<Proprietario>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Proprietario.fromJson(lista[i]));
  

  return listau;
}

Future<int> createProprietario(Proprietario prop) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Proprietario';
  var body = json.encode(<String, String>{
      'IdUser': prop.iduser.toString(),
      'NomeRestaurante': prop.nomerestaurante,
      'Avaliacao':prop.avaliacao.toString(),
      'Descricao': prop.descricao,
      'Premium': prop.premium.toString()

    });



   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}

void updateProprietario(int id, String what, int intev, String svalue, String gopremium) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Proprietario/' + id.toString();
  var body = json.encode(what + "|"+intev.toString()+"|"+svalue+"|"+gopremium);



  http.put(url,
      headers: {"Content-Type": "application/json"},
      body: body
  ).then((http.Response response) {
    

  });
  
}

Future<Proprietario> getProprietario(int id) async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Proprietario/"+ id.toString()),
    headers:{
      "Accept":"application/json"
    }
  );


  Proprietario user = Proprietario.fromJson(json.decode(response.body));

  return user;
}

}