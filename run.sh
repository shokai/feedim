#!/bin/sh

cd `dirname $0`
bundle exec ruby bin/store.rb
bundle exec ruby bin/publish.rb
