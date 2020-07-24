import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/RelTipo.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Views/EditRestaurante.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/MainPageProp.dart';

import 'NovoPrato.dart';

class Pratos extends StatefulWidget {
   Proprietario prop;
   List tiposdecomida;
   List pratos;

  Pratos({Key key,@required this.prop, @required this.tiposdecomida, @required this.pratos}):super(key:key);
  @override
  _PratosState createState() => _PratosState();
}

class _PratosState extends State<Pratos> {
   Prato pp;
   List dias;  

   final nomepratocont = TextEditingController();
   final descontroller = TextEditingController();
   final precocontroller = TextEditingController();
  
  @override
  void initState() {

    super.initState();

  }
   List<DropdownMenuItem<String>> getDropDownMenuItems() {

    List<DropdownMenuItem<String>> items = new List();

    for (TipoDeComida tipo in this.widget.tiposdecomida) {
      items.add(new DropdownMenuItem(
          value: tipo.id.toString(),
          child: new Text(tipo.tipo)
      ));
    }

    return items;
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
            onTap: () => gotomainpageprop(context),
          ),
           ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Gestão de Pratos'),
            onTap: () => gotogerirpratos(context),
          ),
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Editar Restaurante'),
            onTap: () => gotoeditarres(context),
          ),
           ListTile(
            leading: Icon(Icons.image),
            title: Text('Adicionar Fotos'),
            onTap: () => {},
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
    children:[Center( child:Column(
      children: <Widget>[
                              Text("${this.widget.prop.nomerestaurante}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
                       SizedBox(height: 20),
                        createTable(this.widget.pratos,context,this.widget.tiposdecomida,this.widget.prop),
                        SizedBox(height: 40,),new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Adicionar Prato", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 19,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 
             
               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NovoPrato(prop: this.widget.prop,tiposdecomida:this.widget.tiposdecomida, pratos:this.widget.pratos,)),
                              );

            },),
            
            
            
            )
                         ]))])));
                  }

          gotomainpageprop(context)
  {
     Proprietario prop = new Proprietario();

                    Future<Proprietario> propreq = prop.getProprietarios().then((List lista){

                      
                      for(Proprietario i in lista)
                      {
                          if(this.widget.prop.iduser == i.iduser)
                          {
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainPageProp(prop: i,)),
                                  );

                          }
                      }


                     

                    });
  }

  
  gotogerirpratos(context)
  {
     TipoDeComida tf = new TipoDeComida();

             Prato prato = new Prato();

             Future<List> tfreq = tf.getTipoDeComida().then((List typesf){


               Future<List> pras = prato.getPratosDaSemana(this.widget.prop.iduser).then((List pratosDaSemana){

                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Pratos(prop: this.widget.prop,tiposdecomida:typesf, pratos:pratosDaSemana,)),
                              );

               });

                


             });
  }

  gotoeditarres(context)
  {
     TipoDeComida tf = new TipoDeComida();

             Prato prato = new Prato();
             RelTipo rel= new RelTipo();
             Future<List> tfreq = tf.getTipoDeComida().then((List typesf){


           Future<List> mreq = rel.getRelTipo(this.widget.prop.iduser, 0).then((List rel){

                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditRestaurante(prop: this.widget.prop,tiposdecomida:typesf,tipos: rel,)),
                              );

              

                
  });

             });
  }
       
          
}
Widget createTable(List pratos,BuildContext context,List typesf,Proprietario prop) {
   
 //=get das pratos que se precisa e do dia
    List<TableRow> rows = [];
  rows.add(TableRow(children: [
    
        Text("Dia"),
        Text("Tipo"),
        Text("Nome"),
        Text("Preço"),
        Text("Ação")
        
      ]));
    for (Prato p in pratos)//a ideia é por o count
     {
if(p.id!=0){
      rows.add(TableRow(children: [

            Text(p.datar.toString().split(' ')[0]),
            Text(p.refeicao),
            Text(p.nome),
            Text(p.preco.toString()),
            new SizedBox(
       width: 27.0,
       height: 20.0,child:RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Eliminar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12),
            ),]),
 onPressed:(){ //Navigator.push(context,MaterialPageRoute(builder: (context){
 Future<int> x = p.deletePrato(p.id).then((int x){
  Future<List> pras = p.getPratosDaSemana(p.idprop).then((List pratosDaSemana){
  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Pratos(prop: prop,tiposdecomida:typesf, pratos:pratosDaSemana,)),
                              ); }); });  }
          ))
      ]));
    }}
    return Table( border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 0.5,

        ),
        verticalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 0.5,
        ),
      )
      ,children: rows);
  }