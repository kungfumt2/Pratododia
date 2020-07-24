import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/PreferenciasModel.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/RelTipo.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Views/EditRestaurante.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/Notificacao.dart';
import 'package:sampleproject/Views/RegistoProprietario.dart';
import 'package:sampleproject/Models/Coordenadas.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Views/Restaurante.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sampleproject/Views/DefinirCoordenadas.dart';
import 'package:sampleproject/Views/Pratos.dart';
import 'package:sampleproject/Views/Preferencias.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_util/google_maps_util.dart';
import 'dart:async';

class MainPageProp extends StatefulWidget {

Proprietario prop;

  MainPageProp({Key key,@required this.prop,}) : super(key: key);
  
  @override
  _MainPagePropState createState() =>  _MainPagePropState();
}

  

class _MainPagePropState extends State<MainPageProp> {
 


  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'PratoDoDia',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.red,
                ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Página Principal'),
            onTap: () => gotomainpageprop(context),
          ),
           ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Gestão de Pratos'),
            onTap: () => gotogerirpratos(context),
          ),
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Editar Restaurante'),
            onTap: () => gotoeditarres(context),
          ),
           ListTile(
            leading: Icon(Icons.image),
            title: Text('Adicionar Fotos'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Logout'),
            onTap: () => { Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Loggin()),
            )},
          ),
        ],
      ),
    ),
      appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: [Text(this.widget.prop.nomerestaurante, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:34) ),SizedBox(height: 30,),new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Gestão de Pratos", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 19,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 
             
             TipoDeComida tf = new TipoDeComida();

             Prato prato = new Prato();

             Future<List> tfreq = tf.getTipoDeComida().then((List typesf){


               Future<List> pras = prato.getPratosDaSemana(this.widget.prop.iduser).then((List pratosDaSemana){

                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Pratos(prop: this.widget.prop,tiposdecomida:typesf, pratos:pratosDaSemana,)),
                              );

               });

                


             });
            



            },),
            
            
            
            ),SizedBox(height: 40,),new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Editar Restaurante", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 19,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 
             
TipoDeComida tf = new TipoDeComida();

             Prato prato = new Prato();
             RelTipo rel= new RelTipo();
             Future<List> tfreq = tf.getTipoDeComida().then((List typesf){


           Future<List> mreq = rel.getRelTipo(this.widget.prop.iduser, 0).then((List rel){

                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditRestaurante(prop: this.widget.prop,tiposdecomida:typesf,tipos: rel,)),
                              );

              

                
  });

             });
            },),
            
            
            
            ),SizedBox(height: 40,),new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Enviar Notificações", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 12,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 
             Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Notificacao(prop: this.widget.prop)),
                                  );

            },),
            
            
            
            ), 
           ]
      
            
          ),
    ));

    
    
  }

    gotomainpageprop(context)
  {
     Proprietario prop = new Proprietario();

                    Future<Proprietario> propreq = prop.getProprietarios().then((List lista){

                      
                      for(Proprietario i in lista)
                      {
                          if(this.widget.prop.iduser == i.iduser)
                          {
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainPageProp(prop: this.widget.prop,)),
                                  );

                          }
                      }


                     

                    });
  }

  
  gotogerirpratos(context)
  {
     TipoDeComida tf = new TipoDeComida();

             Prato prato = new Prato();

             Future<List> tfreq = tf.getTipoDeComida().then((List typesf){


               Future<List> pras = prato.getPratosDaSemana(this.widget.prop.iduser).then((List pratosDaSemana){

                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Pratos(prop: this.widget.prop,tiposdecomida:typesf, pratos:pratosDaSemana,)),
                              );

               });

                


             });
  }

  gotoeditarres(context)
  {
     TipoDeComida tf = new TipoDeComida();

             Prato prato = new Prato();
             RelTipo rel= new RelTipo();
             Future<List> tfreq = tf.getTipoDeComida().then((List typesf){


           Future<List> mreq = rel.getRelTipo(this.widget.prop.iduser, 0).then((List rel){

                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditRestaurante(prop: this.widget.prop,tiposdecomida:typesf,tipos: rel,)),
                              );

              

                
  });

             });
  }


}
