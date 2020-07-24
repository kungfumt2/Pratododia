import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sampleproject/Models/Utilizador.dart';
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'dart:typed_data';

class Avaliacao extends Model{

int idcliente;
int idprop;
DateTime dataavaliacao;
String comentario;
double avaliacaop;
String autor;

Avaliacao({int idc, int idp,DateTime da, String com, double ava, String aut})
{
  idcliente = idc;
  idprop = idp;
  dataavaliacao = da;
  comentario = com;
  avaliacaop = ava;
  autor = aut;
}

factory Avaliacao.fromJson(Map<String,dynamic> json){

    return Avaliacao(
      
    idc: json['idCliente'] as int,
    idp: json['idProp'] as int,
    da: DateTime.parse(json['dataAvaliacao']),
    com: json['comentario'] as String,
    ava: json['avaliacaoP'] as double,
    aut: json['autor'] as String,
      

    );

  }

Future<List> getAvaliacao(int idc, int idp) async {

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Avaliacao/" + idc.toString() + "/" + idp.toString()),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Avaliacao> listau = new List<Avaliacao>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Avaliacao.fromJson(lista[i]));
  

  return listau;
}

Future<int> createAvaliacao(Avaliacao ava) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Avaliacao';
  var body = json.encode(<String, dynamic>{
      'IdCliente': ava.idcliente,
      'IdProp': ava.idprop,
      'DataAvaliacao': ava.dataavaliacao.toString(),
      'Comentario': ava.comentario,
      'AvaliacaoP': ava.avaliacaop,
      'Autor': ava.autor,

    });



   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}

}