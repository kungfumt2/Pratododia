import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Avaliacao.dart';
import 'package:sampleproject/Models/Favoritos.dart';
import 'package:sampleproject/Models/FotografiasR.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/PreferenciasModel.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/MainPage.dart';
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
import 'package:sampleproject/Views/Preferencias.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_util/google_maps_util.dart';
import 'dart:async';

class MainPage extends StatefulWidget {

int iduser;
List restaurantes;
Set<Marker> mapMarkers;

  MainPage({Key key,@required this.iduser,@required this.restaurantes, @required this.mapMarkers}) : super(key: key);
  
  @override
  _MainPageState createState() =>  _MainPageState();
}

  

class _MainPageState extends State<MainPage> {
  List<bool> isSelected;
 

  Completer<GoogleMapController> _controller = Completer();
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.300255, -7.743935),
    zoom: 14.4746,
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static MarkerId markerId1 = MarkerId("1");

  
Coordenadas cor = new Coordenadas();

final searchcontroller = TextEditingController();


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
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: [
              Text("Pesquisar por nome", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: searchcontroller,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Nome do restaurante',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            ), SizedBox(height: 10),
            new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Pesquisar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 60,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){

            Proprietario prop = new Proprietario();
            Prato prato = new Prato();
            Avaliacao ava = new Avaliacao();
            Favoritos fav = new Favoritos();
            FotografiasR foto = new FotografiasR();

            
                        Future<Proprietario> propreq = prop.getProprietarios().then((List value){

                          Proprietario restaur = new Proprietario();

                          for(Proprietario p in value)
                          {
                            if(p.nomerestaurante == searchcontroller.text)
                            {
                              restaur = p;
                              break;
                            }
                          }

                        Future<List> pratoreq = prato.getPratosDaSemana(restaur.iduser).then((List pratossemana){

                          Future<List> avalreq = ava.getAvaliacao(0, restaur.iduser).then((List avaliacoes){

                             Future<List> favreq = fav.getFavoritos(this.widget.iduser,restaur.iduser).then((List favs){

                               

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: restaur,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: restaur,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: true, )),
                                );
                              }

                                
                              });

                            


                          });
                           

                        });
 });
            
            },),
            
            
            
            ),
            
            Flexible(   //<--Wrapped carousel widget in a Flexible container
            child:GoogleMap(
         mapType: MapType.normal,
         initialCameraPosition: _kGooglePlex,
         onMapCreated: _onMapCreated,
         markers: this.widget.mapMarkers,
         myLocationEnabled: true,
         myLocationButtonEnabled: true,
        ),),SizedBox(height: 10,),new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Gerir Preferências", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 20,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 
              
              TipoDeComida tc = new TipoDeComida();

              Future<List> tcreq = tc.getTipoDeComida().then((List lista){

                PreferenciasModel m = new PreferenciasModel();

                Future<List> mreq = m.getPreferencias(this.widget.iduser, 0).then((List mypref){

                    Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Preferencias(idcliente: this.widget.iduser, typesoffood: lista, pref: mypref,)),
                              );

                  
                });
              });
                     

            },),
            
            
            
            ), 
           ]
      
            
          ),
    ));

    
    
  }

    gotomainview(context)
  {
        

            Coordenadas cor = new Coordenadas();
            PreferenciasModel m = new PreferenciasModel();

              String prd = "";
              String pru = "";

             
                prd = "";
              
              
                        Future<List> mreq = m.getPreferencias(this.widget.iduser, 0).then((List mypref){

                      
                    

              for(var i in mypref)
              {
                pru = pru + i.idt.toString() + ";";
              }


              Coordenadas c = new Coordenadas();

              Future<List> creq = c.getrestaurantesGPS(41.300255,-7.743935,prd,pru,this.widget.iduser).then((List restaurs){

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

                             Future<List> favreq = fav.getFavoritos(this.widget.iduser,res.idprop).then((List favs){

                                 

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: true,)),
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

                              Future<List> favreq = fav.getFavoritos(this.widget.iduser,res.idprop).then((List favs){

                                 

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: true,)),
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

                             Future<List> favreq = fav.getFavoritos(this.widget.iduser,res.idprop).then((List favs){

                                   

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.iduser, isfav: true, )),
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
                                MaterialPageRoute(builder: (context) => MainPage(iduser: this.widget.iduser, restaurantes: restaurs, mapMarkers: _markers)),
                              );

              });


              });
               
  }


  gotopreferncias(context)
  {
    TipoDeComida tc = new TipoDeComida();

                        Future<List> tcreq = tc.getTipoDeComida().then((List lista){

                        PreferenciasModel m = new PreferenciasModel();

                        Future<List> mreq = m.getPreferencias(this.widget.iduser, 0).then((List mypref){

                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Preferencias(idcliente:this.widget.iduser, typesoffood: lista, pref: mypref,)),
                                  );
                      
                    });
                  });
  }




}
