# appcache

Project home of the appcache package.

The code is now in a Meteor branch:
https://github.com/meteor/meteor/tree/appcache

API documentation is available in the pre-release documentation:
http://devel-docs.meteor.com/#appcache

Background information about the browser application cache and how
it interacts with Meteor is in the Meteor Wiki:
https://github.com/meteor/meteor/wiki/AppCache


## Broken at the moment

The appcache package is currently unusable at the moment due to a
problem with interacting caches:

* if you use a resource without a "cache busting" URL (such as
  `<img src="/image.jpg">`), changing the resource on the server
  won't cause the resource to be reloaded in the browser,

* but if you do use a cache busting URL ("/image.jpg?a492b3..."), that
  version of the URL isn't being cached by the app cache.


## Use

You can use the appcache package either by running `meteor` directly
or by using
[Meteorite](http://oortcloud.github.com/meteorite/).

### Using Meteor

If you normally run Meteor with the `meteor` command, you can run
Meteor directly from a git checkout of the `appcache` branch.

This example puts the checkout in your home directory (but you can put
it anywhere):

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

You may find it convenient to create a symbolic link in your PATH so
that you don't need to type `~/meteor-appcache/meteor` all the time.
If `~/bin` is on your PATH:

````
$ cd ~/bin
$ ln -s ~/meteor-appcache/meteor m
````

where `m` is whatever abbreviation you'd like to use to refer to the
appcache version of Meteor.

````
$ cd ~/myapp
$ m add appcache
$ m
````

### Using Meteorite

If you use Meteorite, specify the Meteor `appcache` branch in your
`smart.json` file:

````
{
  "meteor": {
    "git": "https://github.com/meteor/meteor.git",
    "branch": "appcache"
  },
  "packages": {}
}
````

Note that because `appcache` is a core package, it should not be
listed in the smart.json `packages` section.

Now you can add the `appcache` package and run your application:

````
$ mrt add appcache
$ mrt
````


## Deploy

Because there are no dev_bundle changes in the `appcache` branch, you
can deploy applications using the `appcache` package to *.meteor.com
even though the released version of Meteor doesn't include the package
yet.  Simply use the standard `meteor deploy` command.


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
