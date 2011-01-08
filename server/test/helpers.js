// helpers
var sys = require('sys')
var log = require("../utils/log")

var port = 4000

exports.disableLog = function() {
    var TestClient = require("../model/TestClient")    
    var App = require("../app")
    
    log.method = function() {}
}

exports.enableLog = function() {
    var TestClient = require("../model/TestClient")    
    var App = require("../app")
    
    log.method = sys.puts
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
    
    var TestClient = require("../model/TestClient")    
    
    exports.app(function(app, port) {
        var client = new TestClient()
        client.connect(port, function() {
            // wait for the welcome message
            client.onMessage(function(route, data) {
                cb(app, client)                
            })
        })        
    })
}

exports.disableLog()