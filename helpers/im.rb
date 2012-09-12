
class IM

  def self.send(msg)
    ImKayac.post(Conf['im']['to'], msg, auth(msg))
  end

  private
  def self.auth(msg)
    case Conf['im']['auth_type']
    when 'sig'
      require 'digest/sha1'
      sig = Digest::SHA1.hexdigest(msg + Conf['im']['auth'])
      {:sig => sig}
    when 'password'
      {:password => Conf['im']['auth']}
    else
      nil
    end
  end

end
