require 'rubygems'
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

  def filtered?(conf)
    if conf["filters"]
      conf["filters"].each{|f|
        if description.toutf8 =~ /#{f}/i or url =~ /#{f}/i
          return true
        end
      }
    end
    if conf["description_filters"]
      conf["description_filters"].each{|f|
        if description.toutf8 =~ /#{f}/i
          return true
        end
      }
    end
    if conf["url_filters"]
      conf["url_filters"].each{|f|
        if url =~ /#{f}/i
          return true
        end
      }
    end
    return false
  end
end

