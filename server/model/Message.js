var Message = module.exports = function(type, action, data) {
    this.type = type
    this.action = action || "default"
    
    if (!data)
        this.data = {}
        
    else if (data.toValue) 
        this.data = data.toValue()
        
    else 
        this.data = data
        
    // remove _id fields
    delete this.data._id   
}

Message.prototype.toString = function() {
    return this.type + " " + this.action + " " + this.data
}