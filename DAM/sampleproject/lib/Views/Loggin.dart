import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sampleproject/Models/Avaliacao.dart';
import 'package:sampleproject/Models/Coordenadas.dart';
import 'package:sampleproject/Models/Favoritos.dart';
import 'package:sampleproject/Models/Notificacoes.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/RelTipo.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Login.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Notificacoes_Helper.dart';
import 'package:sampleproject/Views/GestaoUtilizadores.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/Preferencias.dart';
import 'package:sampleproject/Views/RegistoProprietario.dart';
import 'package:sampleproject/Views/Restaurante.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:sampleproject/Models/PreferenciasModel.dart';
import 'package:sampleproject/Views/MainPageProp.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Loggin extends StatefulWidget {
  Loggin();
  @override
  _LogginState createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
   List<bool> isSelected;

  String usertype = "";
   Utilizador u;

  final usercontroller = TextEditingController();
  final passcontroller = TextEditingController();
 final notifications = FlutterLocalNotificationsPlugin();
@override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        
        MaterialPageRoute(builder: (context) =>   Loggin()),
      );
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: <Widget>[
              Text("Login", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
               SizedBox(height: 20),
              Text("Username", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: usercontroller,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Username',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            ), SizedBox(height: 10),

                    
               SizedBox(height: 10),
               Text("Password", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: passcontroller,
                obscureText: true,
                autofocus: false,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ), 


               SizedBox(height: 100),
            new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Entrar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 80,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
              Login log = new Login();

              RelTipo ty = new RelTipo();

              log.username = usercontroller.text;
              log.password = passcontroller.text;

              Future<int> loginreq = log.makelogin(log).then((List result){

                DateTime date = DateTime.now();
             if (result.length==0)
             {
showAlertDialog(context);  }                if(result[1] == "Cliente")
                  {
                        TipoDeComida tc = new TipoDeComida();

                        Future<List> tcreq = tc.getTipoDeComida().then((List lista){

                        PreferenciasModel m = new PreferenciasModel();
                        Favoritos f =new Favoritos();
Notificacoes n =new Notificacoes();
                        Future<List> mreq = m.getPreferencias(result[0], 0).then((List mypref){
                          Future<List> mreq = f.getFavoritos(result[0], 0).then((List fav){
                            Future<List> mreq = n.getNotificacoes().then((List not){
  
                            for (Notificacoes notificacao in not)
                            {for (Favoritos favoritos in fav)
{ if(notificacao.idp ==favoritos.idprop && notificacao.visto == false)
{

  Future<int> putvisto = n.updateNotificacao(notificacao.idp).then((int value){

  if(value == 200)
  {
    showOngoingNotification(notifications,
                  title: notificacao.titulo, body: notificacao.mensagem);
  }


  });


}
}
                            } 



                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Preferencias(idcliente:result[0], typesoffood: lista, pref: mypref,)),
                                  );
                      
                    }); });});
                  });
                }
                else  if(result[1] == "Proprietario")
                {
                    Proprietario prop = new Proprietario();

                    Future<Proprietario> propreq = prop.getProprietarios().then((List lista){

                      
                      for(Proprietario i in lista)
                      {
                          if(result[0] == i.iduser)
                          {
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainPageProp(prop: i,)),
                                  );

                          }
                      }


                     

                    });
                }
                 else if(result[1] == "Administrador")
                {
                    Proprietario prop = new Proprietario();
                    Cliente c=new Cliente();
                    Utilizador p=new Utilizador();
                     
                   Future<List> pras = p.getutilizadores().then((List users){
                     print(users);
  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListadeUsers( users:users,id: result[0],)),
                              );  }); 
                }


              });
            
            },),
            
            
            
            )],
      
            
          ),
    ));
    
  }

 
  
}

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {Navigator.pop(context); },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Erro no Login"),
    content: Row(children: <Widget>[Icon(Icons.error_outline,color:Colors.red,size: 80,),Text("Problemas na Autenticação ")]), 
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

