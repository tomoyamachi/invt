# -*- coding: utf-8 -*-
#http://labs.unoh.net/2007/05/ruby.html
require 'openssl'
class Cipher
  PASS_WORD = "A1Kotoba8Yuuk1"
  def self.encode(targetString)
    targetString = targetString.to_s
    enc = OpenSSL::Cipher::Cipher.new('aes256')
    enc.encrypt
    enc.pkcs5_keyivgen(PASS_WORD)
    ((enc.update(targetString) + enc.final).unpack("H*")).to_s
  rescue
    return ""
  end
  def self.decode(encodedString)
    targetString = targetString.to_s
    dec = OpenSSL::Cipher::Cipher.new('aes256')
    dec.decrypt
    dec.pkcs5_keyivgen(PASS_WORD)
    (dec.update(Array.new([encodedString]).pack("H*")) + dec.final)
  rescue
    return ""
  end

  #他者に操作されるとまずい場合につかいます。
  #idの持ち主にしか公開されないようにします。
  LOCK_WORD = "MoneyMoneyMoney"
  def self.lock(targetString)
    targetString = targetString.to_s
    enc = OpenSSL::Cipher::Cipher.new('aes256')
    enc.encrypt
    enc.pkcs5_keyivgen(LOCK_WORD)
    ((enc.update(targetString) + enc.final).unpack("H*")).to_s
  rescue
    return ""
  end
  def self.unlock(encodedString)
    targetString = targetString.to_s
    dec = OpenSSL::Cipher::Cipher.new('aes256')
    dec.decrypt
    dec.pkcs5_keyivgen(LOCK_WORD)
    (dec.update(Array.new([encodedString]).pack("H*")) + dec.final)
  rescue
    return ""
  end

  def self.to_tiny(int)
    int = int.to_i
    return (30000 + int).to_s(36)
  end
  def self.from_tiny(str)
    if str != nil
      return ((str.to_i(36) -30000))
    else
      return false
    end
  end

end
