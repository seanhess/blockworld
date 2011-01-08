var Message = module.exports = function(type, action, data) {
    this.type = type
    this.action = action || "default"
    this.data = data || {}
    
    if (!data)
        this.data = null
        
    else if (data.toValue) 
        this.data = data.toValue()
        
    else 
        this.data = data
}

Message.prototype.toString = function() {
    return this.type + " " + this.action + " " + this.data
}