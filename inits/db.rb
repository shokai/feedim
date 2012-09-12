Mongoid.logger.level = Logger::WARN

Mongoid.configure do |conf|
  m = Mongo::Connection.new Conf['mongo']['host'], Conf['mongo']['port']
  conf.master = m.db Conf['mongo']['database']
end
