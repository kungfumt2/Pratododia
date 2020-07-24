import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/RegistoProprietario.dart';
import 'package:sampleproject/Models/Coordenadas.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sampleproject/Views/DefinirCoordenadas.dart';
import 'package:sampleproject/Views/TipoPrato.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class DefinirCoordenadas extends StatefulWidget {

int iduser;
 double lat;
 double long;

   DefinirCoordenadas({Key key,@required this.iduser}) : super(key: key);
  
  @override
  _DefinirCoordenadasState createState() => _DefinirCoordenadasState();
}

  

class _DefinirCoordenadasState extends State<DefinirCoordenadas> {
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

 Set<Marker> _markers = {
    Marker(
          markerId: MarkerId('marker_2'),
          position: _kGooglePlex.target,
          draggable: true,

onTap: (){
  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Marker Tapped!!"),));
},
    ),

 };
  


  @override
  Widget build(BuildContext context) {

    
    
    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: [Flexible(   //<--Wrapped carousel widget in a Flexible container
            child:GoogleMap(
         mapType: MapType.normal,
         initialCameraPosition: _kGooglePlex,
         onMapCreated: _onMapCreated,
         markers: _markers,
         myLocationEnabled: true,
         myLocationButtonEnabled: true,
         onCameraMove: ((_position) => _updatePosition(_position)),
        ),),SizedBox(height: 10,),new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Próximo", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 80,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
              Coordenadas c = new Coordenadas();

              c.clat = this.widget.lat;
              c.clong = this.widget.long;
              c.idprop = this.widget.iduser;
              c.cor = "";

              Future<int> creq = c.createCoordenadas(c).then((int value){

                if(value == 200)
                {
                     Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TipoPrato(iduser: this.widget.iduser)),
                        );
                }

              });

             
                     

           },),
            
            
            
            )]
      
            
          ),
    ));

    
    
  }

  void _updatePosition(CameraPosition _position) {
    print(
        'inside updatePosition ${_position.target.latitude} ${_position.target.longitude}');
    Marker marker = _markers.firstWhere(
        (p) => p.markerId == MarkerId('marker_2'),
        orElse: () => null);

    _markers.remove(marker);
    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
      ),
    );
    setState(() {this.widget.lat = _position.target.latitude; this.widget.long = _position.target.longitude;});
  }

}
