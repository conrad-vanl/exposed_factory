#= require "rsvp"
window.ExposedFactory = Ember.Object.extend

  ###
  # Properties
  ###

  isLoaded: false

  # private: factory payload sent to Rails
  #
  # build payloads will have this structure:
  # { label: [ factoryName, arguments ] }
  _factories: {}

  # the Ember application that is being tested
  app: (-> App if App ).property("App")

  # the endpoint of the server that the exposed_factory gem is on 
  #
  # defaults to "apiHost" property on your Ember Application if available, otherwise blank ("")
  apiHost: (->
    if @get("app") and @get("app.apiHost")
      @get("app.apiHost")
    else
      ""
  ).property("App")


  apiPath: "/.exposed-factory"


  ###
  # Public Methods
  ###

  init: ->
    @_super()
    throw "ExposedFactory-Ember depends on Ember" if typeof Ember is 'undefined'
    throw "ExposedFactory-Ember depends on jQuery" if typeof jQuery is 'undefined'
    throw "ExposedFactory-Ember: Can't find an Ember Application to test against" if !@get("app")
    throw "ExposedFactory-Ember: API Host is undefined" if typeof @get("apiHost") is ''


  # add a strategy to the factory 
  #   
  # factoryName   - the name of the factory in Rails
  # label         - what the generated data will be labeled under (in response callback)
  # data          - arguments that will be forwarded to Rails
  add: (factoryName, label, data = {}) ->
    @get("_factories")[label] = [ factoryName.decamelize(), @decamelizeKeys(data) ]


  # build the factory data by sending strategies to Rails
  # returns a promise with the generated data as the argument
  build: () ->
    new RSVP.Promise (resolve, reject) =>
      return reject() if !@get("_factories")

      @set("isLoaded",false) if @get("isLoaded")

      $.ajax(
        type: "POST"
        url: @get("apiHost")+@get("apiPath")+"/build"
        data: JSON.stringify @get("_factories")
        dataType: "json"
        contentType: "application/json"
      )
        .done (a,b) =>
          data = @camelizeKeys(a)
          Ember.run -> resolve(data)
        .fail (a,b) =>
          Ember.run -> reject()
        .always (a,b) =>
          Ember.run => @set("isLoaded", true)

  ###
  # Private Methods
  ###
  
  # decamlizes keys in an object
  decamelizeKeys: (obj) ->
    ret = {}
    for k, v of obj
      v = @decamelizeKeys(v) if typeof v is "object"
      ret[k.decamelize()] = v
    ret

  # camlizes keys in an object
  camelizeKeys: (obj) ->
    ret = {}
    for k, v of obj
      v = @camelizeKeys(v) if typeof v is "object" and v isnt null
      ret[k.camelize()] = v
    ret


