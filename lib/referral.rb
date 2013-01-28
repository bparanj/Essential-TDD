class Referral
  
  def self.code
    rand(999999999999999).to_s(32).rjust(10,'0')
  end
end