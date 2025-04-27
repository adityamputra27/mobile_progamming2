class BMKGDataGempa {
  static const String autoGempaURL =
      "https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json";

  static const String gempaTerkiniURL =
      "https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json";

  static const String gempaDirasakanURL =
      "https://data.bmkg.go.id/DataMKG/TEWS/gempadirasakan.json";

  static String getGambarGempa(String kodeShakeMap) {
    return "https://data.bmkg.go.id/DataMKG/TEWS/$kodeShakeMap";
  }
}
