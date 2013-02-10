return unless window.applicationCache?

appCacheStatuses = [
  'uncached',
  'idle',
  'checking',
  'downloading',
  'updateready',
  'obsolete'
]

console.log appCacheStatuses[window.applicationCache.status]

updating_appcache = false
reload_retry = null
appcache_updated = false

Meteor._reload.onMigrate 'appcache', (retry) ->
  return [true] if appcache_updated

  # An uncached application (one that does not have a manifest) cannot
  # be updated.
  if window.applicationCache.status is window.applicationCache.UNCACHED
    return [true]

  unless updating_appcache
    try
      window.applicationCache.update()
    catch e
      Meteor._debug 'applicationCache update error', e
      # There's no point in delaying the reload if we can't update the cache.
      return [true]
    updating_appcache = true

  reload_retry = retry
  return false

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
