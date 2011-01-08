// helpers
var sys = require('sys')

var App = require("../app")
var TestClient = require("./TestClient")
var TestPort = 3333
var sharedApp
var assert = require('assert')
var Timeout = require("../utils/Timeout")
var traffic = require("../utils/traffic")

exports.setup = function(cb) {
    
    function client() {
        sharedApp.resetStateForTesting()
        exports.client(function(client) {
            cb(sharedApp, client)
        })
    }
    
    if (sharedApp) return client()
    
    // sys.puts("Loading App")
    traffic.log = function() {}
    sharedApp = new App()
    sharedApp.start(TestPort, function() {
        client()
    })
}

exports.client = function(cb) {
    var client = new TestClient()
    client.connect(TestPort, function() {
        client.onMessage(function(message) {
            clearTimeout(timeout)                
            assert.equal(message.type, "Welcome", "Didn't receive welcome message first!")
            cb(client)
        })
        
        function waiting() {
            assert.ok(false, "Welcome message time out")
        }
        
        var timeout = setTimeout(waiting, 100)
    })    
    
    // var timeout = new Timeout(150)
    // timeout.start(function() {
    //     client.end()
    // })
}

exports.sendAndMap = function(client, message, cb) {
    var map = {}
    var messages = []
    
    client.send(message)
    
    client.onFault(function(fault) {
        return cb(fault)
    })

    client.onMessage(function(message) {  
        var key = message.type + "." + message.action
        map[key] = message.data
        messages.push(message)
    })
    
    function analyze() {
        cb(null, messages, map)
    }
    
    setTimeout(analyze, 100)    
}


exports.teardown = function(cb) {
    if (sharedApp) sharedApp.close()
    traffic.log = sys.log
}