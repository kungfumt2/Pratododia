import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'dart:typed_data';


class Prato extends Model{

  int id;
  String nome;
  String descricao;
  String tipo;
  String refeicao;
  DateTime datar;
  double preco;
  Uint8List fotografia;
  int idprop;

  Prato({int idd, String name, String dsc, String type, String ref,DateTime date, double price,Uint8List foto, int idp})
  {
    id = idd;
    nome = name;
    descricao = dsc;
    tipo = type;
    refeicao = ref;
    datar = date;
    preco = price;
    fotografia = foto;
    idprop = idp;
  }

   factory Prato.fromJson(Map<String,dynamic> json){

     String bystring = json['fotografia'] as String;

     List<int> list = bystring.codeUnits;
     Uint8List bytes = Uint8List.fromList(list);

    return Prato(
      
      idd: json['id'] as int,
      name: json['nome'] as String,
      dsc: json['descricao'] as String,
      type: json['tipo'] as String,
      ref: json['refeicao'] as String,
      date: DateTime.parse(json['dataR']),
      price: json['preco'] as double,
      foto: bytes,
      idp: json['idProp'] as int

    );

  }

Future<List> getPrato(int id, String type,String refe,DateTime datar, int idp,String what) async {

  String values = type + "|" + refe + "|" + datar.toString() + "|" + idp.toString() + "|" + what;

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Prato/"+id.toString() +"/" + values),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Prato> listau = new List<Prato>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(Prato.fromJson(lista[i]));
  

  return listau;
}

Future<int> createPrato(Prato prato) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Prato';

  
  var list  = new List.from(prato.fotografia);

  print(list);

  var body = json.encode(<String, Object>{
      'Id': prato.id,
      'Nome': prato.nome.toString(),
      'Descricao':prato.descricao,
      'Tipo': prato.tipo,
      'Refeicao': prato.refeicao,
      'DataR': prato.datar.toString(),
      'Preco': prato.preco.toString(),
      'Fotografia': list,
      'IdProp':prato.idprop.toString()

    });

    print(body);

   http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}

void updatePrato(int id, String what, DateTime dr,double price, Uint8List photo,String value) async {

  String values = what + "|"+dr.toString() +"|"+price.toString()+"|"+photo.toString()+"|"+value.toString();

  var url ='http://3b61d9bbb70d.ngrok.io/api/Prato/'+id.toString();
  var body = json.encode(values);



  http.put(url,
      headers: {"Content-Type": "application/json"},
      body: body
  ).then((http.Response response) {
    

  });
  
}

Future<List> getPratosDaSemana(int id) async {



  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/PratosDaSemana/"+id.toString()),
    headers:{
      "Accept":"application/json"
    }
  );

  if(response.statusCode == 200)
  {

    List lista = json.decode(response.body);

    List<Prato> listau = new List<Prato>();

    
    for(int i = 0; i < lista.length; i++)
      listau.add(Prato.fromJson(lista[i]));
    

    return listau;

  }
  else
  {
    return [];
  }
}


Future<ByteData> loadpic(String nome) async {

final ByteData bytes = await rootBundle.load('images/'+nome);

return bytes;

}

Future<int> deletePrato(int idp) async {
print(idp);
  var url ='http://3b61d9bbb70d.ngrok.io/api/Prato/'+idp.toString();

  var body = json.encode("");


   http.Response response = await http.delete(url,
      headers: {"Content-Type": "application/json"},
  );

  return response.statusCode;
  
}

}