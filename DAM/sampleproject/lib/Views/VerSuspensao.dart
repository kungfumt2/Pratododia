import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/Suspensao.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Views/GestaoUtilizadores.dart';

class VerSuspensao extends StatefulWidget {
  Suspensao s;
  Utilizador user;
  int idadmin;
    VerSuspensao ({Key key,@required this.s, @required this.user,@required  this.idadmin}):super(key:key);
  @override
  _VerSuspensaoState createState() => _VerSuspensaoState();
}

class _VerSuspensaoState extends State<VerSuspensao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

      body:Center( child:Column(
        
            children: <Widget>[
              Text(" Utilizador : ${this.widget.user.username} ", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
              
               SizedBox(height: 20),
              Text("Suspenso desde ${this.widget.s.datadesuspensao.toString()}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             
             SizedBox(height: 10),
Text("Tempo:  Suspenso por ${this.widget.s.tempo} dias", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
                    
               SizedBox(height: 10),
               Text("Motivo: ${this.widget.s.motivo}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
            

               SizedBox(height: 100),
            new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Retirar Suspensão", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 50,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){
              
              

            


            //update
             Cliente c;
             Proprietario p;

                 
                     Future <int>x =this.widget.user.updateUtilizador(this.widget.user.id,"Validar"  ,"").then((int x){
  Future<List> pras = this.widget.user.getutilizadores().then((List users){
    

  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListadeUsers( users:users,id:this.widget.idadmin)),
                              ); });});  
                
               
            
            
            
       }
       )
       )
       ],
      
            
          ),
    )
      
    );
  }
}