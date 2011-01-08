var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")

exports.createPlayer = function (assert) {
	helpers.appAndClient(function(app, client) {
		client.sendRaw(App.OpenDelimiter + "{'route':'Players.create', 'data':{}}" + App.CloseDelimiter)
		assert.finish()
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
