import 'dart:async';
import 'dart:convert';

import 'package:arpav_balneazione/models/sito.dart';
import 'package:flutter/material.dart';

import 'theme.dart' as UICustom;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

void main() => runApp(new MyApp());

List<Sito> _siti;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Arpav Balneazione',
      theme: new ThemeData(
        primarySwatch: UICustom.CompanyColors.green,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new HomePage(),
        '/ElencoFiltered': (BuildContext context) => new ElencoFilteredSito(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  caricaDatiBalnezione() async {
    _siti = new List<Sito>();
    final response = await http
        .get('http://www2.arpa.veneto.it/dati/xml/balneazione/BALNEAZIONE.xml');
    print(
        "chiamo http://www2.arpa.veneto.it/dati/xml/balneazione/BALNEAZIONE.xml");
    //var document = xml.parse(response.body);
    final Xml2Json myTransformer = new Xml2Json();
    myTransformer.parse(response.body);
    String siti_json = myTransformer.toParker();
    print(siti_json);

    Map<String, dynamic> data = json.decode(siti_json);

    for (Map<String, dynamic> row in data['data']['row']) {
      _siti.add(Sito.fromXml(row));
    }

    navigationPage();
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  @override
  void initState() {
    super.initState();
    caricaDatiBalnezione();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("images/splash.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: null /* add child content content here */,
    ));
  }
}

class HomePage extends StatefulWidget {
  @override
  createState() => new ContainerHomePageState();
}

class ContainerHomePageState extends State<HomePage> {
  final _saved = new Set<Sito>();

  //List<Sito> _siti = <Sito>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Arpav Balneazione"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite_border),
              onPressed: () => _pushSaved(context, _saved))
        ],
      ),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Row(
              children: [
                new Expanded(
                  child: new Image.asset(
                    'images/topbarlogo.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),

            new Row(
              children: [
                new Expanded(
                  child: new Image.asset(
                    'images/box1.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),

            new Container(
              padding: const EdgeInsets.all(16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: const EdgeInsets.all(15.0) ,
                    margin: const EdgeInsets.all(5.0),
                    color: UICustom.CompanyColors.green,
                    child: new Row(
                      children: [
                        new Container(
                          padding: const EdgeInsets.all(5.0) ,
                          child: new Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35.0,

                          ),
                        ),

                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text('Mare Adriatico',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(15.0) ,
                    color: UICustom.CompanyColors.green,
                    child: new Row(
                      children: [
                        new Container(
                          padding: const EdgeInsets.all(5.0) ,
                          child: new Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35.0,

                          ),
                        ),

                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text('Lago di Garda',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(15.0) ,
                    color: UICustom.CompanyColors.green,
                    child: new Row(
                      children: [
                        new Container(
                          padding: const EdgeInsets.all(5.0) ,
                          child: new Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35.0,

                          ),
                        ),

                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text('Altro',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElencoFilteredSito extends StatefulWidget {
  @override
  createState() => new ContainerElencoFilteredSitoState();
}

class ContainerElencoFilteredSitoState extends State<ElencoFilteredSito> {
  final _saved = new Set<Sito>();

  //List<Sito> _siti = <Sito>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Arpav Balneazione"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite_border),
              onPressed: () => _pushSaved(context, _saved))
        ],
      ),
      body: (_siti.length > 0)
          ? _buildSuggestion()
          : new Text("Errore dati non disponibili"),
    );
  }

  Widget _buildSuggestion() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        //final index = i ~/ 2;

        return _buildRow(_siti[i]);
      },
    );
  }

  Widget _buildRow(Sito sito) {
    final alreadySaved = _saved.contains(sito);

    return new ListTile(
      title: new Text(sito.descr, style: _biggerFont),
      trailing: new Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.yellow : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(sito);
          } else {
            _saved.add(sito);
          }
        });
      },
    );
  }
}

//todo saved saranno presi da cache app
void _pushSaved(context, _saved) {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
    final tiles = _saved.map((pair) {
      return new ListTile(
        title: new Text(pair.descr, style: _biggerFont),
      );
    });
    final divider =
        ListTile.divideTiles(context: context, tiles: tiles).toList();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Preferiti"),
      ),
      body: new ListView(
        children: divider,
      ),
    );
  }));
}
