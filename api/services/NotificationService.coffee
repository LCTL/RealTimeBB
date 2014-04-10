_  = require 'underscore'
_.str = require 'underscore.string'
Utils = require './Utils'

class NotificationService 

    constructor: () ->

        @defaultRoomName = 'public'
        @adminRoomName = 'admin'

    onConnect: (session, socket) ->

        socket.join @defaultRoomName

        @joinSpecialRoom session, socket

    onDisconnect: (session, socket) ->

        socket.leave @defaultRoomName

        if session?.user?.roles and _.contains session.user.roles, 'admin'

            socket.leave @adminRoomName

    joinSpecialRoom: (session, socket) ->

        if session?.user?

            socket.join session.user.id

        if session?.user?.roles and _.contains session.user.roles, 'admin'

            socket.join @adminRoomName

    publishCreate: (modelClass, model, roomName) ->

        @publish modelClass, model, 'create', roomName

    publishUpdate: (modelClass, model, roomName) ->

        @publish modelClass, model, 'update', roomName

    publishDestroy: (modelClass, model, roomName) ->

        @publish modelClass, model, 'destroy', roomName

    publish: (modelClass, models, action, roomName) ->

        roomName = @defaultRoomName if not roomName

        if Utils.isArray models

            sails.io.sockets.in(roomName).emit @createMessageName(modelClass), @createPublishMessage model, action for model in models

        else 

            sails.io.sockets.in(roomName).emit @createMessageName(modelClass), @createPublishMessage models, action

    createMessageName: (modelClass) ->

        _.str.capitalize modelClass.identity

    createPublishMessage: (model, action) ->

        action: action
        data: model.toJSON()

module.exports = new NotificationService()
