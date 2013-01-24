return unless window.applicationCache?

updating_appcache = false
reload_retry = null
appcache_updated = false

Meteor._reload.onMigrate 'appcache', (retry) ->
  return [true] if appcache_updated

  unless updating_appcache
    window.applicationCache.update()
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
    window.location.reload()
  ),
  false
)
