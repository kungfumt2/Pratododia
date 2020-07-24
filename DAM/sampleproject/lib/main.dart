import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/Registo.dart';
import 'package:sampleproject/Views/Restaurante.dart';



void main(){
 

  runApp(PratoDoDiaApp());

}


class PratoDoDiaApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
  
    
     
    return MaterialApp(
      title: 'PratoDoDia',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );

   
  }


}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: getwidgets(),
      
            
          ),
    ));
    
  }

  List<Widget> getwidgets()
  {
     List<Widget> w = new List<Widget>();

    w.add(SizedBox(height: 50,));

    w.add(Text("PratoDoDia", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:34) ),);
    w.add(Row(children:[SizedBox(width: 200,),Text("Que se come hoje?", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ), ],));

    w.add(SizedBox(height: 50),);

     w.add(Image.asset("images/prato.png",height: 200, width: 200),);

     w.add(SizedBox(height: 50),);

     w.add(SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Registar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 80,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ Navigator.push(context,MaterialPageRoute(builder: (context){
              
              
          
             return Registo();

            

            }));},),
            
            
            
    ));

    w.add(SizedBox(height: 30,));

   

    w.add(new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Login", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 100,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ Navigator.push(context,MaterialPageRoute(builder: (context){
              
                            

         return Loggin();
             

            }));},),)

    );

    return w;
  }
}