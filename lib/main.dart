import 'dart:async';
import 'dart:convert';

import 'package:arpav_balneazione/models/sito.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'theme.dart' as UICustom;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main(){
  runApp( new MyApp());
}

const platform = const MethodChannel('samples.flutter.io/battery');

List<Sito> _siti;
List<Sito> _pref;

_getPreferiti() async {
  _pref = new List<Sito>();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String preferiti = (prefs.getString('preferiti') ?? "");
  print('Pressed $preferiti times.');
  if(preferiti != "") {
    var json_pref = json.decode(preferiti);
    for (var jj in json_pref) {

      Sito p = Sito.fromJsonSmall(jj);
      if(p.descr != null) {
        _pref.add(p);
      }
    }
    _setPreferiti();
  }

  //await prefs.setInt('counter', counter);
}

_setPreferiti() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var json_pref = [];
  for(Sito sito in _pref){
    json_pref.add(sito.toJson());
  }
  await prefs.setString('preferiti', json.encode(json_pref));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Arpav Balneazione',
      debugShowCheckedModeBanner: false,
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

    _getPreferiti();

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
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Arpav Balneazione"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite_border),
              onPressed: () => _pushSaved(context)),
          new IconButton(
              icon: new Icon(Icons.info_outline),
              onPressed: () => _openInfo(context))
        ],
      ),
      body:  new ListView(
        children: <Widget>[
          new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                new Row(
                  children: [
                    new Expanded(
                      child: new Image.asset(
                        'images/topbarlogo.png',
                        fit: BoxFit.contain,
                        height: 75.0,
                      ),
                    ),
                  ],
                ),
                new Row(
                  children: [

                    new Expanded(
                      child:new Container(

                        decoration: new BoxDecoration(
                          color: UICustom.CompanyColors.bluette
                        ),
                        height: 105.0,

                        child:

                            new Row (
                              children: <Widget>[

                                new Expanded(
                                  child: new Image.asset(
                                    'images/prima.png',
                                    fit: BoxFit.fitHeight,

                                  ),
                                ),

                                new Container(

                                  child: new Text("Seleziona la zona di tuo interesse\nper vedere gli aggiornamenti sullo\nstato di balneabilità oppure\nutilizza la funzione Preferiti per\naccedere alla tua lista", style: new TextStyle(color: Colors.black), textAlign: TextAlign.justify,)/* add child content content here */,
                                ),
                                new Expanded(
                                  child: new Image.asset(
                                    'images/due.png',
                                    fit: BoxFit.fitHeight,

                                  ),
                                ),
                              ],
                            )


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
                                new FilterPage(comuni, "Mare Adriatico","MARE ADRIATICO");
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
                                new FilterPage(comuni, "Lago di Garda", "LAGO DI GARDA");
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
                                List<String> comuni = prendiSoloCorpiIdriciDistinct(filter3);
                                print(comuni.length);
                                FilterPage page3 = new FilterPage(comuni, "Altri corpi idrici", "");
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
                                    new Text('Altri corpi idrici',
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
        ],
      )
    );
  }
}

class ContainerListSitiState extends StatelessWidget {
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
              onPressed: () => _pushSaved(context)),
          new IconButton(
              icon: new Icon(Icons.info_outline),
              onPressed: () => _openInfo(context))
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
                      fit: BoxFit.contain,
                      height: 75.0,
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
        //if (i.isOdd) return new Divider();
        final index = i ;//~/ 2;

        return new Column(
          children: <Widget>[
            _buildRow(page.siti_filter[index]),
            new Divider()
          ],
        ) ;

        //return _buildRow(page.siti_filter[index]);
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

        if(page.title == "Altri corpi idrici") {

          List<Sito> data = filtra_siti_percorpoidrico(sito);
          List<String> com = prendiSoloComuniDistinct(data);
          FilterPage pagepage = new FilterPage(com, sito, sito);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ContainerListSitiState(
                  page: pagepage,
                );
              },
            ),
          );


        }else {
          List<Sito> data = filtra_siti_percomune_corpoIdirco(sito, page.corpo_idrico);
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
        }

        
      },
    );
  }
}

