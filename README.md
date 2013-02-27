Description
===========


Behavior Summary
================

* Creates app users and groups
* Installs rbenv system ruby and bundler after first installing requisite dependencies; ruby version determined by node attribute
* Creates directory structure necessary for app
* installs application dependencies and packages, such as db-client, xml and xslt etc.
* installs passenger gem then builds nginx from source with passenger support
* configures monit to monitor nginx and other critical processes and to use bluepill_service as its service command
* configures runit to supervise monit  


Executional Flow
================

Requirements
============

A Rails application code repository that is configured to manage gem
dependencies via Bundler.

Attributes
==========

* `node["railsapp"]["repository"] ` - Code to deploy (defaults to an
  example Rails 3.1 app)

* `node['railsapp']['deploy_to']`  = the application root THIS MUST BE SET IN THE APPLICATION COOKBOOK AT THIS TIME
 


Usage
=====

```
