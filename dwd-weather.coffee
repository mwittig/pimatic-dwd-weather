# DWD Weather plugin
module.exports = (env) ->

  events = require 'events'
  Promise = env.require 'bluebird'
  types = env.require('decl-api').types
  _ = env.require 'lodash'
  commons = require('pimatic-plugin-commons')(env)
  rp = require 'request-promise'
  cheerio = require 'cheerio'

  # ###DwdWeatherPlugin class
  class DwdWeatherPlugin extends env.plugins.Plugin
    init: (app, @framework, @config) =>
      @debug = @config.debug || false
      @interval = 60000 * Math.max @config.__proto__.interval, @config.interval
      @base = commons.base @, 'Plugin'
      @url = 'http://www.dwd.de/DE/leistungen/beobachtung/beobachtung.html'
      # register devices
      deviceConfigDef = require("./device-config-schema")
      @base.debug "Registering device class DwdWeather"
      @framework.deviceManager.registerDeviceClass("DwdWeather", {
        configDef: deviceConfigDef.DwdWeather,
        createCallback: (config, lastState) =>
          return new DwdWeather(config, @, lastState)
      })

    getData: () ->
      options =
        uri: @url
        transform: (body) ->
          cheerio.load(body)

      new Promise (resolve, reject) =>
        rp(options)
        .then ($) ->
          data = {}
          columns = []
          $('table thead tr').children().not(":first-child").each ()->
            columns.push $(@).text().trim()

          $('table tbody').children().each ->
            if @name  is 'tr'
              values = []
              $(@).children().not(":first-child").each ->
                arg = $(@).text().trim()
                if arg.match(/^-+$/)?
                  arg=''
                else
                  num = parseFloat(arg)
                  if (! isNaN(num))
                    arg = num
                values.push arg

              result = {}
              _.each(columns, (key, index) -> result[key] = values[index])
              data[$(@).children().first().text().trim()] = result

          resolve data
        .catch reject

    requestUpdate: () ->
      @base.debug "#{@listenerCount 'weatherUpdate'} event listeners"
      if @__timeoutObject? and @lastWeatherData?
        @emit 'weatherUpdate', @lastWeatherData
      else
        @base.cancelUpdate()
        @base.debug "Requesting weather data update"
        @getData().then (@lastWeatherData) =>
          @emit 'weatherUpdate', @lastWeatherData
        .catch (error) =>
          @base.error "Error:", error
        .finally () =>
          unless @listenerCount 'weatherUpdate' is 0
            @base.scheduleUpdate(@requestUpdate, @interval)
          else
            @base debug "No more listeners for status updates. Stopping update cycle"

  class AttributeContainer extends events.EventEmitter
    constructor: () ->
      @values = {}

  class DwdWeather extends env.devices.Device
    attributeTemplates =
      condition:
        description: "Wetterzustand"
        type: types.string
        acronym: 'ZUSTAND'
      temperature:
        description: "Temperatur"
        type: types.number
        unit: '°C'
        acronym: 'T'
      humidity:
        description: "Relative Luftfeuchtigkeit"
        type: types.number
        unit: '%'
        acronym: 'RH'
      pressure:
        description: "Luftdruck"
        type: types.number
        unit: 'mbar'
        acronym: 'P'
      precipitation:
        description: "Niederschlagsmenge"
        type: types.number
        unit: 'mm'
        acronym: 'PPT'
      windDirection:
        description: "Windrichtung"
        type: types.string
        acronym: 'WD'
      windSpeed:
        description: "Windgeschwindigkeit"
        type: types.number
        unit: 'km/h'
        acronym: 'WS'
      windGust:
        description: "Höchste Windspitze w.d. letzten Stunde"
        type: types.number
        unit: 'km/h'
        acronym: 'GST'


    constructor: (@config, @plugin, lastState) ->
      @id = @config.id
      @name = @config.name
      @debug = @plugin.debug || false
      @base = commons.base @, @config.class
      if @config.station?
        @station = /[^,]*/.exec(@config.station)[0]
      @attributeValues = new AttributeContainer()
      @attributes = _.cloneDeep(@attributes)
      @attributeHash = {}
      for attributeName in @config.attributes
        do (attributeName) =>
          if attributeTemplates.hasOwnProperty attributeName
            @attributeHash[attributeName] = true
            properties = attributeTemplates[attributeName]
            @attributes[attributeName] =
              description: properties.description
              type: properties.type
              unit: properties.unit if properties.unit?
              acronym: properties.acronym if properties.acronym?

            defaultValue = null # if properties.type is types.number then 0.0 else '-'
            @attributeValues.values[attributeName] = lastState?[attributeName]?.value or defaultValue

            @attributeValues.on attributeName, ((value) =>
              @base.debug "Received update for attribute #{attributeName}: #{value}"
              if value?
                @attributeValues.values[attributeName] = value
                @emit attributeName, value
            )

            @_createGetter(attributeName, =>
              return Promise.resolve @attributeValues.values[attributeName]
            )
          else
            @base.error "Configuration Error. No such attribute: #{attributeName} - skipping."
      @resetStatsHandler = (device) =>
        if device.id is @id
          @base.debug "Device has changed - resetting stats"
          @attributeValues.values = {}
          for attributeName in @config.attributes
            @emit attributeName, null
      @plugin.framework.once 'deviceChanged', @resetStatsHandler
      super()
      if @station?
        process.nextTick () =>
          @weatherUpdateHandler = @createWeatherUpdateHandler()
          @plugin.on 'weatherUpdate', @weatherUpdateHandler
          @plugin.requestUpdate()

    destroy: () ->
      @plugin.removeListener 'weatherUpdate', @weatherUpdateHandler
      super

    createWeatherUpdateHandler: () ->
      return (weatherData) =>
        @base.debug JSON.stringify weatherData
        if weatherData.hasOwnProperty @station
          data = weatherData[@station]
          if @attributeHash.pressure? and _.isNumber data['LUFTD.']
            @attributeValues.emit "pressure", parseFloat data['LUFTD.']
          if @attributeHash.temperature? and _.isNumber data['TEMP.']
            @attributeValues.emit "temperature", parseFloat data['TEMP.']
          if @attributeHash.humidity? and _.isNumber data['U%']
            @attributeValues.emit "humidity", parseFloat data['U%']
          if @attributeHash.precipitation?
            @attributeValues.emit "precipitation", parseFloat data['RR30'] if _.isNumber data['RR30']
          if @attributeHash.windDirection?
            @attributeValues.emit "windDirection", if _.isEmpty data['DD'] then '-' else data['DD']
          if @attributeHash.windSpeed? and _.isNumber data['FF']
            @attributeValues.emit "windSpeed", parseFloat data['FF']
          if @attributeHash.windGust? and _.isNumber data['FX']
            @attributeValues.emit "windGust", parseFloat data['FX']
          if @attributeHash.condition? and not _.isEmpty data['Wetter+Wolken']
            @attributeValues.emit "condition", data['Wetter+Wolken']
        else
          @base.error "No weather data found for station #{@station}" unless stationData?
          @plugin.removeListener 'weatherUpdate', @weatherUpdateHandler

  # ###Finally
  # Create a instance of my plugin
  # and return it to the framework.
  return new DwdWeatherPlugin
