// helpers
var sys = require('sys')

var App = require("../app")
var TestClient = require("./TestClient")
var TestPort = 3333
var sharedApp
var assert = require('assert')
var traffic = require("../utils/traffic")

exports.simple = function(cb) {

    var app = new App()
    var timer = app.timer()
    
    app.resetStateForTesting()
    
    var socket = {
        broadcast: function() {}
    }
    
    app.socket(socket)

    var client = {
        send: function() {},
        broadcast: function() {}
    }

    cb(app, client, socket, timer)

}

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
            client.onMessage(function() {})
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

exports.gather = function(client, cb) {
    var messages = []
        
    client.onFault(function(fault) {
        clearTimeout(timeout)
        return cb(new Error(fault.fault + " " +fault.message))
    })

    client.onMessage(function(message) {  
        messages.push(message)
    })
    
    function later() {
        cb(null, messages)
    }
    
    var timeout = setTimeout(later, 100)
}

exports.messages


exports.teardown = function(cb) {
    if (sharedApp) sharedApp.close()
    traffic.log = sys.log
}