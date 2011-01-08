// helpers
var sys = require('sys')

var port = 4000

exports.disableLog = function() {
    var Client = require("../model/Client")    
    var App = require("../app")
    
    Client.puts = App.puts = Client.log = App.log = function() {}    
}

exports.enableLog = function() {
    var Client = require("../model/Client")    
    var App = require("../app")
    
    Client.puts = App.puts = sys.puts
    Client.log = App.log = sys.log
}

exports.app = function(cb) {
    var App = require("../app")
    var app = new App()
    var currentPort = ++port
    app.start(currentPort, function() {
        cb(app, port)
    })
}

exports.appAndClient = function(cb) {
    
    var Client = require("../model/Client")    
    
    exports.app(function(app, port) {
        var client = new Client()
        client.connect(port, function() {
            cb(app, client)
        })        
    })
}

exports.disableLog()