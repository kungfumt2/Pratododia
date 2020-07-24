import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sampleproject/Models/Avaliacao.dart';
import 'package:sampleproject/Models/Coordenadas.dart';
import 'package:sampleproject/Models/Favoritos.dart';
import 'package:sampleproject/Models/FotografiasR.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/PreferenciasModel.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/PratoView.dart';
import 'package:sampleproject/Views/Preferencias.dart';

class Restaurante extends StatefulWidget {
  
   
  Proprietario  restaurante;
  List pratos;
  List avalia;
  int cliente;
  bool isfav;

   Restaurante({Key key,@required this.restaurante,@required this.pratos,@required this.avalia,@required this.cliente,@required this.isfav,}) : super(key: key);
  @override
  _RestauranteState createState() => _RestauranteState();
}

class _RestauranteState extends State<Restaurante> {

  final commentcont = TextEditingController();
   double _rating = 0.0; 

   Image image;


  //fazer o get do restaurante
 //=get todos os pratos do Restaurante x
  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: Drawer(
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
            onTap: () => gotomainview(context),
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text('Preferências'),
            onTap: () => gotopreferncias(context),
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
        title: Center(child:Text('Prato do Dia')),
        backgroundColor: Colors.green,
      ),
 body:SingleChildScrollView(
    child: Stack(
    children:[Center( child:Column(
        
            children: [
              Row(children: <Widget>[ Text("${this.widget.restaurante.nomerestaurante}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:17) ),SizedBox(width: 10,),
   
               ],),

               
        SizedBox(height: 10,),
        Text("Detalhes do Restaurante:", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
        SizedBox(height: 2,),
        Row(children: <Widget>[Text("Descrição", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:17) ), SizedBox(width: 10,), Text("${this.widget.restaurante.descricao}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:17) ),],),
        SizedBox(height: 2,),
        Row(children: <Widget>[Text("Rating", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.blue, fontSize:17) ), SizedBox(width: 10,), Text("${this.widget.restaurante.avaliacao}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:17) ),],),
   
        
        SizedBox(height: 20,),
        createTable(this.widget.pratos,context),
        SizedBox(height: 20,),
       getButtonFav(this.widget.restaurante,this.widget.pratos,this.widget.avalia,this.widget.cliente,this.widget.isfav,context),
        SizedBox(height: 30,),
         Text("Avaliações:", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
         SizedBox(height: 10,),
         RatingBar(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  _rating = rating;
                },),
         TextField(
                keyboardType: TextInputType.visiblePassword,
                controller:commentcont,
                autofocus: false,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Deixe um comentário',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ), 
               SizedBox(height: 20),
            new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Comentar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 60,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
            Avaliacao ava = new Avaliacao();
            Utilizador u = new Utilizador();

            ava.idprop = this.widget.restaurante.iduser;
            ava.idcliente = this.widget.cliente;
            ava.dataavaliacao = DateTime.now();
            ava.comentario = commentcont.text;
            ava.avaliacaop = _rating;
            
            Future<List> ureq =u.getutilizadores().then((List users){

              for(Utilizador user in users)
              {
                if(user.id == this.widget.cliente)
                {
                  ava.autor = user.nome;
                  break;
                }
              }
              
            Future<int> makecomment = ava.createAvaliacao(ava).then((int sc){

              if(sc == 200)
              {
                Future<List> avalreq = ava.getAvaliacao(0, this.widget.restaurante.iduser).then((List avaliacoes){

                             Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Restaurante(restaurante: this.widget.restaurante,pratos: this.widget.pratos,avalia: avaliacoes,cliente: this.widget.cliente,isfav: this.widget.isfav,)),
                          );


                          });

              }

            });


            });

            
            },),
            
            
            
            ),

               getComentarios(this.widget.avalia, context,this.widget.restaurante),
         
      ]
      
            
          ),

    ),

     

      
    ])));
  }

  
    gotomainview(context)
  {
        

            Coordenadas cor = new Coordenadas();
            PreferenciasModel m = new PreferenciasModel();

              String prd = "";
              String pru = "";

             
                prd = "";
              
              
                        Future<List> mreq = m.getPreferencias(this.widget.cliente, 0).then((List mypref){

                      
                    

              for(var i in mypref)
              {
                pru = pru + i.idt.toString() + ";";
              }


              Coordenadas c = new Coordenadas();

              Future<List> creq = c.getrestaurantesGPS(41.300255,-7.743935,prd,pru,this.widget.cliente).then((List restaurs){

                 Set<Marker> _markers = Set();

                for(var res in restaurs)
                {
                  
                  BitmapDescriptor bitdes;

                  switch(res.cor)
                  {
                    case "Amarelo":

                    BitmapDescriptor bs;

                    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(300, 300)),
                    'images/MarkerYellow.png')
                        .then((d) {
                      bs = d;

                      Marker marker = Marker(
                      markerId: MarkerId(res.idprop.toString()),
                      position: LatLng(res.clat, res.clong),
                      draggable: false,
                      icon: bs,


                          onTap: (){
                        
                        // Evento de carregar

                        Proprietario prop = new Proprietario();
                        Prato prato = new Prato();
                        Avaliacao ava = new Avaliacao();
                        Favoritos fav = new Favoritos();
                        FotografiasR foto = new FotografiasR();

                        Future<Proprietario> propreq = prop.getProprietario(res.idprop,).then((Proprietario value){
                          Future<List> pratoreq = prato.getPratosDaSemana(res.idprop).then((List pratossemana){
                          Future<List> avalreq = ava.getAvaliacao(0, res.idprop).then((List avaliacoes){

                             Future<List> favreq = fav.getFavoritos(this.widget.cliente,res.idprop).then((List favs){


                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.cliente, isfav: false,)),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.cliente, isfav: true, )),
                                );
                              }

                                
                              

                             });


                          });
                        });

                        });
                        
                      },
                          );

                          _markers.add(marker);
                    });

                    

                    break;

                    case "Azul":

                    BitmapDescriptor bs;

                    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(300,300)),
                    'images/MarkerAzul.png')
                        .then((d) {
                      bs = d;

                      Marker marker = Marker(
                      markerId: MarkerId(res.idprop.toString()),
                      position: LatLng(res.clat, res.clong),
                      draggable: false,
                      icon: bs,

     onTap: (){
                        
                        // Evento de carregar

                        Proprietario prop = new Proprietario();
                        Prato prato = new Prato();
                        Avaliacao ava = new Avaliacao();
                        Favoritos fav = new Favoritos();
                        FotografiasR foto = new FotografiasR();

                        Future<Proprietario> propreq = prop.getProprietario(res.idprop,).then((Proprietario value){

                        Future<List> pratoreq = prato.getPratosDaSemana(res.idprop).then((List pratossemana){

                            Future<List> avalreq = ava.getAvaliacao(0, res.idprop).then((List avaliacoes){

                              Future<List> favreq = fav.getFavoritos(this.widget.cliente,res.idprop).then((List favs){

                                   

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.cliente, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.cliente, isfav: true, )),
                                );
                              }

                                
                             
                              });



                          });

                        });
 });
                        
                      },
                          );

                          _markers.add(marker);
                    });

                    break;

                    case "Vermelho":

                    Marker marker = Marker(
                      markerId: MarkerId(res.idprop.toString()),
                      position: LatLng(res.clat, res.clong),
                      draggable: false,


                      onTap: (){
                        
                        // Evento de carregar

                        Proprietario prop = new Proprietario();
                        Prato prato = new Prato();
                        Avaliacao ava = new Avaliacao();
                        Favoritos fav = new Favoritos();
                        FotografiasR foto = new FotografiasR();

                        Future<Proprietario> propreq = prop.getProprietario(res.idprop,).then((Proprietario value){

                        Future<List> pratoreq = prato.getPratosDaSemana(res.idprop).then((List pratossemana){

                          Future<List> avalreq = ava.getAvaliacao(0, res.idprop).then((List avaliacoes){

                             Future<List> favreq = fav.getFavoritos(this.widget.cliente,res.idprop).then((List favs){
                               

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.cliente, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.cliente, isfav: true, )),
                                );
                              }

                                
                             

                             });


                          });
                           

                        });
 });
                        
                      },
                          );

                          _markers.add(marker);
                          break;
                  
                    }

                    
                
                }

                  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MainPage(iduser: this.widget.cliente, restaurantes: restaurs, mapMarkers: _markers)),
                              );

              });


              });
               
  }


  gotopreferncias(context)
  {
    TipoDeComida tc = new TipoDeComida();

                        Future<List> tcreq = tc.getTipoDeComida().then((List lista){

                        PreferenciasModel m = new PreferenciasModel();

                        Future<List> mreq = m.getPreferencias(this.widget.cliente, 0).then((List mypref){

                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Preferencias(idcliente:this.widget.cliente, typesoffood: lista, pref: mypref,)),
                                  );
                      
                    });
                  });
  }



}
 
 Widget createTable(List pratos,BuildContext context) {
   
 
 //=get todos os pratos do Restaurante x
    List<TableRow> rows = [];
  rows.add(TableRow(children: [
    
        Text("Nome"),
        Text("Tipo "),
        Text("Data"),
        Text(""),
      ]));
    for (int i = 0; i <pratos.length ; ++i) {

      if(pratos[i].id != 0)
      {
      rows.add(TableRow(children: [
        Text("${pratos[i].nome}"),
        Text("${pratos[i].tipo}"),
           Text("${pratos[i].datar.toString().split(' ')[0]}"),
            
            RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Ver", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),
            ),
           
            ]
            ),

            onPressed:(){ //Navigator.push(context,MaterialPageRoute(builder: (context){
                 

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PratoView(prato: pratos[i])),
                              );

              

       
              

            }
            )
      ]));

      }
    }
    return Table( border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        verticalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),children: rows);
  }

