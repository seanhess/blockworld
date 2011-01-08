var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Player = require("../model/Player")
var Message = require("../model/Message")
var _ = require("underscore")

exports.playerCreate = function (assert) {
    helpers.setup(function(app, client) {
        
        var nickname = "fake-test-nickname"
        helpers.sendAndCollect(client, new Message("player", "create", {nickname:nickname}), function(err, messages, map) {
            assert.ifError(err)
            
            assert.ok(_(messages).any(function(message) {
                return message.type == 'player' && message.action == 'you'
            }), "didn't receive player.you")
        

            assert.ok(_(messages).any(function(message) {
                return message.type == 'player' && message.action == 'added'
            }), "didn't receive player.added")

            helpers.sendAndCollect(client, new Message("player", "create", {nickname:nickname + "2"}), function(err, messages, map) {
                assert.equal(messages.length, 3, "Didn't get all the messages")
                assert.finish()
            })
        })
    })
}


// exports.playerMove = function (assert) {
//     helpers.setup(function(app, client) {
//         
//         var nickname = "fake-test-nickname"
//         helpers.sendAndCollect(client, new Message("player", "create", {nickname:nickname}), function(err, messages, map) {
//             assert.ifError(err)
//             assert.finish()
//         })
//     })
// }