class ContainerListSitiDettaglioComuneState extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  FilterPage2 page;
  BuildContext context;

  ContainerListSitiDettaglioComuneState({Key key, @required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    this.context = context;
    print("Elementi: " );
    print( this.page.siti_filter.length);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(page.title),
        actions: <Widget>[

          new IconButton(
              icon: new Icon(Icons.favorite_border),
              onPressed: () {
                if(page.title != 'Preferiti') {
                  _pushSaved(context);
                }
              }),
          new IconButton(
              icon: new Icon(Icons.info_outline),
              onPressed: () => _openInfo(context))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.map), onPressed: () {

        if(this.page.siti_filter.length > 0) {
          openMap(page.siti_filter, context);
        }else {

          Fluttertoast.showToast(
              msg: "Nessun luogo da mostrare",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1
          );
        }

      },),
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
                      fit: BoxFit.contain,
                      height: 75.0,
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
        //if (i.isOdd) return new Divider();
        final index = i ;
        print(page.siti_filter[index].descr);
        return new Column(
          children: <Widget>[
            _buildRow(page.siti_filter[index]),
            new Divider()
          ],
        ) ;
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
      title: new Text(sito.descr != null ? sito.descr : "np", style: _biggerFont),
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
            builder: (_) => new ContainerDetailSitoStateful(sito),
          ),
        );
      },
    );
  }
}

class ContainerDetailSitoStateful extends StatefulWidget {

  final Sito sito;

  ContainerDetailSitoStateful(this.sito);

  @override
  _ContainerDetailSitoStateful createState() => new _ContainerDetailSitoStateful(this.sito);
}

class _ContainerDetailSitoStateful extends State<ContainerDetailSitoStateful> {
  @override

  final _biggerFont = const TextStyle(fontSize: 18.0);
  Sito sito;
  BuildContext context;
  _ContainerDetailSitoStateful(this.sito);

  Widget build(BuildContext context) {
    // TODO: implement build

    this.context = context;

    var color = Colors.red;
    var statozona = "Zona permanentemente non idonea.";

    if (sito.statoatt == 'BLU') {
      color = Colors.blue;
      statozona = "Zona idonea.";
    } else if (sito.statoatt == 'GIALLO') {
      color = Colors.orange;
      statozona = "Zona temporaneamente non idonea.";
    }

    Icon icon_favorite =  new Icon( Icons.favorite_border, color: Colors.red, size: 35.0,);

    if(checkIfFavourite(sito)){
      icon_favorite =  new Icon( Icons.favorite, color: Colors.red, size: 35.0,);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(sito.descr),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite_border),
              onPressed: () => _pushSaved(context)),
          new IconButton(
              icon: new Icon(Icons.info_outline),
              onPressed: () => _openInfo(context))
        ],
      ),
      body:
      new ListView (
        children: <Widget>[
          new Container(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  new Row(
                    children: [
                      new Expanded(
                        child: new Image.asset(
                          'images/topbarlogo.png',
                          fit: BoxFit.contain,
                          height: 75.0,
                        ),
                      ),
                    ],
                  ),

                  new Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(15.0),
                    child:  new Text(
                      sito.comune,
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: UICustom.CompanyColors.green),

                    ),
                  ),

                  new Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(15.0),
                    color: UICustom.CompanyColors.grey,
                    child: new Row(children: [
                      new Container (
                        margin: const EdgeInsets.all(5.0),
                        child:  new Icon(
                          Icons.flag,
                          color: color,
                          size: 50.0,
                        ),
                      ),

                      new Flexible(

                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,

                              children: [

                                new Text(sito.descr,
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),

                                new Text(sito.corpo_idrico,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(fontSize: 16.0)),


                                new Text(statozona,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(fontSize: 16.0)),

                                new Text("Data ultimo prelievo: " + sito.data_campione,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(fontSize: 16.0)),
                                new Divider(),

                                new Text("Zona idonea: si intende una\nzona balneabile le cui acque\npresentano valori dei parametri\nnei limiti di legge",
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(fontSize: 16.0)),

                              ])
                      ),
                    ]),

                  ),

                  new Divider(),

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          new IconButton(icon: icon_favorite, onPressed: () {

                            setState((){

                              if(_aggiungirimuovipreferiti(sito)){
                                icon_favorite = new Icon( Icons.favorite, color: Colors.red, size: 35.0,);

                              }else {
                                icon_favorite = new Icon( Icons.favorite_border, color: Colors.red, size: 35.0,);
                              }

                            });

                          }),


                          new Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: new Text(
                              "Aggiungi ai\nPreferiti",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.red,

                              ),
                            ),
                          ),

                        ],),



                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new IconButton(icon: new Icon (Icons.map, color: UICustom.CompanyColors.green, size: 35.0,),  onPressed: () {
                            List<Sito> tmp = new List<Sito>();
                            tmp.add(sito);
                            openMap(tmp, context);
                          }),

                          new Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: new Text(
                              "Vai alla\nMappa",
                              style: new TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: UICustom.CompanyColors.green,
                              ),
                            ),
                          ),

                        ],)



                    ]
                    ,
                  )

                ]),
          ),
        ],
      )
    );
  }

}

