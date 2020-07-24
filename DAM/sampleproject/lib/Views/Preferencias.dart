import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Avaliacao.dart';
import 'package:sampleproject/Models/Coordenadas.dart';
import 'package:sampleproject/Models/Favoritos.dart';
import 'package:sampleproject/Models/FotografiasR.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/PreferenciasModel.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/RelTipo.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/Restaurante.dart';
import 'package:sampleproject/Views/TipoPrato.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jiffy/src/enums/units.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_util/google_maps_util.dart';

class Preferencias extends StatefulWidget {
  int idcliente;
  List typesoffood;
  List pref;
 

  Preferencias({Key key,@required this.idcliente,@required this.typesoffood,@required this.pref}):super(key:key);
  @override
  _PreferenciasState createState() => _PreferenciasState();
}

class _PreferenciasState extends State<Preferencias> {
   


  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currenttipo;
  String _novapreferencia;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currenttipo = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(
          value: 0.toString(),
          child: new Text("Nenhum")
      ));

    for (TipoDeComida tipo in  this.widget.typesoffood) {
      items.add(new DropdownMenuItem(
          value: tipo.id.toString(),
          child: new Text(tipo.tipo)
      ));
    }
    return items;
  }
  
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
body:SingleChildScrollView(
    child: Stack(
      children:[ Center( child:Column(
        
            children: <Widget>[
              Text("Bem-Vindo", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
               SizedBox(height: 20),
              Text("Que lhe apetece hoje?", style: TextStyle(  color: Colors.black, fontSize:18) ),
                 SizedBox(height: 20),
                   Text("Preferência diária", style: TextStyle(  color: Colors.black, fontSize:15) ),
                new DropdownButton(
                  icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.red),
                    underline: Container(
                      height: 2,
                      width: 100,
                      color: Colors.red,
                    ),
                value: _currenttipo,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,
              ),
              
               SizedBox(height: 30),
                createTable(),


              
              SizedBox(height: 20,),
              Text("Adicionar preferência:", style: TextStyle(  color: Colors.black, fontSize:15) ),
              SizedBox(height: 10,),

              new DropdownButton(
                icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.red),
                    underline: Container(
                      height: 2,
                      width: 100,
                      color: Colors.red,
                    ),
                value: _novapreferencia,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItemNova,
              ),
              new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Add preferência", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 2,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
            

            PreferenciasModel pref = PreferenciasModel();

            pref.dataadd = DateTime.now();
            pref.idc = this.widget.idcliente;
            pref.idt = int.parse(_novapreferencia);

          

            Future<int> prefreq = pref.createPreferencia(pref).then((int value){

              if(value == 200)
              {

                   Future<List> mreq = pref.getPreferencias(this.widget.idcliente, 0).then((List mypref){

                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Preferencias(idcliente:this.widget.idcliente, typesoffood: this.widget.typesoffood, pref: mypref,)),
                                  );

                      
                    });

              }

            });



                           

            },),
            
            
            
            ),SizedBox(height: 30,), new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Seguinte", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 40,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
            

            Coordenadas cor = new Coordenadas();

              String prd = "";
              String pru = "";

              if(_currenttipo != "0")
              {
                prd = _currenttipo;
              }
              else
              {
                prd = "";
              }

              for(var i in this.widget.pref)
              {
                pru = pru + i.idt.toString() + ";";
              }


              Coordenadas c = new Coordenadas();

              Future<List> creq = c.getrestaurantesGPS(41.300255,-7.743935,prd,pru,this.widget.idcliente).then((List restaurs){

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
                        

                        Future<Proprietario> propreq = prop.getProprietario(res.idprop,).then((Proprietario value){
                          Future<List> pratoreq = prato.getPratosDaSemana(res.idprop).then((List pratossemana){
                          Future<List> avalreq = ava.getAvaliacao(0, res.idprop).then((List avaliacoes){
                           

                             Future<List> favreq = fav.getFavoritos(this.widget.idcliente,res.idprop).then((List favs){

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: true,)),
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

                              Future<List> favreq = fav.getFavoritos(this.widget.idcliente,res.idprop).then((List favs){

                               

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: false,)),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: true,)),
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

                             Future<List> favreq = fav.getFavoritos(this.widget.idcliente,res.idprop).then((List favs){

                              

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: false,)),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: true,)),
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
                                MaterialPageRoute(builder: (context) => MainPage(iduser: this.widget.idcliente, restaurantes: restaurs, mapMarkers: _markers)),
                              );

              });
                           

            },),)  
              ])
           )           ]           )
           )
           );
  }
  void changedDropDownItem(String selectedtipo) {
    setState(() {
      _currenttipo = selectedtipo;
      print(selectedtipo);
    });
  }

  void changedDropDownItemNova(String novatipo) {
    setState(() {
      _novapreferencia = novatipo;
      print(novatipo);
    });
  }

  Widget createTable() {
   
  //List <Preferenciasmodel> pratos;
 //=get das preferencias
    List<TableRow> rows = [];
  rows.add(TableRow(children: [
    
        Text("Tipo de Comida"),
        Text("Data Adição"),
        Text("Ação")
      ]));
    for (PreferenciasModel row in this.widget.pref) {

      

      String nomedacomida;

      for(var type in this.widget.typesoffood)
      {
        if(row.idt == type.id)
        {
          nomedacomida = type.tipo;

        }
      }
      rows.add(TableRow(children: [
        
           
            Text(nomedacomida),
            Text(row.dataadd.toString().split(' ')[0]),

            RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Eliminar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),
            ),
           
            ]
            ),

            onPressed:(){

                        PreferenciasModel m = new PreferenciasModel();

                        Future<int> ee= m.deletePreferencia(row.idt,row.idc).then((int x){
                           Future<List> mreq = m.getPreferencias  (this.widget.idcliente, 0).then((List mypref){  
                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Preferencias(idcliente:this.widget.idcliente, typesoffood: this.widget.typesoffood, pref: mypref,)),
                                  );
                      
                 });
                  });
            }
            )
      ]));
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
      )
      ,children: rows,);
  }

   gotomainview(context)
  {
        

            Coordenadas cor = new Coordenadas();
            PreferenciasModel m = new PreferenciasModel();

              String prd = "";
              String pru = "";

             
                prd = "";
              
              
                        Future<List> mreq = m.getPreferencias(this.widget.idcliente, 0).then((List mypref){

                      
                    

              for(var i in mypref)
              {
                pru = pru + i.idt.toString() + ";";
              }


              Coordenadas c = new Coordenadas();

              Future<List> creq = c.getrestaurantesGPS(41.300255,-7.743935,prd,pru, this.widget.idcliente).then((List restaurs){

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

                             Future<List> favreq = fav.getFavoritos(this.widget.idcliente,res.idprop).then((List favs){


                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: false,)),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: true,)),
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

                              Future<List> favreq = fav.getFavoritos(this.widget.idcliente,res.idprop).then((List favs){
                              

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: true, )),
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

                             Future<List> favreq = fav.getFavoritos(this.widget.idcliente,res.idprop).then((List favs){

                              

                              if(favs.length == 0) // Não é favorito
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: false, )),
                                );
                              }
                              else
                              {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Restaurante(restaurante: value,pratos: pratossemana,avalia: avaliacoes,cliente: this.widget.idcliente, isfav: true, )),
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
                                MaterialPageRoute(builder: (context) => MainPage(iduser: this.widget.idcliente, restaurantes: restaurs, mapMarkers: _markers)),
                              );

              });


              });
               
  }


  gotopreferncias(context)
  {
    TipoDeComida tc = new TipoDeComida();

                        Future<List> tcreq = tc.getTipoDeComida().then((List lista){

                        PreferenciasModel m = new PreferenciasModel();

                        Future<List> mreq = m.getPreferencias(this.widget.idcliente, 0).then((List mypref){

                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Preferencias(idcliente:this.widget.idcliente, typesoffood: lista, pref: mypref,)),
                                  );
                      
                    });
                  });
  }



}

 