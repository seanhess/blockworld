var assert = require('assert')
var sys = require('sys')
var helpers = require("./helpers")

exports.verifySetup = function(assert) {
    
    helpers.setup(function(app, client) {
        assert.ok(app)
        assert.ok(client)
        helpers.close()
        assert.finish()
    })
}

// exports.one = function(assert) {   exports.verifySetup(assert)    }
// exports.two = function(assert) {   exports.verifySetup(assert)    }
// exports.three = function(assert) {   exports.verifySetup(assert)    }
// exports.four = function(assert) {   exports.verifyBefore(assert)    }
// exports.five = function(assert) {   exports.verifyBefore(assert)    }
// exports.six = function(assert) {   exports.verifyBefore(assert)    }
// exports.seven = function(assert) {   exports.verifyBefore(assert)    }
// exports.eight = function(assert) {   exports.verifyBefore(assert)    }