openMap(List<Sito> siti , BuildContext context ) async {

  var siti_json = [];

  for(Sito sito in siti){
    siti_json.add(sito.toJson());
  }

  try {
    String sito_clicked = await platform.invokeMethod('getBatteryLevel', <String, dynamic>{
      "siti" : json.encode(siti_json)
    });
    print(sito_clicked);
    print(json.decode(sito_clicked));
    Sito sito = Sito.fromJsonSmall(json.decode(sito_clicked));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => new ContainerDetailSitoStateful(sito),

      ),
    );

    //print(_batteryLevel);

  } on PlatformException catch (e) {
    print( "errore non bello " + e.message);
  }


}

class InfoPageDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Informazioni"),
        ),
    body: new ListView(
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[

              new Text("Informazioni", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0), ),
              new Divider(),
              new RichText(
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: "La qualità delle acque di balneazione è fortemente collegata alla qualità dei corsi d’acqua, agli scarichi ed alle pressioni diffuse sul territorio. \nLa normativa, entrata in vigore nel 2010, prevede che durante la stagione balneare (15 maggio-15 settembre in Veneto), ci sia almeno un controllo al mese ed uno prima dell’inizio della stessa stagione. In caso di esito non favorevole di un'analisi dei 2 parametri batteriologici previsti (Escherichia coli e Enterococchi intestinali) viene data immediata comunicazione al Comune interessato per l’adozione dell’ordinanza di divieto di balneazione che potrà essere revocata a seguito di esito favorevole di una successiva analisi.\n\n"
                          "I dati analitici ottenuti nell'ambito del monitoraggio sono inviati, appena disponibili, al Portale Acque del Ministero della Salute. Gli stessi dati vanno ad implementare il Sistema Informativo Regionale Ambientale di ARPAV attraverso il quale viene aggiornata la",
                      style: new TextStyle(color: Colors.black,  fontSize: 16.0),
                    ),

                    new TextSpan(
                        text: ' situazione della balneabilità.',
                        style: new TextStyle(color: Colors.blue,  fontSize: 16.0),
                        recognizer: TapGestureRecognizer()..onTap = () => launch(
                            'http://www.arpa.veneto.it/temi-ambientali/acqua/datiacqua/balneazione_rete.php')
                    ),

                    new TextSpan(
                        text: "\n\nPer consultare i risultati analitici di un singolo punto della stagione in corso, cliccare sul comune interessato e successivamente sulla bandierina presente in mappa o in tabella.\nTutte le informazioni sulla balneazione, sulla classificazione e sullo storico sono disponibili sul sito di ARPAV nella sezione ",
                        style: new TextStyle(color: Colors.black,  fontSize: 16.0)
                    ),
                    new TextSpan(
                        text: "Acque – Balneazione.",
                        style: new TextStyle(color: Colors.blue,  fontSize: 16.0),
                        recognizer: TapGestureRecognizer()..onTap = () => launch(
                            'http://www.arpa.veneto.it/temi-ambientali/acqua/datiacqua/balneazione.php')
                    ),

                  ],
                ),
              ),
              new Divider(),
              new Text("Legenda", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0), ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Image.asset(
                        'images/bluFlag.png',
                        fit: BoxFit.contain,
                        height: 50.0,
                        width: 50.0
                      )
                        ]
                      ),
                      new Column(
                        children: <Widget>[new Text("Zona idonea")]
                      )
                      
                    ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Image.asset(
                        'images/yellowFlag.png',
                        fit: BoxFit.contain,
                        height: 50.0,
                        width: 50.0
                      )
                        ]
                      ),
                      new Column(
                        children: <Widget>[new Text("Zona temporaneamente non idonea")]
                      )
                      
                    ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Image.asset(
                        'images/redFlag.png',
                        fit: BoxFit.contain,
                        width: 50.0,
                        height: 50.0,
                      )
                        ]
                      ),
                      new Column(
                        children: <Widget>[new Text("Zona perenemmente non idonea")]
                      )
                      
                    ],
              )
            ],
          ) ,
        ),
      ],
    ),





    );

  }
}

