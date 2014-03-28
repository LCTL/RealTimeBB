module.exports = 

    schema: true

    attributes: 

        threadId: 
            type: 'string'
            index: true
            required: true

        userId:
            type: 'string'
            index: true
            required: true

        content:
            type: 'string'
            required: true
            maxLength: 5000