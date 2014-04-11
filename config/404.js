/**
 * Default 404 (Not Found) handler
 *
 * If no route matches are found for a request, Sails will respond using this handler.
 * 
 * This middleware can also be invoked manually from a controller or policy:
 * Usage: res.notFound()
 */

var async = require('async');
var _ = require('underscore');
_.str = require('underscore.string');
var extensionsToIgnore = [
  '.js',
  '.css',
  '.xml',
  '.less',
  '.png',
  '.jpg',
  '.jpeg',
  '.gif',
  '.pdf',
  '.doc',
  '.txt',
  '.ico',
  '.rss',
  '.zip',
  '.mp3',
  '.rar',
  '.exe',
  '.wmv',
  '.doc',
  '.avi',
  '.ppt',
  '.mpg',
  '.mpeg',
  '.tif',
  '.wav',
  '.mov',
  '.psd',
  '.ai',
  '.xls',
  '.mp4',
  '.m4a',
  '.swf',
  '.dat',
  '.dmg',
  '.iso',
  '.flv',
  '.m4v',
  '.torrent'
];

module.exports[404] = function pageNotFound(req, res) {

  /*
   * NOTE: This function is Sails middleware-- that means that not only do `req` and `res`
   * work just like their Express equivalents to handle HTTP requests, they also simulate
   * the same interface for receiving socket messages.
   */

  var viewFilePath = 'main';
  var statusCode = 404;
  var result = {
    status: statusCode
  };

  var browserRequest = !req.isAjax && !req.isSocket

  if (!browserRequest){
    // If the user-agent wants a JSON response, send json
    if (req.wantsJSON) {
      return res.json(result, result.status);
    }

    res.status(result.status);
  }
  
  res.render(viewFilePath, function (err) {
    // If the view doesn't exist, or an error occured, send json
    if (!browserRequest && err) { return res.json(result, result.status); }

    async.some(extensionsToIgnore, function(extension, callback){

      callback(_.str.endsWith(req.path, extension));

    }, function (exist) {

      if (exist){
        res.send(statusCode);
      } else {
        // Otherwise, serve the `views/main.*` page
        res.render(viewFilePath);
      }
    });
    
  });

};