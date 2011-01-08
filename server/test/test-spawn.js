var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")

exports.createPlayer = function (assert) {
	helpers.appAndClient(function(app, client) {
		client.onMessage(function (route, data) {
		    
		    sys.puts("ROUTE " + route + " " + data)

            client.sendRouteData("Player.createPlayer", {})        
            client.onMessage(function (route, data) {           
                assert.ok(route, "Player.createPlayer sent out an undefined message")
                assert.ok(data, "No Data")
                assert.finish()
            })
		})
	})
}




// 
// exports.testing = function(assert) {
//     assert.ok(true, "Failed")
//     assert.finish()
// }
// 
// exports.spawn = function(assert) {
//     // I want to spawn
//     assert.finish()
// }
// 
