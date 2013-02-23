Project home of the appcache package.

The code is now in a Meteor branch:
https://github.com/meteor/meteor/tree/appcache

Documentation is available here:
https://github.com/meteor/meteor/blob/appcache/docs/client/packages/appcache.html
and in the Meteor Wiki:
https://github.com/meteor/meteor/wiki/AppCache


## Try

### From a Meteor checkout

Checking out the appcache branch looks like this (this puts the checkout in
your home directory, but you can put it anywhere):

````
$ cd
$ git clone git://github.com/meteor/meteor.git meteor-appcache
$ cd meteor-appcache
$ git checkout appcache
````

You can now run Meteor directly from the checkout:

````
$ cd ~/myapp
$ ~/meteor-appcache/meteor add appcache
$ ~/meteor-appcache/meteor
````


## Thank you

This project was made possible by the financial support of [Meteor
Development
Group](http://meteor.com/).

[Jonathan Kingston](https://github.com/jonathanKingston) took the
[first stab](https://github.com/meteor/meteor/pull/20)
at creating an app cache manifest.

[Nick Martin](https://github.com/n1mmy),
[Geoff Schmidt](https://github.com/gschmidt),
and
[Morten N.O. Nørgaard Henriksen](https://github.com/raix)
contributed design input, code review, and bug reports.

Thank you everyone!
