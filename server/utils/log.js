// use ONLY for server logging, like in/out
var sys = require("sys")

module.exports = function(message) {
    module.exports.method(message)
}

module.exports.method = sys.puts