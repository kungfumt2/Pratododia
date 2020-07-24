import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sampleproject/Models/FotografiasR.dart';
import 'package:sampleproject/Models/Prato.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/RelTipo.dart';
import 'package:sampleproject/Models/TipoDeComida.dart';
import 'package:sampleproject/Models/Utilizador.dart';
import 'package:sampleproject/Models/Cliente.dart';
import 'package:sampleproject/Views/Loggin.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/MainPageProp.dart';
import 'package:sampleproject/Views/Pratos.dart';
import 'package:sampleproject/Views/RegistoProprietario.dart';
import 'package:sampleproject/Views/Restaurante.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sampleproject/Views/DefinirCoordenadas.dart';

class EditRestaurante extends StatefulWidget {
  Proprietario prop;
  List tiposdecomida;
  List tipos;
      EditRestaurante({Key key,@required this.prop, @required this.tiposdecomida,@required this.tipos}):super(key:key);
  @override
  _EditRestauranteState createState() => _EditRestauranteState();
}

class _EditRestauranteState extends State<EditRestaurante> {
  //fazer get do proprietario logado
   List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currenttipo;

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
    _currenttipo = _dropDownMenuItems[0].value;
    super.initState();
  }
   List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();


    for (TipoDeComida tipo in  this.widget.tiposdecomida) {
      items.add(new DropdownMenuItem(
          value: tipo.id.toString(),
          child: new Text(tipo.tipo)
      ));
    }
    return items;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (drawer: Drawer(
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
               RatingBar(
                initialRating: this.widget.prop.avaliacao,
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
                  
                },
               ),
  Text("Descrição", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize:15) ),
             TextFormField(
                autofocus: false,
                initialValue: '${this.widget.prop.descricao}',
                style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                decoration: InputDecoration(
                 
                  contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
            validator: (value) {
              if (!value.isNotEmpty) {
               

               return null;

              }
              else
              {
                return "Todos os parametros são de preenchimento obrigatorio";
              }
              
            },
             onChanged:(String str){
              this.widget.prop.nomerestaurante = str;
            },), SizedBox(height: 10),
 
                createTable(),
//falta a parte do tipo e das fotos
 SizedBox(height: 40,),new SizedBox(
       width: 200.0,
       height: 50.0,child: RaisedButton(color: Theme.of(context).accentColor,child:Row(children: [Text("Adicionar Fotos", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),),SizedBox(width: 19,),Icon(Icons.arrow_forward, color: Colors.white,),]),onPressed:(){ 
             
              _showChoiceDialog(context);

              FotografiasR foto = new FotografiasR();

              foto.idprop = this.widget.prop.iduser;

              List<int> list = imageFile.readAsBytesSync();
              Uint8List bytes = Uint8List.fromList(list);
              
              foto.foto = bytes;

              Future<int> addfoto = foto.createFotografiasR(foto).then((int sc){

                if(sc == 200){
                  
                       Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditRestaurante(prop: this.widget.prop,tiposdecomida:this.widget.tiposdecomida, tipos: this.widget.tipos,)),
                              );
                }

              });
       
            },),
            
            
            
            ),

            ]))
    );
  }
  Widget createTable() {
   
  //List <Preferenciasmodel> pratos;
 //=get das preferencias
    List<TableRow> rows = [];
  rows.add(TableRow(children: [
    
        Text("Tipo de Comida"),
        Text("Ação")
      ]));
    for (RelTipo row in this.widget.tipos) {

      

      String nomedacomida;

      for(var type in this.widget.tiposdecomida)
      {
        if(row.idt == type.id)
        {
          nomedacomida = type.tipo;

        }
      }
      rows.add(TableRow(children: [
        
           
            Text(nomedacomida),
      
            RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Eliminar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),
            ),
           
            ]
            ),

            onPressed:(){
//fazer o delete
RelTipo r=new RelTipo();
                         Future<int> x = r.deleteRelTipo(row.idt,row.idp).then((int x){
  Future<List> pras = r.getRelTipo(row.idp, 0).then((List pratosDaSemana){
                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditRestaurante(prop: this.widget.prop, tipos: pratosDaSemana, tiposdecomida: this.widget.tiposdecomida,)),
                                  );}); });
                      
                 
            }
            )
      ]));}
      rows.add(TableRow(children: [
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
      RaisedButton(color: Colors.blue,child:Row(children: [
            Text("Adicionar", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15),
            ),
           
            ]
            ),

            onPressed:(){

            RelTipo rel = RelTipo();

     
            rel.idp= this.widget.prop.iduser;
            rel.idt = int.parse(_currenttipo);

          

            Future<int> relreq = rel.createRelTipo(rel).then((int value){

              if(value == 200)
              {

                   Future<List> mreq = rel.getRelTipo(rel.idp, 0).then((List mypref){

                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditRestaurante(prop:this.widget.prop, tiposdecomida: this.widget.tiposdecomida, tipos: mypref,)),
                                  );

                      
                    });

              }

            });



                           

            }
            ),
        
      ]));
   
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
    void changedDropDownItem(String selectedtipo) {
    setState(() {
      _currenttipo = selectedtipo;
      print(selectedtipo);
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