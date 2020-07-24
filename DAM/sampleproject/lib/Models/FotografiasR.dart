import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';

class FotografiasR extends Model{

  int idprop;
  Uint8List foto;

  FotografiasR({int idp,Uint8List fot})
  {

   this.idprop = idp;
   this.foto = fot;

  }

  factory FotografiasR.fromJson(Map<String,dynamic> json){

    String bystring = json['foto'] as String;

     List<int> list = bystring.codeUnits;
     Uint8List bytes = Uint8List.fromList(list);

    return FotografiasR(
      idp: json['idProp'] as int,
      fot: bytes,
    );

  }



Future<int> createFotografiasR(FotografiasR foto) async {

   var list  = new List.from(foto.foto);

  var url ='http://3b61d9bbb70d.ngrok.io/api/FotografiasR';
  var body = json.encode(<String, dynamic>{
      'IdProp': foto.idprop.toString(),
      'Foto': list
    
    });


  http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return response.statusCode;
  
}
  
Future<List> getFotografiasR(int idp) async {
  
  http.Response response;

  if(idp != 0)
  {
    response = await http.get(
      Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/FotografiasR"),
      headers:{
        "Accept":"application/json"
      }
    );
  }
  else
  {
      response = await http.get(
      Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/FotografiasR/" + idp.toString()),
      headers:{
        "Accept":"application/json"
      }
    );
  }


  List lista = json.decode(response.body);

  List<FotografiasR> listau = new List<FotografiasR>();

  
  for(int i = 0; i < lista.length; i++)
    listau.add(FotografiasR.fromJson(lista[i]));
  

  return listau;
}

Future<Uint8List> loadpic(String nome) async {

final ByteData bytes = await rootBundle.load('images/'+nome);
final Uint8List imagebytes = bytes.buffer.asUint8List();

return imagebytes;

}

}