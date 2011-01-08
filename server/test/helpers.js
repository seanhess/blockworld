// helpers
var sys = require('sys')

var port = 4000

exports.disableLog = function() {
    var TestClient = require("../model/TestClient")    
    var App = require("../app")
    
    TestClient.puts = App.puts = TestClient.log = App.log = function() {}    
}

exports.enableLog = function() {
    var TestClient = require("../model/TestClient")    
    var App = require("../app")
    
    TestClient.puts = App.puts = sys.puts
    TestClient.log = App.log = sys.log
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
            cb(app, client)
        })        
    })
}

exports.disableLog()