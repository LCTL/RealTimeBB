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

                    users.setShowEmail true

                    deferred.resolve users

        .then (users) ->

            res.json users

        .catch (err) ->

            res.json err 

    create: (req, res) ->

        data = req.params.all()

        createUser data, (err, user) ->

            if err 

                res.json err 

            else 

                user.setShowEmail true
                res.json user
                UserService.publishCreate user, NotificationService.adminRoomName

                user.setShowEmail false
                UserService.publishCreate user

    update: (req, res) ->

        userId = req.param 'id'

        User.update id: userId, req.params.all()

        , (err, users) ->

            if err

                res.json err 

            else if users

                user = _.first users

                user.setShowEmail true
                res.json user
                UserService.publishUpdate user, NotificationService.adminRoomName

                user.setShowEmail false
                UserService.publishUpdate user

    destroy: (req, res) ->

        userId = req.param 'id'

        UserService.findOneById(userId)

        .then (user) ->

            if user

                user.destroy (err) ->

                    if err

                        res.json err 

                    else 

                        UserService.destroyUserSession user, (err) ->

                            UserService.publishDestroy user

                            if err then res.json err else res.json user

            else

                res.json
                    status: 500
                    message: "User not found"

    register: (req, res) ->

        data = req.params.all()
        data.sessionId = Utils.findSessionId req

        createUser data, (error, user) ->

            if error

                res.json error

            else

                req.session.user = user
                res.json user

                UserService.publishCreate user

    login: (req, res) ->

        username = req.param('username')
        password = req.param('password')
        hashedPassword = hashPassword(password)

        User.findOne().where

            username: username
            password: hashedPassword

        .then (user) ->

            if user 

                user.sessionId = Utils.findSessionId req

                user.save (err) ->

                    if err

                        res.json 
                            status: 500
                            error: err

                    else

                        req.session.user = user

                        if req.isSocket

                            NotificationService.joinSpecialRoom req.session, req.socket

                        res.json user

            else

                res.json
                    status: 500
                    message: "Incorrect username or password"

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