#!/bin/sh

cd `dirname $0`
bundle exec ruby store.rb
bundle exec ruby publish.rb
