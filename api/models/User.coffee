crypto = require 'crypto'

toGravatarHash = (email) ->

    hash = crypto.createHash 'md5'
    hash.update email.toLowerCase().trim()
    hash.digest 'hex'

module.exports = 

    schema: true

    attributes: 

        email:
            type: 'email'
            required: true
            maxLength: 200
            minLength: 5
            unique: true

        username: 
            type: 'string'
            required: true
            maxLength: 50
            minLength: 5
            regex: /^[A-Za-z0-9_]+$/
            unique: true

        password:
            type: 'string'
            required: true
            maxLength: 100

        isAdmin:
            type: 'boolean'
            defaultsTo: false
            required: true

        toJSON: () ->

            obj = @toObject()

            obj.gravatar = toGravatarHash(obj.email)

            delete obj.password
            delete obj.email

            return obj