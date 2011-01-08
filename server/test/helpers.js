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
        var client = new TestClient()
        sharedApp.resetStateForTesting()
        
        client.connect(TestPort, function() {
            client.onMessage(function(message) {
                clearTimeout(timeout)                
                assert.equal(message.type, "Welcome", "Didn't receive welcome message first!")
                cb(sharedApp, client)
            })
            
            function waiting() {
                assert.ok(false, "Welcome message time out")
            }
            
            var timeout = setTimeout(waiting, 100)
        })    
        
        var timeout = new Timeout()
        timeout.start(function() {
            client.end()
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


exports.teardown = function(cb) {
    if (sharedApp) sharedApp.close()
    traffic.log = sys.log
}