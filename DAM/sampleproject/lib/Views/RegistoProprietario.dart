import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/Login.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/RegistoProprietario.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sampleproject/Views/DefinirCoordenadas.dart';

class RegistoProprietario extends StatefulWidget {

  int iduser;

   RegistoProprietario({Key key,@required this.iduser}):super(key:key);
  
  @override
  _RegistoProprietarioState createState() => _RegistoProprietarioState();
}

  

class _RegistoProprietarioState extends State<RegistoProprietario> {
  List<bool> isSelected;


  bool premium = false;

  final nomres = TextEditingController();
  final descricontr = TextEditingController();
  double _rating = 0.0; 

  @override
  Widget build(BuildContext context) {
    
    Proprietario user = new Proprietario();
    


    user.avaliacao = 0;
    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: <Widget>[
              Text("Registo de Proprietário", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
               SizedBox(height: 20),
              Text("Nome do restaurante", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: nomres,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Nome do Restaurante',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            ), SizedBox(height: 10),

             Text("Avaliação", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
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
                },
               ), SizedBox(height: 10),
              
              Text("Descrição:", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
            TextField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: descricontr,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Descrição',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            
              ), Text("Subscrição premium?", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),SizedBox(height: 10,), Row(children: [ SizedBox(width: 70,),
        FlatButton(
                onPressed: () => premiumButton(),
                color: premium ? Colors.green : Colors.grey,
                padding: EdgeInsets.all(10.0),
                child: Column( 
                  children: <Widget>[
                  
                    Icon(Icons.check, size: 50, color: Colors.white,),
                    Text("Sim", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15) ),
 
                  ],
                )),


                SizedBox(width: 75,),

                
        FlatButton(
                onPressed: () => premiumButton(),
                color: premium ? Colors.grey : Colors.red,
                padding: EdgeInsets.all(10.0),
                child: Column( // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                   
                    Icon(Icons.not_interested, size: 50, color: Colors.white,),
                     Text("Não", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12) ),
                  ],
                )),]),
               SizedBox(height: 100),
            new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Próximo", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 80,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){

              user.iduser = this.widget.iduser;

              user.nomerestaurante = nomres.text;
              user.descricao = descricontr.text;

              user.avaliacao = _rating;

              switch(premium)
              {
                case true:
                  user.premium = true;
                  break;

                case false:
                  user.premium = false;
                  break;
              }

              Future<int> cpreq = user.createProprietario(user).then((int value){

                if(value == 200)
                {
                  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DefinirCoordenadas(iduser: this.widget.iduser,)),
                        );
                }

              });
              
       

            },),
            
            
            
            )],
      
            
          ),
    ));
    
  }
  premiumButton(){
     setState(() {
   premium = !premium;

    });
  }
}
