module.exports = {
  title: "pimatic-dwd-weather device config schema"
  DwdWeather: {
    title: "DWD Weather"
    description: "DWD Weather Data"
    type: "object"
    extensions: ["xLink", "xAttributeOptions"]
    properties:
      station:
        description: "Name for the weather station"
        enum: [
          "UFS TW Ems, HH",  "UFS Deutsche Bucht, HH",  "Helgoland, SH",  "List/Sylt, SH",  "Schleswig, SH",
          "Leuchtturm Kiel, SH",  "Kiel, SH",  "Fehmarn, SH",  "Arkona, MV",  "Norderney, NI",
          "Leuchtt. Alte Weser, NI",  "Cuxhaven, NI",  "Hamburg-Flh., HH",  "Schwerin, MV",  "Rostock, MV",
          "Greifswald, MV",  "Emden, NI",  "Bremen-Flh., HB",  "Lüchow, NI",  "Marnitz, MV",
          "Waren, MV",  "Neuruppin, BB",  "Angermünde, BB",  "Münster/Osnabr.-Flh., NW",  "Hannover-Flh., NI",
          "Magdeburg, ST",  "Potsdam, BB",  "Berlin-Tegel, BE",  "Berlin-Tempelhof, BE",  "Berlin-Dahlem, BE",
          "Lindenberg, BB",  "Düsseldorf-Flh., NW",  "Essen, NW",  "Kahler Asten, NW",  "Bad Lippspringe, NW",
          "Fritzlar, HE",  "Brocken, ST",  "Leipzig-Flh., SN",  "Dresden-Flh., SN",  "Cottbus, BB",
          "Görlitz, SN",  "Aachen, NW",  "Nürburg, RP",  "Köln/Bonn-Flh., NW",  "Gießen/Wettenberg, HE",
          "Wasserkuppe, HE",  "Meiningen, TH",  "Erfurt, TH",  "Gera, TH",  "Fichtelberg, SN",
          "Trier, RP",  "Hahn-Flh., RP",  "Frankfurt/M-Flh., HE",  "OF-Wetterpark, HE",  "Würzburg, BY",
          "Bamberg, BY",  "Hof, BY",  "Weiden, BY",  "Saarbrücken-Flh., SL",  "Karlsruhe-Rheinst., BW",
          "Mannheim, BW",  "Stuttgart-Flh., BW",  "Öhringen, BW",  "Nürnberg-Flh., BY",  "Regensburg, BY",
          "Straubing, BY",  "Großer Arber, BY",  "Lahr, BW",  "Freudenstadt, BW",  "Stötten, BW",
          "Augsburg, BY",  "München-Flh., BY",  "Fürstenzell, BY",  "Feldberg/Schw., BW",  "Konstanz, BW",
          "Kempten, BY",  "Oberstdorf, BY",  "Zugspitze, BY",  "Hohenpeißenberg, BY"
        ]
      attributes:
        type: "array"
        default: ["temperature"]
        format: "table"
        items:
          enum: [
            "pressure", "temperature", "humidity",
            "precipitation", "windDirection", "windSpeed",
            "windGust", "condition"
          ]
  }
}