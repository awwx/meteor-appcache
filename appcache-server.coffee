app     = __meteor_bootstrap__.app
bundler = __meteor_bootstrap__.bundler
crypto  = __meteor_bootstrap__.require 'crypto'
fs      = __meteor_bootstrap__.require 'fs'
path    = __meteor_bootstrap__.require 'path'

walk = (basedir, callback, dir = null) ->
  dirpath = if dir? then path.join(basedir, dir) else basedir
  return unless fs.existsSync(dirpath)
  for filename in fs.readdirSync(dirpath)
    relative_filepath = if dir? then path.join(dir, filename) else filename
    if fs.statSync(path.join(dirpath, filename)).isDirectory()
      walk(basedir, callback, relative_filepath)
    else
      callback(relative_filepath)

hashdir = (hash, dir) ->
  return unless fs.existsSync(dir)
  filenames = fs.readdirSync(dir)
  for filename in filenames
    filepath = path.join(dir, filename)
    if fs.statSync(filepath).isDirectory()
      hashdir(hash, filepath)
    else
      hash.update(fs.readFileSync(filepath))
  undefined

app.use (req, res, next) ->

  return next() unless req.url is '/app.manifest'

  # After the browser has downloaded the app files from the server and
  # populated the browser's application cache, the browser will *only*
  # connect to the server and reload the application if the contents
  # of the app manifest file has changed.  This means we need to
  # compute a hash of *everything* that gets delivered to the client
  # during the initial web page load.

  bundle_dir = bundler.bundle_dir

  hash = crypto.createHash('sha1')
  hash.update(JSON.stringify(__meteor_runtime_config__), 'utf8')
  hash.update(fs.readFileSync(path.join(bundle_dir, 'app.html')))

  # We don't need to hash the js and css files because they're already
  # referenced with a URL that includes their hash; but we do need
  # to hash the files that came from public.  Since we don't know
  # which are which, hash them all.
  #
  # But probably it would be better to have the bundler generate the
  # hashes for us -- that would save a lot of load at runtime, as this
  # code gets run on every request for the manifest.

  hashdir(hash, path.join(bundle_dir, 'static'))
  hashdir(hash, path.join(bundle_dir, 'static_cacheable'))

  manifest = "CACHE MANIFEST\n\n"

  manifest += '# ' + hash.digest('hex') + "\n\n"

  manifest += "CACHE:" + "\n"
  manifest += "/" + "\n"
  for url in bundler.app_info.urls
    manifest += url + "\n"
  manifest += "\n"

  ## Might do this if decide to use different URL's to reference
  ## assets depending on whether we're using the app cache or not.
  #
  # for basedir in ['static', 'static_cacheable']
  #   walk path.join(bundle_dir, basedir), (filepath) ->
  #     manifest += "/" + filepath + "\n"
  # manifest += "\n"

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
  # manifest (!).  I think.  Needs more testing to be sure.
  # manifest += "/app.manifest" + "\n"

  manifest += "/sockjs" + "\n"

  # content length needs to be based on bytes
  body = new Buffer(manifest)

  res.setHeader('Content-Type', 'text/cache-manifest')
  res.setHeader('Content-Length', body.length)
  res.end(body)
