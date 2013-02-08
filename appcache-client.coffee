return unless window.applicationCache?

updating_appcache = false
reload_retry = null
appcache_updated = false

Meteor._reload.onMigrate 'appcache', (retry) ->
  return [true] if appcache_updated

  unless updating_appcache
    try
      window.applicationCache.update()
    catch e
      # seeing "INVALID_STATE_ERR: DOM Exception 11" here if app cache disabled
      Meteor._debug e

      # TODO if it is INVALID_STATE_ERR...

      # There's no point in delaying the reload if we can't update the cache.
      return [true]

    updating_appcache = true

  reload_retry = retry

  false

cache_is_now_up_to_date = ->
  return unless updating_appcache
  appcache_updated = true
  reload_retry()

window.applicationCache.addEventListener('updateready', cache_is_now_up_to_date, false)
window.applicationCache.addEventListener('noupdate',    cache_is_now_up_to_date, false)


window.applicationCache.addEventListener(
  'obsolete',
  (->
    # We're running old code and the app cache has been disabled.
    # Reload immediately to get the new non-cached code.
    window.location.reload()
  ),
  false
)
