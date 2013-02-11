appcache
========

Future home of the appcache smart package, currently under
development.  (Not ready to be used with applications
published to users yet).


About
-----

The application cache is an HTML5 feature which allows the static
resources for a web application (HTML, Javascript, CSS, images)
to be saved in the browser.

* The web page loads faster because the browser doesn't need to contact
  the server first.

* Hot code pushes are loaded by the browser in the background while the
  app continues to run.  Once the new code has been fully loaded the
  browser is able to switch over to the new code quickly.

* The application cache allows the application to be loaded even when
  the browser doesn't have an Internet connection, and so enables using
  the app offline.

(Note however that the app cache by itself doesn't do anything to make
*data* available offline: in an application loaded offline, a Meteor
Collection will appear to be empty in the client until the Internet
becomes available and the browser is able to establish a livedata
connection).


Testing Only
------------

This release is for testing only.

Testers should be comfortable with and know how to manually delete the
app cache in their browser.  It is remarkably easy with an app cache
to get wedged where a configuration error causes the browser to not
refresh the cached app with new code from the server.  You're then
stuck because you can fix things on the server all you want but none
of those fixes get to the client because the browser isn't contacting
the server any more.  (I hope I don't have any more bugs like that left,
but don't count on it yet).

DO NOT USE THIS CODE for users of an app published on a domain if
there is ANY chance that you will EVER want to go back to using Meteor
<= 0.5.4 on that domain.  The currently released version of Meteor
does not return a 404 for the app manifest file, so your users will be
STUCK running your old code out of their app cache even though you
aren't using the appcache package any more.  (A workaround has been
merged into Meteor's devel branch, so this should not be a problem for
Meteor versions >= 0.5.5).


Browser Support
---------------

The app cache is widely supported by browsers
(http://caniuse.com/#feat=offline-apps).  Older browsers will ignore
the manifest attribute and the app will run as a regular online
application.

When an app cache is enabled Firefox will pop up a message "This
website is asking to store data on your computer for offline use" and
will ask the user whether to allow or deny the request.

While many users will understand what this means, some users may
possibly be alarmed by the browser warning, and could choose not to
run the app in preference to enabling something they don't understand.

The goal of the appcache package is to work transparently: you should
be able to add the appcache package without it changing the behavior
of your application in supported browser.  Since this is not possible
on Firefox, the app cache is disabled in Firefox by default.

There are two mechanisms for configuring which browsers you'd like to
enable app cache support for.  You can specify particular browsers to
enable or disable:

````
Meteor.AppCache.config({
  firefox: true,
  IE: false
});
````

this says to enable the app cache for Firefox, to disable it for IE,
and to use the defaults for the other browsers.

You can also give an explicit list of browsers to enable:

````
Meteor.AppCache.config({
  browsers: ['chrome', 'android']
});
````

this enables the app cache for Chrome and Android, and disables it for
all other browsers.

The available browsers and their default enabled/disabled
configuration:

* `android` (enabled)
* `chrome` (enabled)
* `firefox` (disabled)
* `IE` (enabled)
* `mobileSafari` (enabled)
* `opera` (enabled)
* `safari` (enabled)

Note that even if a browser is enabled the app cache may still not be
used: the user may be using an older version of a browser which
doesn't support an app cache, or in Firefox the user can decline the
request to enable offline support.


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
        "tag": "appcache-bundle-9"
      },
      "packages": {
        "appcache": {
          "git": "git://github.com/awwx/meteor-appcache.git",
          "tag": "appcache-12"
        }
      }
    }


Meteor Changes
--------------

* 404 on app.manifest (merged into Meteor devel https://github.com/meteor/meteor/commit/df93f65)
* Detect update available on first stream connection (merged into Meteor devel https://github.com/meteor/meteor/commit/514bf73)
* Don't cache static (merged into Meteor devel https://github.com/meteor/meteor/commit/c208f68)
* [bundler-manifest-2](https://github.com/awwx/meteor/tree/bundler-manifest-2) (PR https://github.com/meteor/meteor/pull/667)
* [routepolicy](https://github.com/awwx/meteor/tree/routepolicy)
* [app-cache-manifest-hook](https://github.com/awwx/meteor/tree/app-cache-manifest-hook) (issue https://github.com/meteor/meteor/issues/670)

Combined in [appcache-bundle-9](https://github.com/awwx/meteor/tree/appcache-bundle-9).


TODO
----

- [ ] Merge PR 667.

- [ ] create PR for routepolicy.

- [ ] create PR for app-cache-manifest-hook.

- [x] Check how the app cache interacts with the accounts system.  (For example,
      do we need to not cache particular URLs used for logging in, etc.?  And if
      so, how should a package declare its requirements?)

- [x] We'll need a version of gzippo that supports a cache control header with max-age
      set to zero (https://github.com/tomgco/gzippo/pull/49).  (What happens with the
      app cache is that browsers actually pay attention to the cache control headers,
      and then the browser doesn't fetch modified resources).

- [x] Check total size of files included in the manifest and warn if
      it is greater than 5MB.

- [x] Meteor hook to allow the appcache package to set the manifest attribute in the
      html element.

- [x] Server-side browser detection so that the developer can choose which
      browsers they want to enable the app cache for.

- [x] Handle browsers that don't support an app cache.

- [x] Files in static/ need to not be cached.

- [x] Fix not being able to set maxClientAge to 0 in gzippo

- [x] server_id in Meteor runtime config.

- [x] Have bundler record list of URLs for us (since it generates them).

- [x] Get files hashes from the bundler instead of calculating them at
      runtime.

- [-] Verbose server logging of requests for debugging.  (It's hard to
      see what is actually happening on the network from the browser
      when an app cache is used).  (Separate diagnostics or testing
      project).

- [x] Does disabling event propagation in appcache event stop verbose
      logging of app cache events by Chrome in the console log?
      Answer: no.

- [-] Option to enable/disable verbose logging by the browser if so.

- [x] Option to disable app caching for particular browsers.

- [x] Support URL routes: does manifest fallback work for this?

- [-] Different cache manifests for different URLs? (e.g. cache the
      images of one slideshow to view offline).  (Will not do:
      decided it is out of scope of the appcache project to use the
      app cache to cache dynamic resources).

- [-] ...Or is there a better way to cache assets conditionally?
      Maybe using client storage somehow instead of the app cache...?

- [-] Client-side error logging and reporting that works offline and
      across page reloads.  (Separate diagnostics or testing project).

- [-] "online-only" directory for assets too big to be cached.
      (Probably better to be storing large assets in e.g. S3 rather
      than creating a giant bundle).

- [-] Option to specify additional URLs to be cached (e.g. images from
      another domain such as a CDN).  (This is now not looking like a
      good idea given the limits browsers have on the size of the app
      cache and how they react poorly to an application going over the
      limit).

- [-] Reactive data source which indicates whether the app is
      currently cached or not.  This could be accomplished by
      inserting Javascript into the head element
      (http://googlecode.blogspot.com/2009/05/gmail-for-mobile-html5-series-part-2.html).
      But I'm not sure what we'd actually use it for.

- [-] Reactive data source which indicates that a code update is
      available.  (That is, a minor code update, since a major code
      update will trigger an automatic reload).  I thought I was going
      to do this by watching the app cache updateready event.  However
      this would mean that the feature of "a minor code update is
      available" would only be available when using the appcache.
      This would be better as a stream feature, so that it would work
      without the appcache as well.

- [x] Investigate "DOM Exception 11".
