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
                  new GestureDetector(
                    onTap: () {
                      //mare adriatico
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            List<Sito> filter = filtra_siti("Mare Adriatico");
                            List<String> comuni =
                                prendiSoloComuniDistinct(filter);
                            FilterPage page =
                                new FilterPage(comuni, "Mare Adriatico");
                            return ContainerListSitiState(
                              page: page,
                            );
                          },
                        ),
                      ); //Navigator
                    },
                    child: new Container(
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.all(5.0),
                      color: UICustom.CompanyColors.green,
                      child: new Row(
                        children: [
                          new Container(
                            padding: const EdgeInsets.all(5.0),
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
                  ),
                  new GestureDetector(
                    onTap: () {
                      //lago di garda
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            List<Sito> filter2 = filtra_siti("Lago di Garda");
                            List<String> comuni =
                                prendiSoloComuniDistinct(filter2);
                            FilterPage page2 =
                                new FilterPage(comuni, "Lago di Garda");
                            return ContainerListSitiState(
                              page: page2,
                            );
                          },
                        ),
                      ); //Navigator
                    },
                    child: new Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(15.0),
                      color: UICustom.CompanyColors.green,
                      child: new Row(
                        children: [
                          new Container(
                            padding: const EdgeInsets.all(5.0),
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
                  ),
                  new GestureDetector(
                    onTap: () {
                      // altro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            List<Sito> filter3 = filtra_siti("Altro");
                            print(filter3.length);
                            print(" COMUNI ");
                            List<String> comuni =
                                prendiSoloComuniDistinct(filter3);
                            print(comuni.length);
                            FilterPage page3 = new FilterPage(comuni, "Altro");
                            return ContainerListSitiState(
                              page: page3,
                            );
                          },
                        ),
                      ); //Navigator
                    },
                    child: new Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(15.0),
                      color: UICustom.CompanyColors.green,
                      child: new Row(
                        children: [
                          new Container(
                            padding: const EdgeInsets.all(5.0),
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

class FilterPage {
  List<String> siti_filter;
  String title;

  FilterPage(this.siti_filter, this.title);
}

class FilterPage2 {
  List<Sito> siti_filter;
  String title;

  FilterPage2(this.siti_filter, this.title);
}

class ContainerListSitiState extends StatelessWidget {
  final _saved = new Set<Sito>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  FilterPage page;

  ContainerListSitiState({Key key, @required this.page}) : super(key: key);

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(page.title),
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

              new Expanded(
                child:(page.siti_filter.length > 0)
                    ? _buildSuggestion()
                    : new Text("Errore dati non disponibili") ,
              ),

             // new Container(child: ,)

            ]),
      ),
    );
  }

  Widget _buildSuggestion() {
    return new ListView.builder(
      itemCount: page.siti_filter.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;

        return _buildRow(page.siti_filter[index]);
      },
    );
  }

  Widget _buildRow(String sito) {
    //final alreadySaved = page.siti_filter.contains(sito);

    return new ListTile(
      title: new Text(sito, style: _biggerFont),
      trailing: new Icon(
        Icons.chevron_right,
        color: UICustom.CompanyColors.green,
      ),
      onTap: () {
        // creare la lista per comune di stringe da aprire

        List<Sito> data = filtra_siti_percomune(sito);
        FilterPage2 page2 = new FilterPage2(data, sito);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ContainerListSitiDettaglioComuneState(
                page: page2,
              );
            },
          ),
        );
      },
    );
  }
}

class ContainerListSitiDettaglioComuneState extends StatelessWidget {
  final _saved = new Set<Sito>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  FilterPage2 page;
  BuildContext context;

  ContainerListSitiDettaglioComuneState({Key key, @required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    this.context = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(page.title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite_border),
              onPressed: () => _pushSaved(context, _saved))
        ],
      ),
      body:  new Container(
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

              new Expanded(
                child:(page.siti_filter.length > 0)
                    ? _buildSuggestion()
                    : new Text("Errore dati non disponibili") ,
              ),

              // new Container(child: ,)

            ]),
      ),
    );
  }

  Widget _buildSuggestion() {
    return new ListView.builder(
      itemCount: page.siti_filter.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;

        return _buildRow(page.siti_filter[index]);
      },
    );
  }

  Widget _buildRow(Sito sito) {
    //final alreadySaved = page.siti_filter.contains(sito);

    var color = Colors.red;

    if (sito.statoatt == 'BLU') {
      color = Colors.blue;
    } else if (sito.statoatt == 'GIALLO') {
      color = Colors.yellow;
    }

    return new ListTile(
      title: new Text(sito.descr, style: _biggerFont),
      leading: new Icon(Icons.flag, color: color),
      trailing: new Icon(
        Icons.chevron_right,
        color: UICustom.CompanyColors.green,
      ),
      onTap: () {
        // dettaglio zona

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ContainerDetailSito(
                sito: sito,
              );
            },
          ),
        );
      },
    );
  }
}

class ContainerDetailSito extends StatelessWidget {
  final _saved = new Set<Sito>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Sito sito;

  ContainerDetailSito({Key key, @required this.sito}) : super(key: key);

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;

    var color = Colors.red;

    if (sito.statoatt == 'BLU') {
      color = Colors.blue;
    } else if (sito.statoatt == 'GIALLO') {
      color = Colors.yellow;
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(sito.descr),
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
              new Row(children: [
                new Icon(
                  Icons.flag,
                  color: color,
                  size: 50.0,
                ),
                new Column(children: [
                  new Text(sito.descr),
                  new Text(sito.comune),
                  new Text(sito.corpo_idrico),
                  new Text(sito.statoatt + " " + sito.data_campione),
                ])
              ])
            ]),
      ),
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

List<String> prendiSoloComuniDistinct(List<Sito> siti) {
  List<String> resutls = new List<String>();
  for (Sito sito in siti) {
    if (!resutls.contains(sito.comune.toUpperCase())) {
      resutls.add(sito.comune.toUpperCase());
      print("add " + sito.comune.toUpperCase());
    }
  }
  return resutls;
}

List<Sito> filtra_siti(String string) {
  List<Sito> resutls = new List<Sito>();
  for (Sito sito in _siti) {
    if (string == "Altro") {
      if (sito.corpo_idrico.toUpperCase() != "LAGO DI GARDA") {
        if (sito.corpo_idrico.toUpperCase() != "MARE ADRIATICO") {
          print("added " + sito.corpo_idrico.toUpperCase());
          resutls.add(sito);
        }
      }
    } else {
      if (sito.corpo_idrico.toUpperCase() == string.toUpperCase()) {
        resutls.add(sito);
      }
    }
  }

  return resutls;
}

List<Sito> filtra_siti_percomune(String string) {
  List<Sito> resutls = new List<Sito>();
  for (Sito sito in _siti) {
    if (sito.comune.toUpperCase() == string.toUpperCase()) {
      resutls.add(sito);
    }
  }
  return resutls;
}
