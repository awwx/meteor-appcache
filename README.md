appcache
========

Future home of the appcache smart package.


Meteor Changes
--------------

* detect-update-avail-on-first-connection
* dont-cache-static
* app-manifest-404
* bundler-record-urls

Combined in appcache-bundle-2


TODO
----

- [ ] Handle browsers that don't support an app cache.  (Current code
      doesn't bother to check for the existence of
      `window.applicationCache` etc).

- [x] Files in static/ need to not be cached.

- [x] Fix not being able to set maxClientAge to 0 in gzippo

- [x] server_id in Meteor runtime config.

- [x] Have bundler record list of URLs for us (since it generates them).

- [ ] Get files hashes from the bundler instead of calculating them at
      runtime.

- [ ] Verbose server logging of requests for debugging.  (It's hard to
      see what is actually happening on the network from the browser
      when an app cache is used).

- [ ] Does disabling event propagation in appcache event stop verbose
      logging by the browser in the console log?

- [ ] Option to enable/disable verbose logging by the browser if so.

- [ ] Option to disable app caching for particular browsers.

- [ ] Support URL routes: does manifest fallback work for this?

- [ ] Different cache manifests for different URLs? (e.g. cache the
      images of one slideshow to view offline).

- [ ] ...Or is there a better way to cache assets conditionally?
      Maybe using client storage somehow instead of the app cache...?
      Especially for Chrome which has a 5mb app cache limit.

- [ ] Client-side error logging and reporting that works offline and
      across page reloads.

- [ ] "online-only" directory for assets too big to be cached.

- [ ] Option to specify additional URLs to be cached (e.g. images from
      another domain such as a CDN).

- [ ] Reactive data source which indicates whether the app is
      currently cached or not. (An app may not be cached because this
      is the first visit and the cache is loading, the browser doesn't
      support it, the programmer specified that the app cache should
      not be used for particular browsers, the user declined to allow
      offline use in Firefox, app caching is disabled for the domain
      in the browser settings, etc).

- [ ] Reactive data source which indicates that a code update is
      available.  (That is, a minor code update, since a major code
      update will trigger an automatic reload).
