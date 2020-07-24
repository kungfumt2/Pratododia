import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';

class Suspensao extends Model{

  DateTime datadesuspensao;
  int ida;
  int idu;
  int tempo;
  String motivo;

  Suspensao({DateTime ds, int idaa, int iduu, int timee, String motive})
  {
    datadesuspensao = ds;
    ida = idaa;
    idu = iduu;
    tempo = timee;
    motivo = motive;

  }

   factory Suspensao.fromJson(Map<String, dynamic> json) {
    return Suspensao(
      ds: DateTime.parse( json['dataDeSuspensao']),
      idaa: json['idA'] as int,
      iduu:json['idU'] as int,
      timee:json['tempo'] as int,
      motive:json['motivo'] as String,
     
    );
  }

  Future<Suspensao> getSuspensao(int idu ) async {


  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Suspensao/"+idu.toString()),
    headers:{
      "Accept":"application/json"
    }
  );

  
  

  return Suspensao.fromJson(json.decode(response.body));
}

Future<int> createSuspensao(Suspensao susp) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Suspensao';
  var body = json.encode(<String, String>{
      'DataDeSuspensao': susp.datadesuspensao.toString(),
      'IdA': susp.ida.toString(),
      'IdU':susp.idu.toString(),
      'Tempo': susp.tempo.toString(),
      'Motivo':susp.motivo

    });



  http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}

}