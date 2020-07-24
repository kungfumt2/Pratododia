import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/PreferenciasModel.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/RelTipo.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Models/Login.dart';
import 'package:sampleproject/Views/EditRestaurante.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/MainPageProp.dart';
import 'package:sampleproject/Views/Pratos.dart';
import 'package:sampleproject/Views/Preferencias.dart';
import 'package:sampleproject/Views/RegistoProprietario.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';

class NovoPrato extends StatefulWidget {

  Proprietario prop;
   List tiposdecomida;
   List pratos;   
 

 NovoPrato({Key key,@required this.prop, @required this.tiposdecomida, @required this.pratos}):super(key:key);

  
  @override
  _NovoPratoState createState() => _NovoPratoState();
}


  

class _NovoPratoState extends State<NovoPrato> {
  List<bool> isSelected;

  String pratotype = "";


   List dias;   
   List<DropdownMenuItem<String>> _dropDownMenuItems;
    List<DropdownMenuItem<String>> _dropDownMenuItemsDatas;
   String _currenttipo;
   String _currentdata;

   final nomepratocont = TextEditingController();
   final descontroller = TextEditingController();
   final precocontroller = TextEditingController();

    File imageFile;

   _openGallery() async{

      var picture = await ImagePicker.pickImage(source: ImageSource.gallery);

      this.setState(() {

        imageFile = picture;
        
      });

      Navigator.of(context).pop();
   }

   _openCamera() async {

      var picture = await ImagePicker.pickImage(source: ImageSource.camera);

      this.setState(() {

        imageFile = picture;
        
      });

       Navigator.of(context).pop();

   }

   Future<void> _showChoiceDialog(BuildContext context){

     return showDialog(context: context,builder: (BuildContext context){

        return AlertDialog(
          title: Text("Escolha um método"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[GestureDetector(
                child:Text("Abrir Galeria"),
                onTap: (){

                  _openGallery();

                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child:Text("Abir Camara"),
                onTap: (){

                  _openCamera();

                }
              )],
            )
          ),);
     });
   }

   @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _dropDownMenuItemsDatas = getDropDownMenuItemsDatas();
    _currenttipo = _dropDownMenuItems[0].value;
    _currentdata = _dropDownMenuItemsDatas[0].value;
    super.initState();
  }

   List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();


    for (TipoDeComida tipo in this.widget.tiposdecomida) {
      items.add(new DropdownMenuItem(
          value: tipo.tipo,
          child: new Text(tipo.tipo)
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsDatas() {
    List<DropdownMenuItem<String>> items = new List();

    List<String> datas = new List<String>();

    for(Prato plate in this.widget.pratos)
    {
       if(plate.nome == "Sem informação")
      {
        datas.add(plate.datar.toString());
      }
    }

    var distinctIds = datas.toSet().toList();


    for (String prato in distinctIds) {

     
        items.add(new DropdownMenuItem(
            value: prato,
            child: new Text(prato.split(' ')[0])
        ));

      
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    
    Utilizador user = new Utilizador();

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

      body:Center( child:Column(
        
            children: <Widget>[
              Text("${this.widget.prop.nomerestaurante}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) ),
                       SizedBox(height: 20),
                        SizedBox(height: 10,),
                        Text("Nome do Prato", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: nomepratocont,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Nome do  Prato',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            ), SizedBox(height: 10),

                     Text("Descrição", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: descontroller,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Descrição do  Prato',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            ), 
                               Text("Tipo do Prato", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
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
             Text("Preço", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextField(
                autofocus: false,
                controller: precocontroller,
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Preço do  Prato',
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                ),
                   Text("Data do prato", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
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
                value: _currentdata,
                items: _dropDownMenuItemsDatas,
                onChanged: changedDropDownItemDatas,
              ),
                Text("Tipo de Prato", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),SizedBox(height: 10,), Row(children: [ SizedBox(width: 70,),
        FlatButton(
                onPressed: () => typeButton("Carne"),
                color: pratotype == "Carne" ? Colors.green : Colors.grey,
                padding: EdgeInsets.all(10.0),
                child: Column( 
                  children: <Widget>[
                  
                    Image.asset("images/carneicon.png",height: 75, width: 75),
                    Text("Carne", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12) ),
 
                  ],
                )),


                SizedBox(width: 75,),

                
        FlatButton(
                onPressed: () => typeButton("Peixe"),
                color: pratotype == "Peixe" ? Colors.green : Colors.grey,
                padding: EdgeInsets.all(10.0),
                child: Column( // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                   
                    Image.asset("images/peixeicon.png",height: 75, width: 75),
                     Text("Peixe", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:12) ),
                  ],
                )),]
                ),

                RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Adicionar Fotografia", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 80,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 

                  _showChoiceDialog(context);
           
           },
     ) , 
                
            RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Adicionar Prato", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 80,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 
              
              Prato pp = new Prato();

              pp.idprop = this.widget.prop.iduser;
              pp.id = 0;

              pp.nome = nomepratocont.text;
              pp.refeicao = pratotype;
              pp.descricao = descontroller.text;
              pp.tipo = _currenttipo;
              pp.preco = double.parse(precocontroller.text);
              pp.datar = DateTime.parse(_currentdata);

              List<int> list = imageFile.readAsBytesSync();
              Uint8List bytes = Uint8List.fromList(list);

              pp.fotografia = bytes;
              
              if(pp.refeicao == "Carne")
              {

                  Future<int> createprato = pp.createPrato(pp).then((int sc){

                    if(sc == 200)
                    {
                       Future<List> pras = pp.getPratosDaSemana(this.widget.prop.iduser).then((List pratosDaSemana){

                       Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Pratos(prop: this.widget.prop,tiposdecomida:this.widget.tiposdecomida, pratos:pratosDaSemana,)),
                              );

               });
                    }

                  });



               
              }
              else
              {

                   Future<int> createprato = pp.createPrato(pp).then((int sc){

                    if(sc == 200)
                    {
                       Future<List> pras = pp.getPratosDaSemana(this.widget.prop.iduser).then((List pratosDaSemana){

                       Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Pratos(prop: this.widget.prop,tiposdecomida:this.widget.tiposdecomida, pratos:pratosDaSemana,)),
                              );

               });
                    }

                  });


                  

               

              }

       
              

           },
     ) ],
      
            
          ),
    ));

     
  }
  
changedDropDownItem(String selectedtipo) {
    setState(() {
      _currenttipo = selectedtipo;
      print(_currenttipo);
    });
  }

   changedDropDownItemDatas(String selectedata) {
    setState(() {
      _currentdata = selectedata;
      print(_currentdata);

    });
  }

  typeButton(String v){
     setState(() {
   pratotype = v;

    });
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