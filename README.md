# pimatic-dwd-weather

[![Greenkeeper badge](https://badges.greenkeeper.io/mwittig/pimatic-dwd-weather.svg)](https://greenkeeper.io/)
[![Npm Version](https://badge.fury.io/js/pimatic-dwd-weather.svg)](http://badge.fury.io/js/pimatic-dwd-weather)
[![Build Status](https://travis-ci.org/mwittig/pimatic-dwd-weather.svg?branch=master)](https://travis-ci.org/mwittig/pimatic-dwd-weather)

Pimatic plugin for DWD weather data.

## Introduction

This plugin provides basic weather data from the German Weather Service for about 40 stations 
throughout the country. The following data is provided whereas some stations may provide a limited data set:

* air temperature at ground-level
* weather condition(clouds and precipitation)
* relative humidity
* barometric pressure
* wind speed, gust and direction

## Contributions

Contributions to the project are  welcome. You can simply fork the project and create a pull request with 
your contribution to start with. If you like this plugin, please consider &#x2605; starring 
[the project on github](https://github.com/mwittig/pimatic-dwd-weather).

## Plugin Configuration

    {
          "plugin": "dwd-weather",
          "debug": false,
    }

The plugin has the following configuration properties:

| Property          | Default  | Type    | Description                                 |
|:------------------|:---------|:--------|:--------------------------------------------|
| debug             | false    | Boolean | Debug mode. Writes debug messages to the pimatic log, if set to true |
| interval          | 10       | Number  | The time interval in minutes (minimum 10) at which the weather data will be queried |


## Device Configuration

The DWD Weather device is provided to obtain weather data for a single location. 

    {
          "id": "dwd-1",
          "name": "Wasserkuppe",
          "class": "DwdWeather",
          "attributes": [
            "temperature",
            "humidity",
            "pressure",
            "precipitation",
            "windDirection",
            "windSpeed",
            "windGust"
          ],
          "station": "Wasserkuppe, HE"
    }

The location is defined by setting the station name which may be one of the following: 

```
"UFS TW Ems, HH",  "UFS Deutsche Bucht, HH",  "Helgoland, SH",  "List/Sylt, SH",  "Schleswig, SH",
"Leuchtturm Kiel, SH",  "Kiel, SH",  "Fehmarn, SH",  "Arkona, MV",  "Norderney, NI                                                                             )",
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
```

The device has the following configuration properties:

| Property          | Default  | Type    | Description                                 |
|:------------------|:---------|:--------|:--------------------------------------------|
| station           | -        | String  | The name of the weather station             |
| attributes        | "temperature" | Enum | The attribute to be exhibited by the device |

Since pimatic version 0.9, devices can be easily created and edited using the device editor as shown 
in the following example.

![Screenshot](https://raw.githubusercontent.com/mwittig/pimatic-dwd-weather/master/assets/screenshots/edit-dwd-weather.png)

## License

Copyright (c) 2015-2017, Marcus Wittig and contributors. All rights reserved.

[AGPL-3.0](https://github.com/mwittig/pimatic-johnny-five/blob/master/LICENSE)