class FilterPage {
  List<String> siti_filter;
  String title;
  String corpo_idrico;
  FilterPage(this.siti_filter, this.title, this.corpo_idrico);
}

class FilterPage2 {
  List<Sito> siti_filter;
  String title;

  FilterPage2(this.siti_filter, this.title);
}


void _pushSaved(context) {
  if(_pref.length > 0){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {

          FilterPage2 page2 = new FilterPage2(_pref, "Preferiti");
          return ContainerListSitiDettaglioComuneState(
              page: page2
          );
        },
      ),
    );
  }else{
    Fluttertoast.showToast(
        msg: "Nessun luogo preferito da mostrare",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1
    );

  }
}

void _openInfo(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return InfoPageDemo();
          },
        ),
      );
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

List<String> prendiSoloCorpiIdriciDistinct(List<Sito> siti) {
  List<String> resutls = new List<String>();
  for (Sito sito in siti) {
    if (!resutls.contains(sito.corpo_idrico.toUpperCase())) {
      resutls.add(sito.corpo_idrico.toUpperCase());
      print("add " + sito.corpo_idrico.toUpperCase());
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

  resutls = sothNorthToSouth(resutls);
  return resutls;
}


List<Sito> sothNorthToSouth(List<Sito> siti){

  siti.sort((a, b) {
    return (double.parse(a.y_wgs).compareTo(double.parse(b.y_wgs))) *-1;
  });

  return siti;
}

List<Sito> filtra_siti_percomune(String string) {
  List<Sito> resutls = new List<Sito>();
  for (Sito sito in _siti) {

    if (sito.comune.compareTo(string) == 0) {
      resutls.add(sito);
      print("AGGINTO" + sito.comune + " " + sito.descr);
    }
  }
  return resutls;
}

List<Sito> filtra_siti_percomune_corpoIdirco(String string, String corpoidrico) {
  List<Sito> resutls = new List<Sito>();
  for (Sito sito in _siti) {

    if (sito.comune.compareTo(string) == 0 && sito.corpo_idrico.compareTo(corpoidrico) == 0) {
      resutls.add(sito);
      print("AGGINTO" + sito.comune + " " + sito.descr);
    }
  }
  return resutls;
}


List<Sito> filtra_siti_percorpoidrico(String string) {
  List<Sito> resutls = new List<Sito>();
  for (Sito sito in _siti) {

    if (sito.corpo_idrico.compareTo(string) == 0) {
      resutls.add(sito);
      print("AGGINTO" + sito.corpo_idrico + " " + sito.descr);
    }
  }
  return resutls;
}

bool checkIfFavourite(Sito sito){

  if(_pref.length > 0 ) {
    for (Sito s in _pref) {
      if(s.descr == sito.descr){
        return true;
      }
    }
  }
  return false;

}

//return true if added
//return false id removed

bool _aggiungirimuovipreferiti(Sito sito){

    if(checkIfFavourite(sito)){
      _pref.remove(sito);
      _setPreferiti();
      return false;
    }else {
      _pref.add(sito);
      _setPreferiti();
      return true;
    }

}