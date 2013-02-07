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


Browser Support
---------------

The app cache enjoys wide browser support (http://caniuse.com/#feat=offline-apps);
even IE 10 includes it now.  Older browsers will simply ignore the manifest
attribute and the app will run as a regular online application.

Chrome has a hard 5MB limit on the size of the app cache.  Sadly if you go
over the limit Chrome doesn't do something sensible like fall back
to treating the app like an online application but instead continues
serve the app out of the stale cache... *and* the error condition is
indistinguishable on the client and server from the client simply not
having an Internet connection at the moment.  So if you want to use
an app cache with Chrome you simply have to be very very careful that
you never ever ever go over the 5MB limit or you're screwed.

Firefox pops up a message "This website is asking to store data on your
computer for offline use" Allow / Never For This Site / Not Now.  Which
may or may not be OK depending on your audience and whether they're
expecting the request or might be freaked out about it.

My plan is to allow the developer to specify which browsers to enable the app
cache for, and make Chrome and Firefox opt-in.


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
        "tag": "appcache-bundle-6"
      },
      "packages": {
        "appcache": {
          "git": "git://github.com/awwx/meteor-appcache.git",
          "tag": "appcache-6"
        }
      }
    }

keep the tag numbers in sync: appcache-bundle-6 with appcache-6, etc.


Meteor Changes
--------------

* 404 on app.manifest (merged into Meteor devel https://github.com/meteor/meteor/commit/df93f65)
* Detect update available on first stream connection (merged into Meteor devel https://github.com/meteor/meteor/commit/514bf73)
* [dont-cache-static-2](https://github.com/awwx/meteor/tree/dont-cache-static-2)
* [bundler-manifest-2](https://github.com/awwx/meteor/tree/bundler-manifest-2)
* [app-html-include-manifest-1](https://github.com/awwx/meteor/tree/app-html-include-manifest-1)

Combined in [appcache-bundle-5](https://github.com/awwx/meteor/tree/appcache-bundle-5).


TODO
----

- [ ] Check how the app cache interacts with the accounts system.  (For example,
      do we need to not cache particular URLs used for logging in, etc.?  And if
      so, how should a package declare its requirements?)

- [ ] We'll need a version of gzippo that supports a cache control header with max-age
      set to zero (https://github.com/tomgco/gzippo/pull/49).  (What happens with the
      app cache is that browsers actually pay attention to the cache control headers,
      and then the browser doesn't fetch modified resources).

- [ ] Check total size of files included in the manifest and warn or disable the
      app cache if Chrome is enabled and the total size > 5MB.

- [ ] Meteor hook to allow the appcache package to set the manifest attribute in the
      html element.

- [ ] Server-side browser detection so that the developer can choose which
      browsers they want to enable the app cache for.

- [x] Handle browsers that don't support an app cache.

- [x] Files in static/ need to not be cached.

- [x] Fix not being able to set maxClientAge to 0 in gzippo

- [x] server_id in Meteor runtime config.

- [x] Have bundler record list of URLs for us (since it generates them).

- [x] Get files hashes from the bundler instead of calculating them at
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
