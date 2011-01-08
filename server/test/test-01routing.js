var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var Message = require("../model/Message")
var App = require("../App")

exports.closesWithClientAndDelay = function(assert) {
    helpers.setup(function(app, client) {
        function later() {
            assert.ok(client)
            assert.finish()     
        }
        
        setTimeout(later, 100)
    })
}

exports.faults = function(assert) {   
    helpers.setup(function(app, client) {
                        
        client.sendRaw("random crap")
                
        client.onFault(function(fault) {
            assert.equal(fault.fault, Fault.JsonParsingError)
                                        
            client.sendRaw('{"something":"else"}') 
            client.onFault(function(fault) {
                assert.equal(fault.fault, Fault.InvalidType)
                
                client.send(new Message("thisshouldnotmatch", "okj", {}))
                client.onFault(function(fault) {
                    assert.equal(fault.fault, Fault.InvalidType)
                    
                    client.send(new Message("test", "fake", null))
                    client.onFault(function(fault) {
                        assert.equal(fault.fault, Fault.InvalidMethod)
                        
                        client.send(new Message("test","throwSomething", {}))
                        client.onFault(function(fault) {
                            assert.equal(fault.fault, Fault.ControllerFault)
                            assert.finish()                    
                        })
                    })
                })
            })
        })        
    })
}

exports.route = function(assert) {   
    helpers.setup(function(app, client) {
        client.send(new Message("test", "something"))
        client.onFault(function(fault) {
            assert.ok(false, "Shouldn't have received a fault for test.something - " + fault)
        })
        
        client.onMessage(function(message) {
            assert.ok(message, "Found Message!")
        })
        
        function finish() {
            assert.finish()
        }
        
        setTimeout(finish, 200)
    })
}