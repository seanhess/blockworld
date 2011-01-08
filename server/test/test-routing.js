var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")

exports.openclose = function(assert) {
    helpers.appAndClient(function(app, client) {
        assert.ok(app)
        assert.ok(client)
        app.close()
        assert.finish()
    })
}

exports.faults = function(assert) {   
    helpers.appAndClient(function(app, client) {
        
        client.sendRaw("random crap")
        
        client.onFault(function(type, message) {
            assert.equal(type, Fault.JsonParsingError)
            app.close()
            assert.finish()
        })        
    })
}



// exports.faults(assert)