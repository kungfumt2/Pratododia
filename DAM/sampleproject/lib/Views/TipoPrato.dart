
import 'package:flutter/material.dart';
import 'package:sampleproject/Models/Proprietario.dart';
import 'package:sampleproject/Models/RelTipo.dart';
import 'package:sampleproject/Views/MainPage.dart';
import 'package:sampleproject/Views/MainPageProp.dart';

class TipoPrato extends StatefulWidget {

int iduser;

TipoPrato({Key key,@required this.iduser}) : super(key: key);
  
  @override
  _TipoPratoState createState() => _TipoPratoState();

   
}

  

class _TipoPratoState extends State<TipoPrato> {

bool portuguesa = false;
bool italiana = false;
bool japonesa = false;
bool fastfood = false;

  @override
  Widget build(BuildContext context) {

    
    List<Widget> lista  = getwidgets();

   

    return Scaffold(
      appBar: AppBar(
        title: Text('PratoDoDia'),
        backgroundColor: Colors.red,
      ),

      body: Center(child:Column(children: lista,))
      
    );


}

List<Widget> getwidgets()
{
  List<Widget> w = [Center(child:Text("TIPO DE COMIDA", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:24) )),
        SizedBox(height: 20),Text("Que tipo de comida caracteriza o seu restaurante?", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.red, fontSize:10) ),SizedBox(height: 20),Row(children: [ SizedBox(width: 50,),
        FlatButton(
                onPressed: () => portuguesaButton(),
                color: portuguesa ? Colors.green : Colors.red,
                padding: EdgeInsets.all(10.0),
                child: Column( 
                  children: <Widget>[
                  
                    Image.asset("images/galo.png",height: 100, width: 100),
                    Text("Portuguesa", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15) ),
 
                  ],
                )),


                SizedBox(width: 75,),

                
        FlatButton(
                onPressed: () => italianaButton(),
                color: italiana ? Colors.green : Colors.red,
                padding: EdgeInsets.all(10.0),
                child: Column( // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                   
                    Image.asset("images/italiana.png",height: 100, width: 100),
                     Text("Italiana", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15) ),
                  ],
                )),]),

                

                SizedBox(height: 100,),

              Row(children: [ SizedBox(width: 50,),
        FlatButton(
                onPressed: () => japonesaButton(),
                color: japonesa ? Colors.green : Colors.red,
                padding: EdgeInsets.all(10.0),
                child: Column( 
                  children: <Widget>[
                   
                    Image.asset("images/sushi.png",height: 100, width: 100),
                    Text("Japonesa", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15) ),
                  ],
                )),


                SizedBox(width: 70,),


        FlatButton(
                onPressed: () => fastfoodButton(),
                color: fastfood ? Colors.green : Colors.red,
                padding: EdgeInsets.all(10.0),
                child: Column( // Replace with a Row for horizontal icon + text
                  children: <Widget>[

                    Image.asset("images/burger.png",height: 100, width: 100),
                    Text("Fast Food", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15) ),
                  ],
                )),]), SizedBox(height: 70,),

        SizedBox(height: 40),];
 
  

      w.add(  new SizedBox(
       width: 200.0,
       height: 50.0,child:RaisedButton(color: Theme.of(context).accentColor,child:Row(children:[ Text("Próximo", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize:15) ),SizedBox(width: 60,), Icon(Icons.arrow_forward, color: Colors.white,)]),onPressed:(){
          
          int npref = 0;

          if(portuguesa)
          {
            npref++;
          }

          if(italiana)
          {
            npref++;
          }

           if(japonesa)
          {
            npref++;
          }

          if(fastfood)
          {
            npref++;
          }
                    
          
           switch(portuguesa)
           {
             case true:
              RelTipo relTipo = new RelTipo();

              relTipo.idp = this.widget.iduser;
              relTipo.idt = 1;

              Future<int> relreq = relTipo.createRelTipo(relTipo).then((int sc){

                if(sc == 200)
                {
                  npref--;

                  if(npref == 0)
                  {
                    Proprietario prop = new Proprietario();

                    Future<Proprietario> propreq = prop.getProprietario(this.widget.iduser,).then((Proprietario value){

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPageProp(prop: value)),
                        );

                    });
                  }
                }
              });

              break;

            case false:
              break;
              
           }

           switch(italiana)
           {
             case true:
              RelTipo relTipo = new RelTipo();

              relTipo.idp = this.widget.iduser;
              relTipo.idt = 3;

               Future<int> relreq = relTipo.createRelTipo(relTipo).then((int sc){

                if(sc == 200)
                {
                  npref--;

                  if(npref == 0)
                  {
                     Proprietario prop = new Proprietario();

                    Future<Proprietario> propreq = prop.getProprietario(this.widget.iduser).then((Proprietario value){

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPageProp(prop: value)),
                        );

                    });
                  
                  }
                }
              });


              break;

              case false:
              break;

           }

           switch(japonesa)
           {
             case true:
              RelTipo relTipo = new RelTipo();

              relTipo.idp = this.widget.iduser;
              relTipo.idt = 2;

               Future<int> relreq = relTipo.createRelTipo(relTipo).then((int sc){

                if(sc == 200)
                {
                  npref--;

                  if(npref == 0)
                  {
                     Proprietario prop = new Proprietario();

                     Future<Proprietario> propreq = prop.getProprietario(this.widget.iduser).then((Proprietario value){

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPageProp(prop: value)),
                        );

                    });
                    
                  }
                }
              });


              break;

              case false:
              break;
           }

           switch(fastfood)
           {
             case true:
              RelTipo relTipo = new RelTipo();

              relTipo.idp = this.widget.iduser;
              relTipo.idt = 4;

              Future<int> relreq = relTipo.createRelTipo(relTipo).then((int sc){

                if(sc == 200)
                {
                  npref--;

                  if(npref == 0)
                  {
                     Proprietario prop = new Proprietario();

                    Future<Proprietario> propreq = prop.getProprietario(this.widget.iduser).then((Proprietario value){

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPageProp(prop: value)),
                        );

                    });
                  }
                }
              });


              break;

              case false:
              break;

           }
             
      },)));

  return w;
}

portuguesaButton(){
    setState(() {
    portuguesa = !portuguesa;

    });
  }

   italianaButton(){
    setState(() {
    italiana = !italiana;

    });
  }

  japonesaButton(){
    setState(() {
    japonesa = !japonesa;

    });
  }

  fastfoodButton(){
    setState(() {
    fastfood = !fastfood;

    });
  }
  

}