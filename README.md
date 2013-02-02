appcache
========

Future home of the appcache smart package.


Testing Only
------------

This release is for testing only.

Testers should be comfortable with and know how to manually delete the
app cache in their browser.  It is remarkably easy with an app cache
to get wedged where a configuration error causes the browser to not
refresh the cached app with new code from the server.  I hope I don't
have any more bugs like that left, but I wouldn't count on it.

DO NOT USE THIS CODE for users of an app published on a domain if
there is ANY chance that you will EVER want to go back to using Meteor
<= 0.5.4 on that domain.  The currently released version of Meteor
does not return a 404 for the app manifest file, so your users will be
STUCK running your old code out of their app cache even though you
aren't using the appcache package any more.  (A workaround has been
merged into Meteor's devel branch, so this should not be a problem for
Meteor versions >= 0.5.5).


Use
---

The appcache package relies on hacks to Meteor; these hacks need
further work before they're ready to be made into pull requests.  The
hacks are based off of and follow Meteor's development branch.

With
[meteorite](http://oortcloud.github.com/meteorite/) use a smart.json
like this:

    {
      "meteor": {
        "git": "git://github.com/awwx/meteor.git",
        "tag": "appcache-bundle-4"
      },
      "packages": {
        "appcache": {
          "git": "git://github.com/awwx/meteor-appcache.git",
          "tag": "appcache-4"
        }
      }
    }

keep the tag numbers in sync: appcache-bundle-4 with appcache-4, etc.


Meteor Changes
--------------

* 404 on app.manifest (merged into Meteor devel https://github.com/meteor/meteor/commit/df93f65)
* Detect update available on first stream connection (merged into Meteor devel https://github.com/meteor/meteor/commit/514bf73)
* [dont-cache-static-2](https://github.com/awwx/meteor/tree/dont-cache-static-2)
* [bundler-record-urls-2](https://github.com/awwx/meteor/tree/bundler-record-urls-2)
* [app-html-include-manifest-1](https://github.com/awwx/meteor/tree/app-html-include-manifest-1)

Combined in [appcache-bundle-4](https://github.com/awwx/meteor/tree/appcache-bundle-4).


TODO
----

- [x] Handle browsers that don't support an app cache.

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
