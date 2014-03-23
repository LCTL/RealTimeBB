pkg = require '../../package.json'
basePublicPath = '.tmp/public/'
baseAssetsPath = basePublicPath + "assets/#{pkg.version}/"
jsBaseAssetsPath = baseAssetsPath + 'js/'
styleBaseAssetsPath = baseAssetsPath + 'styles/'
jsVendorBaseAssetsPath = jsBaseAssetsPath + 'vendor/'
styleVendorBaseAssetsPath = styleBaseAssetsPath + 'vendor/'
imageBaseAssetsPath = baseAssetsPath + 'images/'
templateBaseAssetsPath = baseAssetsPath + 'templates/'
fontBaseAssetsPath = baseAssetsPath + 'fonts/'
productionJsPath = jsBaseAssetsPath + 'production.js'
productionStylePath = styleBaseAssetsPath + 'production.css'

clientAssetsPath = "/assets/#{pkg.version}/"
clientJsAssetsPath = clientAssetsPath + "js/"
clientStyleAssetsPath = clientAssetsPath + "style/"
clientTemplateAssetsPath = clientAssetsPath + "templates/"

module.exports = 
  BASE_PUBLIC_PATH: basePublicPath
  BASE_ASSETS_PATH: baseAssetsPath
  JS_BASE_ASSETS_PATH: jsBaseAssetsPath
  STYLE_BASE_ASSETS_PATH: styleBaseAssetsPath
  JS_VENDOR_BASE_ASSETS_PATH: jsVendorBaseAssetsPath
  STYLE_VENDOR_BASE_ASSETS_PATH: styleVendorBaseAssetsPath
  IMAGE_BASE_ASSETS_PATH: imageBaseAssetsPath
  TEMPLATE_BASE_ASSETS_PATH: templateBaseAssetsPath
  FONT_BASE_ASSETS_PATH: fontBaseAssetsPath
  PRODUCTION_JS_PATH: productionJsPath
  PRODUCTION_STYLE_PATH: productionStylePath,

  CLIENT_ASSETS_PATH: clientAssetsPath
  CLIENT_JS_ASSETS_PATH: clientJsAssetsPath
  CLIENT_STYLE_ASSETS_PATH: clientStyleAssetsPath
  CLIENT_TEMPLATE_ASSETS_PATH: clientTemplateAssetsPath

  jsAssets: (path) ->

    clientJsAssetsPath + path

  styleAssets: (path) ->

    clientStyleAssetsPath + path

  templateAssets: (path) ->

    clientTemplateAssetsPath + path