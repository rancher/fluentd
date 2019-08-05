#!/bin/sh

set -o errexit

# remote old Gemfile.lock
rm /Gemfile.lock

# generate new Gemfile.lock
bundle install

cp Gemfile.lock /gems/Gemfile.lock