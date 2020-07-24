import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/Suspensao.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Views/Banir.dart';
import 'package:sampleproject/Views/VerSuspensao.dart';

class ListadeUsers extends StatefulWidget {
  List users;
  
  int id;
 ListadeUsers ({Key key,@required this.users,@required this.id}):super(key:key);
  @override
  _ListadeUsersState createState() => _ListadeUsersState();
}

class _ListadeUsersState extends State<ListadeUsers> {
  
  //users=user.getutilizador(0, "admin");  
  @override
  Widget build(BuildContext context) {
    return  Scaffold( appBar: AppBar(
        title: Center(child:Text('PratoDoDia')),
        backgroundColor: Colors.red,
      ),

       body:criarTable()
      
    );}
   Widget criarTable() {
    List<TableRow> rows = [];
  rows.add(TableRow(children: [
    
        Text("Username"),
          Text("Name"),
         
              Text("Estado"),
        Text("Ação")
      ]));
  for (Utilizador p in this.widget.users)
     {      if(p.estado=="Pendente")
            {        

      rows.add(TableRow(children: [

            Text(p.username),
            Text(p.nome),
Text(p.estado),
new SizedBox(
       width: 27.0,
       height: 20.0,child:RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Validar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12),
            ),]),
 onPressed:(){ //Navigator.push(context,MaterialPageRoute(builder: (context){
Future <int>x =p.updateUtilizador(p.id,"","").then((int x){
  Future<List> pras = p.getutilizadores().then((List users){
  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ListadeUsers( users:users,id: this.widget.id,)),
                              ); }); });  }
          ))]));
      }
           else if(p.estado=="Suspenso"){
                     rows.add(TableRow(children: [

            Text(p.username),
            Text(p.nome),
Text(p.estado),
            new SizedBox(
       width: 27.0,
       height: 20.0,child:RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Ver", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12),
            ),]),
 onPressed:(){ //Navigator.push(context,MaterialPageRoute(builder: (context){
Suspensao s =new Suspensao() ;
  Future<List> pras = s.getSuspensao(p.id).then((Suspensao sup){
    Future<List> pras = p.getutilizadores().then((List users){
  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VerSuspensao(s:sup,user: p,idadmin: this.widget.id,)),
                              ); });  });  }
           ))]));
     }
              else if(p.estado=="Livre")
               {   rows.add(TableRow(children: [

            Text(p.username),
            Text(p.nome),
Text(p.estado),
            new SizedBox(
       width: 27.0,
       height: 20.0,child:RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Suspender", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12),
            ),]),
 onPressed:(){ //Navigator.push(context,MaterialPageRoute(builder: (context){

  Future<List> pras = p.getutilizadores().then((List users){
  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Banir(user:p,idadmin: this.widget.id)),
                              ); });   }
          ))
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
      )
      ,children: rows,);
  }
  
}
