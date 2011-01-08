// helpers
var sys = require('sys')

var port = 4000

exports.disableLog = function() {    
    // log.method = function() {}
}

exports.enableLog = function() {
    // log.method = sys.puts
}

exports.app = function(cb) {
    var App = require("../app")
    var app = new App()
    var currentPort = ++port
    // app.timeout()
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

// exports.disableLog()