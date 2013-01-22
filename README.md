appcache
========

Future home of an "appcache" smart package.

- [ ] Files in static/ need to not be cached.

- [ ] Fix not being able to set maxClientAge to 0 in gzippo?

- [ ] server_id in Meteor runtime config.

- [ ] Have bundler generate list of URLs (since it generates them).

- [ ] Verbose server logging of requests for debugging.  (It's hard to
      see what is actually happening from the browser).

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

- [ ] "online" directory for assets too big to be cached.

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
