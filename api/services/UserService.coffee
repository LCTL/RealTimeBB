BaseModelService = require './BaseModelService'
Utils = require './Utils'

class UserService extends BaseModelService

    constructor: () ->

        super User

    destroyUserSession: (user, asyncCallback) ->

        Utils.promiseTask asyncCallback, (deferred) ->

            if not user.sessionId

                deferred.resolve()

            sessionStore = sails.config.session.store

            sessionStore.get user.sessionId, (err, session) ->

                if err

                    deferred.reject err

                else if not session or not session?.user

                    deferred.resolve()

                else if session?.user

                    session.user = null

                    sessionStore.set user.sessionId, session, (err) ->

                        if err

                            deferred.reject err

                        else

                            deferred.resolve()

module.exports = new UserService()