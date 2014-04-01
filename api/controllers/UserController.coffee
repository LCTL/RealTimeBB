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

    find: (req, res) ->

        userId = req.param 'id'
        skip = req.param 'skip'
        limit = req.param 'limit'

        if userId 

            promise = UserService.findOneById(userId)

        else 

            promise = UserService.findAll
                skip: skip,
                limit: limit

        promise.then (users) ->

            Utils.promiseTask null, (deferred) ->

                if Utils.isArray(users)

                    async.each users

                    , (user, callback) ->

                        user.setShowEmail true

                        callback null

                    , (err) ->

                        if err then deferred.reject err else deferred.resolve users

                else 

                    user.setShowEmail true

                    deferred.resolve users

        .then (users) ->

            res.json users

        .catch (err) ->

            res.json err 

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

    logout: (req, res) ->

        delete req.session.user

        res.json true

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