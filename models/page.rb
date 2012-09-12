require 'rubygems'
require 'kconv'

class Page
  class Status
    STORED = 1
    PUBLISHED = 2
    FILTERED = 3
  end

  include Mongoid::Document
  field :url
  field :title
  field :description
  field :source
  field :created_at, :type => Time, :default => nil
  field :stored_at, :type => Time, :default => lambda{Time.now.to_i}
  field :published_at, :type => Time, :default => nil
  field :status, :type => Integer, :default => Page::Status::STORED

  validates_uniqueness_of :url
  validates_format_of :url, :with => /^https?:\/\/.+$/

  def self.find_to_publish
    self.where(:status => Page::Status::STORED)
  end

  def filtered?
    filters_desc = [Conf['filters'], Conf['description_filters']].flatten.uniq.reject{|i| i==nil}
    filters_url = [Conf['filters'], Conf['url_filters']].flatten.uniq.reject{|i| i==nil}
    filters_desc.each do |f|
      return true if description.toutf8 =~ /#{f}/i
    end
    filters_url.each do |f|
      return true if url =~ /#{f}/i
    end
    return false
  end

end
