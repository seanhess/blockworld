var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")

exports.openclose = function(assert) {
    helpers.app(function(app) {
        assert.ok(app)
        app.close()
        assert.finish()
    })
}

exports.second = function(assert) {
    helpers.app(function(app) {
        app.close()
        assert.finish()
    })
}

exports.closesWithClientAndDelay = function(assert) {
    helpers.appAndClient(function(app, client) {
        function later() {
            assert.ok(client)
            app.close()
            assert.finish()         
        }
        
        setTimeout(later, 300)
    })
}

exports.faults = function(assert) {   
    helpers.appAndClient(function(app, client) {
                        
        client.sendRaw(App.OpenDelimiter + "random crap" + App.CloseDelimiter)
                
        client.onFault(function(type, message) {
            assert.equal(type, Fault.JsonParsingError)
                        
            client.sendRaw("{'something':'else'}")                        
            client.onFault(function(type, message) {
                assert.equal(type, Fault.MissingDelimiters)
                
                client.sendRaw(App.OpenDelimiter + '{"something":"else"}' + App.CloseDelimiter) 
                client.onFault(function(type, message) {
                    assert.equal(type, Fault.MissingRoute)
                    
                    client.send("thisshouldnotmatch", null)
                    client.onFault(function(type, message) {
                        assert.equal(type, Fault.InvalidRoute)
                        
                        client.send("test.something", null)
                        client.onFault(function(type, message) {
                            assert.equal(type, Fault.InvalidData)

                            client.send("test.shouldnotexist", null)
                            client.onFault(function(type, message) {
                                assert.equal(type, Fault.InvalidMethod)
                                
                                client.send("test.throwSomething", {})
                                client.onFault(function(type, message) {
                                    assert.equal(type, Fault.BadController)
                                
                                
                                    app.close()
                                    assert.finish()                    
                                })
                            })
                        })
                    })
                })
                
            })
            
        })        
    })
}

exports.route = function(assert) {   
    helpers.appAndClient(function(app, client) {
        client.send("test.something", {})
        client.onFault(function(type, message) {
            assert.ok(false, "Shouldn't have received a fault for test.something - " + type + " MESSAGE " + message)
        })
        
        
        function finish() {
            assert.finish()
        }
        
        setTimeout(finish, 200)
    })
}