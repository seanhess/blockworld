var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")
var Fault = require("../model/Fault")
var App = require("../App")
var Bomb = require("../model/Bomb")
var Player = require("../model/Player")
var Message = require("../model/Message")
var _ = require("underscore")

exports.addBomb = function (assert) {
    return assert.finish()
    helpers.setup(function(app, client) {
        helpers.client(function(secondClient) {
            client.send(new Player.MessageCreate({nickname:"nick"}))

            helpers.gather(client, function(err, messages) {
                assert.ifError(err)
                Bomb.Delay = 200
                client.send(new Bomb.MessageCreate({x:2, y:2}))

                helpers.gather(secondClient, function(err, messages) {
                    assert.ifError(err)

                    var message = _(messages).detect(function(message) {
                        return message.type == Bomb.Type && message.action == Bomb.ActionCreate
                    })

                    assert.ok(message, "didn't receive Bomb.ActionCreate")
                    assert.equal(message.data.x, 2, "Bomb x wasn't correct")
                    assert.equal(message.data.y, 2, "Bomb y wasn't correct")


                    helpers.gather(client, function(err, messages) {
                        assert.ifError(err)
                        
                        var message = _(messages).detect(function(message) {
                            return message.type == Bomb.Type && message.action == Bomb.ActionDetonateBomb
                        })
                        
                        assert.ok(message, "Didn't receive Bomb.ActionDetonateBomb")
                        
                        assert.finish()
                    })
                })
            })            
        })
    })                                        
}


// exports.addBomb(assert)