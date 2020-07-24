import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Notificacoes.dart';
import 'package:sampleproject/Models/Proprietario.dart';

import 'MainPageProp.dart';

class Notificacao extends StatefulWidget {
Proprietario prop;
  Notificacao({Key key,@required this.prop,}):super(key:key);
  @override
  _NotificacaoState createState() => _NotificacaoState();
}

class _NotificacaoState extends State<Notificacao> {
   final tempocontroller = TextEditingController();
  final motivocontroller = TextEditingController();
  Notificacoes s =new Notificacoes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: <Widget>[
              Text("Enviar Notificação", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
              
               SizedBox(height: 20),
              Text("Qual o titulo da Notificação?", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: tempocontroller,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: '',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            ), SizedBox(height: 10),

                    
               SizedBox(height: 10),
               Text("Qual a mensagem da Notificação", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
              TextField(
              
                controller: motivocontroller,
            
                autofocus: false,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: '',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ), 


               SizedBox(height: 100),
            new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Enviar notificação", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 23,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
              

              s.mensagem = motivocontroller.text;
              s.titulo = tempocontroller.text;

              s.idp=this.widget.prop.iduser;
            
              s.datanotificacao=DateTime.now();

s.visto=false;

            //update
                Future <int>x =s.createNotificacao(s).then((int x){

                 
      Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainPageProp(prop: this.widget.prop,)),
                                  ); });  

                
               
            
            
            
       }
       )
       )
       ],
      
            
          ),
    )
      
    );
  }
}