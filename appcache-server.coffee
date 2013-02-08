app       = __meteor_bootstrap__.app
bundle    = __meteor_bootstrap__.bundle
crypto    = __meteor_bootstrap__.require 'crypto'
fs        = __meteor_bootstrap__.require 'fs'
path      = __meteor_bootstrap__.require 'path'
useragent = __meteor_bootstrap__.require 'useragent'

knownBrowsers =
  ['android', 'chrome', 'firefox', 'IE', 'mobileSafari', 'opera', 'safari']

browsersEnabledByDefault =
  ['android', 'IE', 'mobileSafari', 'opera', 'safari']

enabledBrowsers = {}
enabledBrowsers[browser] = true for browser in browsersEnabledByDefault

useragentFamilyToBrowser =
  'Android':       'android'
  'Chrome':        'chrome'
  'Firefox':       'firefox'
  'IE':            'IE'
  'Mobile Safari': 'mobileSafari'
  'Opera':         'opera'
  'Safari':        'safari'

Meteor.AppCache =
  config: (options) ->
    for option, value of options
      if option is 'browsers'
        enabledBrowsers = {}
        for browser in value
          enabledBrowsers[browser] = true
      else if option in knownBrowsers
        enabledBrowsers[option] = value
      else
        throw new Error('Unknown AppCache config option: ' + option)
    undefined

reqToBrowser = (req) ->
  useragentFamilyToBrowser[useragent.lookup(req.headers['user-agent']).family]

browserEnabled = (req) ->
  enabledBrowsers[reqToBrowser(req)]

Meteor._app_cache_manifest_hook = (req) ->
  if browserEnabled(req)
    'manifest="/app.manifest"'
  else
    ''

app.use (req, res, next) ->

  return next() unless req.url is '/app.manifest'

  # Browsers can get confused if we unconditionally serve the
  # manifest.  If the app cache had previously been enabled for a
  # browser, it will continue to fetch the manifest as long as it's
  # available, even if we now are not including the manifest attribute
  # in the app HTML.  (Firefox for example will continue to display
  # "this website is asking to store data on your computer for offline
  # use").  Returning a 404 gets the browser to really turn off the
  # app cache.

  unless browserEnabled(req)
    res.writeHead(404)
    res.end()
    return

  # After the browser has downloaded the app files from the server and
  # has populated the browser's application cache, the browser will
  # *only* connect to the server and reload the application if the
  # *contents* of the app manifest file has changed.
  #
  # So we have to ensure that if any static client resources change,
  # something changes in the manifest file.  We compute a hash of
  # everything that gets delivered to the client during the initial
  # web page load, and include that hash as a comment in the app
  # manifest.  That way if anything changes, the comment changes, and
  # the browser will reload resources.

  hash = crypto.createHash('sha1')
  hash.update(JSON.stringify(__meteor_runtime_config__), 'utf8')
  hash.update(fs.readFileSync(path.join(bundle.root, 'app.html')))
  for resource in bundle.manifest
    if resource.where is 'client'
      hash.update(resource.hash)
  digest = hash.digest('hex')

  manifest = "CACHE MANIFEST\n\n"

  manifest += '# ' + digest + "\n\n"

  manifest += "CACHE:" + "\n"
  manifest += "/" + "\n"
  for resource in bundle.manifest
    if resource.where is 'client'
      manifest += resource.url + "\n"
  manifest += "\n"

  ## Idea: can we support running the app on arbitrary URL's even
  ## when using the app cache?
  ## (e.g. https://github.com/tmeasday/meteor-router)
  ## Needs more experimentation.
  #
  # manifest += "FALLBACK:\n"
  # manifest += "/ /" + "\n\n"

  manifest += "NETWORK:\n"
  # Never ever cache the manifest, or the app will never ever reload.
  # Needed because otherwise the fallback on / will cache the
  # manifest?  Maybe.  Needs more testing to be sure.
  # manifest += "/app.manifest" + "\n"

  manifest += "/sockjs" + "\n"

  # content length needs to be based on bytes
  body = new Buffer(manifest)

  res.setHeader('Content-Type', 'text/cache-manifest')
  res.setHeader('Content-Length', body.length)
  res.end(body)
