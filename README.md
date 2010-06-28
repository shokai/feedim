feedim
======

feeds to IM. (using im.kayac.com)


Dependencies
============

* TokyoCabinet
* Twitter


Setup
=====

git clone

    % git clone git://github.com/shokai/feedim.git


Install Dependencies
--------------------

    # Mac OS X
    % sudo port install tokyocabinet
  
    # Install gems
    % bundle install


Config
------

    % cp sample.config.yaml config.yaml

then edit it.

    im : "test" # im-kayac user name

    feeds : # list of feeds
    - "http://search.twitter.com/search.atom?q=shokai"
    - "http://pcod.no-ip.org/yats/search?query=shokai&lang=ja&rss"

    filters :  # filter by regex
    - "_shokai"
    - "shokai_"
    - "\-shokai"
    - "shokai\-"
    - "shokai\.co"
    - "shokai\d"
    - "\dshokai"

Run
===

    % ruby feedim.rb

Author
======

* shokai