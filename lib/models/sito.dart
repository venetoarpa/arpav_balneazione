class Sito {
  final String codsqst;
  final String stato1arp;
  final String statoatt;
  final String data_campione;
  final String numero_campione;
  final String tipo_analisi;
  final String esito_campione;
  final String data_validazione;
  final String descr;
  final String comune;
  final String x_wgs;
  final String y_wgs;
  final String corpo_idrico;

  Sito({this.codsqst,
      this.stato1arp,
      this.statoatt,
      this.data_campione,
      this.numero_campione,
      this.tipo_analisi,
      this.esito_campione,
      this.data_validazione,
      this.descr,
      this.comune,
      this.x_wgs,
      this.y_wgs,
      this.corpo_idrico});

  factory Sito.fromXml(Map<String, dynamic> xml){
      return Sito(
          codsqst: xml['CODSEQST'],
          stato1arp: xml['STATO1APR'] ,
          statoatt:  xml['STATOATT'],
          data_campione:  xml['DATA_CAMPIONE'],
          numero_campione:  xml['NUMERO_CAMPIONE'],
          tipo_analisi:  xml['TIPO_ANALISI'],
          esito_campione:  xml['ESITO_CAMPIONE'],
          data_validazione:  xml['DATA_VALIDAZIONE'],
          descr: xml['DESCR'] ,
          comune: xml['COMUNE'] ,
          x_wgs: xml['X_WGS'] ,
          y_wgs:  xml['Y_WGS'],
          corpo_idrico:  xml['CORPO_IDRICO']
      );
  }

  factory Sito.fromJsonSmall(Map<String, dynamic> xml){
    return Sito(
        codsqst: xml['codsqst'],
        stato1arp: xml['stato1arp'] ,
        statoatt:  xml['statoatt'],
        data_campione:  xml['data_campione'],
        numero_campione:  xml['numero_campione'],
        tipo_analisi:  xml['tipo_analisi'],
        esito_campione:  xml['esito_campione'],
        data_validazione:  xml['data_validazione'],
        descr: xml['descr'] ,
        comune: xml['comune'] ,
        x_wgs: xml['x_wgs'] ,
        y_wgs:  xml['y_wgs'],
        corpo_idrico:  xml['corpo_idrico']
    );
  }


    toJson() {
      return <String, dynamic>{
          "codsqst" : this.codsqst,
          "stato1arp" : this.stato1arp,
          "statoatt" : this.statoatt,
          "data_campione" : this.data_campione,
          "numero_campione" : this.numero_campione,
          "tipo_analisi" : this.tipo_analisi,
          "esito_campione" : this.esito_campione,
          "data_validazione" : this.data_validazione,
          "descr" : this.descr,
          "comune" : this.comune,
          "x_wgs" : this.x_wgs,
          "y_wgs" : this.y_wgs,
          "corpo_idrico" : this.corpo_idrico,
      };
    }


  /*
    <CODSEQST>27000187</CODSEQST>
<STATO1APR>BLU</STATO1APR>
<STATOATT>BLU</STATOATT>
<DATA_CAMPIONE>2018-05-30 11:10:00</DATA_CAMPIONE>
<NUMERO_CAMPIONE>624215</NUMERO_CAMPIONE>
<TIPO_ANALISI>ORDINARIA</TIPO_ANALISI>
<ESITO_CAMPIONE>T</ESITO_CAMPIONE>
<DATA_VALIDAZIONE>2018-06-01 08:02:00</DATA_VALIDAZIONE>
<DESCR>PELLESTRINA - S.VITO </DESCR>
<COMUNE>VENEZIA</COMUNE>
<X_WGS>12.305</X_WGS>
<Y_WGS>45.27167</Y_WGS>
<CORPO_IDRICO>MARE ADRIATICO</CORPO_IDRICO> */
}