crypto = require 'crypto';
q = require 'q';

isUserDataAvailable = (data, field) ->
    deferred = q.defer()

    whereClause = {}

    whereClause[field] = data

    User.findOne()
    .where(whereClause)
    .then (user) ->
        if user then deferred.reject false else deferred.resolve true

    return deferred.promise

hashPassword = (password) ->

    crypto.createHash('sha256').update(password).digest('base64')

createUser = (data, callback) ->

    data.password = hashPassword(data.password)

    User.create data, (error, user) ->

        callback error, user

module.exports = 

    _config: {}

    create: (req, res) ->

        data = req.params.all()

        createUser data, (error, user) ->

            if error then res.json error else res.json user

    register: (req, res) ->

        data = req.params.all()

        createUser data, (error, user) ->

            if error

                res.json error

            else

                req.session.user = user
                res.json user

    login: (req, res) ->

        username = req.param('username')
        password = req.param('password')
        hashedPassword = hashPassword(password)

        User.findOne()
        .where
            username: username
            password: hashedPassword
        .then (user) ->
            if user 
                req.session.user = user
            
            res.json user

    current: (req, res) ->

        res.json req.session.user 

    isEmailAvailable: (req, res) ->

        isUserDataAvailable(req.param('id'), 'email')
        .then -> 
            res.json true
        .fail -> 
            res.json false

    isUsernameAvailable: (req, res) ->

        isUserDataAvailable(req.param('id'), 'username')
        .then -> 
            res.json true
        .fail -> 
            res.json false