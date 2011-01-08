var assert = require('assert')
var sys = require('sys')


exports.openclose = function(assert) {
    var app = require("../app")
    app.start(function() {
        sys.puts("Started")
        app.close()        
        assert.finish()
    })
}