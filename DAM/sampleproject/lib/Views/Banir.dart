import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/Suspensao.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Views/GestaoUtilizadores.dart';


class Banir extends StatefulWidget {
  int idadmin;
  Utilizador user;
 Banir({Key key,@required this.user, @required this.idadmin,}):super(key:key);
  @override
  _BanirState createState() => _BanirState();
}

class _BanirState extends State<Banir> {
    final tempocontroller = TextEditingController();
  final motivocontroller = TextEditingController();
  Suspensao s =new Suspensao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: <Widget>[
              Text("Suspender Utilizador ${this.widget.user.username} ", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
              
               SizedBox(height: 20),
              Text("Quantos dias quer que o utiliador seja suspenso", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: tempocontroller,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Número de dias',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            ), SizedBox(height: 10),

                    
               SizedBox(height: 10),
               Text("Qual o motivo da suspensao", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
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
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Suspender", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 50,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
              

              s.motivo = motivocontroller.text;
              s.tempo = int.parse(tempocontroller.text);

              s.ida=this.widget.idadmin;
              s.idu=this.widget.user.id;
              s.datadesuspensao=DateTime.now();


            //update
             Cliente c;
             Proprietario p;

                 
                     Future <int>x =this.widget.user.updateUtilizador(this.widget.user.id,"Suspender","").then((int x){
  Future<List> pras = this.widget.user.getutilizadores().then((List users){
     Future <int>x =s.createSuspensao(s).then((int x){
 

  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListadeUsers( users:users,id: this.widget.idadmin,)),
                              ); });});  });  
                
               
            
            
            
       }
       )
       )
       ],
      
            
          ),
    )
      
    );
  }
}