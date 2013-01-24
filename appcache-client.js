// Generated by CoffeeScript 1.4.0
(function() {
  var appcache_updated, cache_is_now_up_to_date, reload_retry, updating_appcache;

  if (window.applicationCache == null) {
    return;
  }

  updating_appcache = false;

  reload_retry = null;

  appcache_updated = false;

  Meteor._reload.onMigrate('appcache', function(retry) {
    if (appcache_updated) {
      return [true];
    }
    if (!updating_appcache) {
      window.applicationCache.update();
      updating_appcache = true;
    }
    reload_retry = retry;
    return false;
  });

  cache_is_now_up_to_date = function() {
    if (!updating_appcache) {
      return;
    }
    appcache_updated = true;
    return reload_retry();
  };

  window.applicationCache.addEventListener('updateready', cache_is_now_up_to_date, false);

  window.applicationCache.addEventListener('noupdate', cache_is_now_up_to_date, false);

  window.applicationCache.addEventListener('obsolete', (function() {
    return window.location.reload();
  }), false);

}).call(this);
