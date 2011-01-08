var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Player = require("../model/Player")

exports.createPlayer = function (assert) {
	helpers.appAndClient(function(app, client) {
        client.send("Players.createPlayer", {})        
        client.onMessage(function (route, data) {           
            assert.ok(route, "Player.createPlayer sent out an undefined message")
            assert.ok(data, "No Data")
            
            assert.ok(data.id, "no player id")
            assert.ok(data.position, "no position")
            assert.ok(data.position.x > -Player.SpawnRadius && data.position.x < Player.SpawnRadius, "Player spawn x was invalid " + data.position.x)
            assert.ok(data.position.y > -Player.SpawnRadius && data.position.y < Player.SpawnRadius, "Player spawn y was invalid " + data.position.y)            
            
            assert.finish()
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
