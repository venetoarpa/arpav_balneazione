import 'dart:async';
import 'dart:convert';

import 'package:arpav_balneazione/models/sito.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'theme.dart' as UICustom;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Prova app Flutter',
      theme: new ThemeData(
        primarySwatch: UICustom.CompanyColors.green,
      ),

      home: new HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  createState() => new ContainerHomePageState();

}

class ContainerHomePageState extends State<HomePage>{

  final _saved = new Set<Sito>();
  List<Sito> _siti = <Sito>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Arpav Balneazione"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.favorite_border), onPressed: _pushSaved)
        ],
      ),
      body: FutureBuilder<List<Sito>>(
        future: caricaDatiBalnezione(),
        builder: (context, data) {
          if(data.hasData){
            _siti = data.data;
            return _buildSuggestion();
          }else {
            return new Text("Errore dati non disponibili");
          }
        },
      )
    );
  }

  Widget _buildSuggestion(){
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        if(i.isOdd) return new Divider();
        //final index = i ~/ 2;
        

        return _buildRow(_siti[i]);
        
      },
    );
  }

  Widget _buildRow(Sito sito) {

    final alreadySaved = _saved.contains(sito);

    return new ListTile(
      title: new Text(sito.descr, style: _biggerFont),
      trailing: new Icon(alreadySaved ? Icons.star : Icons.star_border, color: alreadySaved ? Colors.yellow : null,),
      onTap: () {
        setState(() {
          if(alreadySaved){
            _saved.remove(sito);
          }else{
            _saved.add(sito);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                    pair.descr,
                    style: _biggerFont),
              );
            }
        );
        final divider = ListTile.divideTiles(context: context, tiles: tiles).toList();

        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Preferiti"),
          ),
          body: new ListView(children: divider,),
        );

      })
    );
  }


  Future<List<Sito>> caricaDatiBalnezione() async {
    final siti = new List<Sito>();
    final response = await http.get('http://www2.arpa.veneto.it/dati/xml/balneazione/BALNEAZIONE.xml');
    print("chiamo http://www2.arpa.veneto.it/dati/xml/balneazione/BALNEAZIONE.xml");
    //var document = xml.parse(response.body);
    final Xml2Json myTransformer = new Xml2Json();
    myTransformer.parse(response.body);
    String siti_json = myTransformer.toParker();
    print(siti_json);

    Map<String, dynamic> data = json.decode(siti_json);

    for(Map<String, dynamic> row in data['data']['row']){
      siti.add(Sito.fromXml(row));
    }

    return siti;
  }

}



