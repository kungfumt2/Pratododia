import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:image/image.dart' as imageUtils;

class PratoView extends StatefulWidget {

Prato prato;
  PratoView({Key key,@required this.prato}) : super(key: key);
  @override
  _PratoViewState createState() => _PratoViewState();
}

class _PratoViewState extends State<PratoView> {
Image image;
  @override
void initState() {



  super.initState();

  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String imagenJson = String.fromCharCodes(this.widget.prato.fotografia);
  Uint8List _image = base64Decode(imagenJson);
  image = Image.memory(_image);


}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Center(child:Text('Prato do Dia')),
        backgroundColor: Colors.green,
      ),
 body:Center( child:Column(
        
            children: [
              Row(children: <Widget>[ Text("${this.widget.prato.nome}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:30) ),SizedBox(width: 10,),
   
               ],), 

              Flexible(   //<--Wrapped carousel widget in a Flexible container
            child: Expanded(child: image
  ),),
  SizedBox(height: 10,),
    
        Text("Detalhes do Prato:", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
        SizedBox(height: 2,),
        Row(children: <Widget>[Text("Descrição", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:17) ), SizedBox(width: 10,), Text("${this.widget.prato.descricao}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:17) ),],),
        SizedBox(height: 2,),
        Row(children: <Widget>[Text("Tipo de comida", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:17) ), SizedBox(width: 10,), Text("${this.widget.prato.tipo}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.orange, fontSize:17) ),],),
        SizedBox(height: 2,),
        Row(children: <Widget>[Text("Preço", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:17) ), SizedBox(width: 10,), Text("${this.widget.prato.preco}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.blue, fontSize:17) ),],),
        SizedBox(height: 2,),
        Row(children: <Widget>[Text("Data", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:17) ), SizedBox(width: 10,), Text("${this.widget.prato.datar.toString().split(' ')[0] }", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.green, fontSize:17) ),],),
        SizedBox(height: 20,),
      ]
      
            
          ),
    )
    );
  }
}


 



