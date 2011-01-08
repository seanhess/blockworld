// helpers

exports.appAndClient = function(cb) {
    var app = require("../app")
    var Client = require("../model/Client")
    app.start(function() {
        var client = new Client()
        client.connect(function() {
            cb(app, client)
        })
    })
}