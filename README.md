appcache
========

Future home of an "appcache" smart package.

- [ ] Files in static/ need to not be cached.
- [ ] Fix not being able to set maxClientAge to 0 in gzippo?
- [ ] server_id in Meteor runtime config
- [ ] have bundler generate list of URLs (since it generates them)
- [ ] verbose server logging of requests for debugging (it's hard to see what is actually happening from the browser)
- [ ] Does disabling event propagation in appcache event stop verbose logging by the browser?
- [ ] Option to enable/disable verbose logging by the browser if so
- [ ] Option to disable app caching for particular browsers
- [ ] Support URL routing: does manifest fallback work for this?
- [ ] Different cache manifests for different URLs? (e.g. cache the images to view one slideshow offline)
- [ ] client-side error logging and reporting that works offline and across page reloads
- [ ] "online" directory for assets too big to be cached
- [ ] Option to specify additional URLs to be cached (e.g. images from another domain such as a CDN)
