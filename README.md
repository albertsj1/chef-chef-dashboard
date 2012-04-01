chef-dashboard: Install the chef-dashboard application
--------------------------------------------------------------------------------

This installs and configures chef-client enabled machines to point at the [chef
dashboard](http://github.com/erikh/chef-dashboard). Please see that repository
for more information on how it works.

Metadata Information
--------------------------------------------------------------------------------

* `dashboard/repository`: URI pointing at the chef-dashboard repository. (default [here](https://github.com/erikh/chef-dashboard.git))
* `dashboard/revision`: revision to use (default HEAD)
* `dashboard/host`: host to install on / report to (see below, default `server.local`)

This recipe uses my [unicorn2](https://github.com/erikh/chef-unicorn2) cookbook
and configures a default application in `/www/chef-dashboard`.

Recipe Information
--------------------------------------------------------------------------------

There are two recipes:

* `chef-dashboard::default` installs the services required for a chef dashboard.
* `chef-dashboard::dashboard_hook` installs the chef-dashboard report and exception handlers.

Both leverage the `dashboard/host` metadata key in different ways. `::default`
uses it to specify the hostname of the vhost, and `::dashboard_hook` uses it to
figure out where to report to (critical when you have some machines behind
firewalls and others not, but want to report to the same place).

Contributing
--------------------------------------------------------------------------------

* Fork the project
* Make your edits
* Be sure to not change anything in metadata.rb without prior permission.
* Send a pull request.

Author
--------------------------------------------------------------------------------

Erik Hollensbe <erik+chef@hollensbe.org>
