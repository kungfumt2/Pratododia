import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sampleproject/Models/PreferenciasModel.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Models/Login.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/Preferencias.dart';
import 'package:sampleproject/Views/RegistoProprietario.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';

class Registo extends StatefulWidget {

  Registo();
  
  @override
  _RegistoState createState() => _RegistoState();
}


  

class _RegistoState extends State<Registo> {
  List<bool> isSelected;

  String usertype = "";
  
  final nomecontroller = TextEditingController();
  final userncon = TextEditingController();
  final emailcon = TextEditingController();
  final passcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    Utilizador user = new Utilizador();

    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: <Widget>[
              Text("Registo de Utilizador", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
               SizedBox(height: 20),
              Text("Nome", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: nomecontroller,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Nome',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
           ), SizedBox(height: 10),

             Text("Username", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
            TextField(
                autofocus: false,
                controller: userncon,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Username',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ), SizedBox(height: 10),
              
              Text("Email", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                controller: emailcon,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Email',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
          ), 
          
          SizedBox(height: 10),

               Text("Password", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: passcon,
                autofocus: false,
                obscureText: true,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            
              ), Text("Tipo de Utilizador", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),SizedBox(height: 10,), Row(children: [ SizedBox(width: 70,),
        FlatButton(
                onPressed: () => typeButton("Cliente"),
                color: usertype == "Cliente" ? Colors.green : Colors.grey,
                padding: EdgeInsets.all(10.0),
                child: Column( 
                  children: <Widget>[
                  
                    Image.asset("images/Cliente.PNG",height: 75, width: 75),
                    Text("Cliente", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12) ),
 
                  ],
                )),


                SizedBox(width: 75,),

                
        FlatButton(
                onPressed: () => typeButton("Proprietario"),
                color: usertype == "Proprietario" ? Colors.green : Colors.grey,
                padding: EdgeInsets.all(10.0),
                child: Column( // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                   
                    Image.asset("images/Proprietario.PNG",height: 75, width: 75),
                     Text("Proprietario", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12) ),
                  ],
                )),]
                ),
               SizedBox(height: 100),
            new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Próximo", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 80,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
            
              user.id = 0;
              user.nome = nomecontroller.text;
              user.username = userncon.text;
              user.email = emailcon.text;
              user.password = passcon.text;

              user.dataadesao = DateTime.now();


              switch(usertype)
              {
                case "Cliente":

                user.estado = "Cliente";

                 Future<int> valuereq = user.createUtilizador(user).then((int value){


                    user.id = value;

                    Cliente client = new Cliente();

                  client.iduser = user.id;

                  Future<int> clientreq = client.createCliente(client).then((int sc){

                    if(sc == 200)
                    {

                       

                        TipoDeComida tip = new TipoDeComida();

                        Future<List> tipreq = tip.getTipoDeComida().then((List values){

                           Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Preferencias(idcliente: user.id,typesoffood: values,pref: [])),
                              );


                        });



                    }

                  });
                 
                        
                });


                  //return Preferencias(idcliente: user.id,);

                break;

                case "Proprietario":

                user.estado = "Proprietario";


                 Future<int> valuereq = user.createUtilizador(user).then((int value){

                    user.id = value;

                    Login log = new Login();

                    log.username = user.username;
                    log.password = user.password;

                    //log.makelogin(log);

                  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistoProprietario(iduser: user.id,)),
                        );

                 });

                break;
              }
              
              

            },),
            
            
            
            )],
      
            
          ),
    ));
    
  }

  typeButton(String v){
     setState(() {
   usertype = v;

    });
  }


}