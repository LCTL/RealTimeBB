_  = require 'underscore'
_.str = require 'underscore.string'
Utils = require './Utils'

class NotificationService 

    constructor: () ->

        @defaultRoomName = 'commons'

    onConnect: (session, socket) ->

        socket.join @defaultRoomName

    onDisconnect: (session, socket) ->

        socket.leave @defaultRoomName

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
