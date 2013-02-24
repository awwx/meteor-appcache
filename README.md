# appcache

Project home of the appcache package.

The code is now in a Meteor branch:
https://github.com/meteor/meteor/tree/appcache

API documentation is available here:
https://github.com/meteor/meteor/blob/appcache/docs/client/packages/appcache.html

Background information about the browser application cache and how
it interacts with Meteor is in the Meteor Wiki:
https://github.com/meteor/meteor/wiki/AppCache


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
