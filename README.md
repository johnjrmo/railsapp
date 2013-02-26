Description
===========

A collection of [Heavy Water Software Inc's](http://hw-ops.com)
evolving opinions on best practises for configuring and integrating a
Rails application.

Behavior Summary
================

* Creates app users and groups
* Installs rbenv system ruby and bundler after first installing requisite dependencies; ruby version determined by node attribute
* Creates directory structure necessary for app
* installs application dependencies and packages, such as db-client, xml and xslt etc.
* installs passenger gem then builds nginx from source with passenger support
* configures bluepill to manage nginx processes and configures nginx to run detached
* configures monit to monitor nginx and other critical processes and to use bluepill_service as its service command
* configures runit to supervise monit  


Executional Flow
================

*	default recipe is no-op to allow for non-executing inclushion
* 

Requirements
============

A Rails application code repository that is configured to manage gem
dependencies via Bundler.

Attributes
==========

* `node["app"]["repository"] ` - Code to deploy (defaults to an
  example Rails 3.1 app)


Usage
=====

Include "recipe[app::deploy]" in a run list to install an example
Rails 3.1 application backed by a SQLite3 database.

If you're cloning a private repository add a deploy key at
app/files/default/deploy_key_id_rsa

A more practical case might be to create an "app" role:

```ruby
name "app"
description "My Rails app"

run_list [ "role[base]",
           "recipe[postgresql::server]",
           "recipe[app::deploy]" ]

default_attributes( "app" => {
                      "repository" => "git@github.com:me/myapp.git",
                      "use_deploy_key" => true },
                    "db" => {
                      "adapter" => "postgresql" } )
```
