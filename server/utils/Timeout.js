// Allows you to have something happen once all actions have stopped

var Timeout = module.exports = function(delay) {
    
    delay = delay || 100

    var interval = null
    var callback = null

    this.ping = function() {
        if (interval) timeout()
    }
    
    this.start = function(cb) {
        callback = cb
        timeout()
    }
    
    function timeout() {
        clearTimeout(interval)
        
        function onTimeout() {
            clearTimeout(interval)
            interval = null
            callback()
        }
        
        interval = setTimeout(onTimeout, delay)
    }    
}