Widget getComentarios(List aval,BuildContext context,Proprietario prop) {
   
    List<Widget> list = new List<Widget>();

    for(Avaliacao a in aval)
    {if (a.idprop== prop.iduser)
    {
      list.add(SizedBox(height: 15,));

       list.add(Row(children:[SizedBox(width: 10,),Text(a.autor, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:12) ),SizedBox(width:5),Text(a.dataavaliacao.toString().split(' ')[0], style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:12) ),]));
       list.add(SizedBox(height: 2,));

      list.add(RatingBar(
                initialRating: a.avaliacaop,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {

                },),);

       list.add(SizedBox(height: 5,));

       list.add(Text(a.comentario, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),);
    }
    }

    return Column(children: list,);
    
}

Widget getButtonFav(Proprietario  restaurante,List pratos,List avalia,int cliente, bool isfav,BuildContext context) {
 
  if(!isfav){

    return new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Adicionar Favorito", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 20,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
           Favoritos fav = new Favoritos();

           fav.idcliente = cliente;
           fav.idprop = restaurante.iduser;
           fav.dataadd = DateTime.now();

           Future<int> favreq = fav.createFavoritos(fav).then((int sc){

             if(sc == 200)
             {
                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Restaurante(restaurante: restaurante,pratos:pratos,avalia: avalia,cliente: cliente,isfav:true,)),
                          );
             }
           });
            
            },),
            
            
            
            );

  }
  else
  {

    return new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Eliminar Favorito", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 30,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
           Favoritos fav = new Favoritos();

          

           Future<int> favreq = fav.deleteFavoritos(restaurante.iduser,cliente).then((int sc){

             if(sc == 200)
             {
                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Restaurante(restaurante: restaurante,pratos:pratos,avalia: avalia,cliente: cliente,isfav:false,)),
                          );
             }
           });
            
            },),
            
            
            
            );

  }

  

  
 
}