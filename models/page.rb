require 'rubygems'
require 'kconv'

class Page
  include Mongoid::Document
  field :url
  field :title
  field :description
  field :source
  field :date_published, :default => nil
  field :created_at, :type => Integer, :default => Time.now.to_i
  field :published_at, :type => Integer
  field :status, :default => 'stored'

  def filtered?
    if Conf['filters']
      Conf["filters"].each do |f|
        if description.toutf8 =~ /#{f}/i or url =~ /#{f}/i
          return true
        end
      end
    end
    if Conf["description_filters"]
      Conf["description_filters"].each do |f|
        if description.toutf8 =~ /#{f}/i
          return true
        end
      end
    end
    if Conf["url_filters"]
      Conf["url_filters"].each do |f|
        if url =~ /#{f}/i
          return true
        end
      end
    end
    return false
  end
end

