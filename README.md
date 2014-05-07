# RealTimeBB

RealTimeBB is a web forum application build on Node.js. RealTimeBB use websocket to interact with server and client.


### Requirement

1. MongoDB http://www.mongodb.org/downloads
2. Redis (Session store and MQ) http://redis.io/download (Windows version: https://github.com/rgl/redis/downloads)
3. Node.js http://nodejs.org/download/

### How to run

1. Run MongoDB and Redis in local machine (no password)
2. git clone `git@github.com:lawrence0819/RealTimeBB.git`
2. cd RealTimeBB
3. npm install
4. npm install -g sails
5. npm install -g grunt-cli
6. sails lift
7. Open browser and enter `http://localhost:1337`
