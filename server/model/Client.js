// Already started

function Client() {
    
    var stream = new net.Stream()
    
    this.start = function(cb) {
        stream.connect(app.port)
        stream.on('connect', function() {
            cb()
        })
    }
    
    this.onError = function(cb) {
        stream.on('error', cb)
    }
    
    this.close = function() {
        stream.close()
    }
    
    this.send = function(route, data) {
        var payload = JSON.stringify({route:route, data:data})
        stream.write(payload, "utf8")
    }
    
    this.onMessage = function(cb) {
        stream.on('data', function(data) {
            var message = JSON.parse(data)
            cb(message.route, message.data)
        })
    }
}

module.exports = Client