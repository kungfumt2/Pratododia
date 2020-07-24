import 'dart:io';
import 'package:sync_http/sync_http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';

class Utilizador extends Model{

  int id;
  String username;
  String nome;
  String password;
  String email;
  String estado;
  DateTime dataadesao;

  Utilizador({int idd, String usern, String name, String pw, String mail, String state, DateTime da})
  {

    this.id = idd;
    this.username = usern;
    this.nome = name;
    this.password = pw;
    this.email = mail;
    this.estado = state;
    this.dataadesao = da;

  }

  factory Utilizador.fromJson(Map<String,dynamic> json){


    return Utilizador(
      idd: json['id'] as int,
      usern: json['username'] as String,
      name: json['nome'] as String,
      pw: json['password'] as String,
      mail: json['email'] as String,
      state: json['estado'] as String,
      da: DateTime.parse( json['dataAsesao']) 
    );

  }

  Future<List> getutilizadores() async {
  


  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Utilizador"),
    headers:{
      "Accept":"application/json"
    }
  );

  List lista = json.decode(response.body);

  List<Utilizador> listau = new List<Utilizador>();

  Utilizador user = Utilizador.fromJson(lista[0]);

  print(user);

  
  for(int i = 0; i < lista.length; i++)
  {   listau.add(Utilizador.fromJson(lista[i]));
     print(listau);
   }
  print(listau);
  return listau;
}



 Future<int> createUtilizador(Utilizador user) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Utilizador';
  var body = json.encode(<String, String>{
      'Id': user.id.toString(),
      'Username': user.nome,
      'Nome':user.nome.toString(),
      'Password': user.password,
      'Email':user.email,
      'Estado':user.estado,
      'DataAsesao':user.dataadesao.toString()

    });

  print(body);


  http.Response response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  return int.parse(response.body);
}
  
Future<Utilizador> getutilizador(int idd, String role) async {
  

  http.Response response = await http.get(
    Uri.encodeFull("http://3b61d9bbb70d.ngrok.io/api/Utilizador/"+ idd.toString()+"/"+role),
    headers:{
      "Accept":"application/json"
    }
  );


  Utilizador user = Utilizador.fromJson(json.decode(response.body));

  
  

  return user;
}

Future<int> updateUtilizador(int id, String what, String value) async {

  var url ='http://3b61d9bbb70d.ngrok.io/api/Utilizador/' + id.toString();

  List<String> lista = [what,value];

  var body = json.encode(lista); 

  print(body);



 http.Response response = await http.put(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );
  return response.statusCode;
}




}