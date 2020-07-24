import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'dart:typed_data';


class Notificacoes extends Model{

  String titulo;
  DateTime datanotificacao;
  int idp;
  String mensagem;
  bool visto;

  Notificacoes({String title, DateTime date, int idpp, String mess,bool saw})
  {

    titulo = title;
    datanotificacao = date;
    idp= idpp;
    mensagem = mess;
    visto = saw;

  }

  factory Notificacoes.fromJson(Map<String,dynamic> json){

    return Notificacoes(
      
      title: json['titulo'] as String,
      date: DateTime.parse(json['dataNotificacao']),
      idpp: json['idP'] as int,
      mess: json['mensagem'] as String,
      saw: json['visto'] as bool

    );

  }


  Future<List> getNotificacoes() async {

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Notificacoes"),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Notificacoes> listau = new List<Notificacoes>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Notificacoes.fromJson(lista[i]));
  

  return listau;
}

Future<Notificacoes> getNotificacao(int idc, int idp) async {

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Notificacoes/"+idc.toString()+"/"+idp.toString()),
    headers:{
      "Accept":"application/json"
    }
  );

  
    Notificacoes not = Notificacoes.fromJson(json.decode(response.body));
  

  return not;
}

Future<int> createNotificacao(Notificacoes not) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Notificacoes';
  var body = json.encode(<String, String>{
      'Titulo': not.titulo,
      'DataNotificacao':not.datanotificacao.toString(),
      'IdP':not.idp.toString(),
      'Mensagem':not.mensagem,
      'Visto':not.visto.toString()
      

    });



   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}

Future<int> updateNotificacao(int idp) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Notificacoes/'+idp.toString();


  http.Response response = await http.put(url,
      headers: {"Content-Type": "application/json"},
  );

  return response.statusCode;
  
}

}