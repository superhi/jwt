require 'jwt'

def multi_gets(all_text='')
  until (text = gets) == "-----END PRIVATE KEY-----\n"
    all_text << text
  end
  return (all_text + "-----END PRIVATE KEY-----").chomp # you can remove the chomp if you'd like
end

puts "Key ID?"
keyId = gets.chomp

puts "Team ID?"
teamId = gets.chomp

puts "Private key contents?"
private_key = multi_gets

hours_to_live = 
time_now = Time.now.to_i
time_expired = Time.now.to_i + 2 * 365 * 60 * 60

algorithm = 'ES256'

headers = {
  'typ': 'JWT',
	'alg': algorithm,
	'kid': keyId
}

payload = {
	'iss': teamId,
	'exp': time_expired,
	'iat': time_now
}


ecdsa_key = OpenSSL::PKey::EC.new private_key
ecdsa_key.check_key

token = JWT.encode payload, ecdsa_key, algorithm, header_fields=headers

puts "Okay, your private key is here..."

puts token

IO.popen('pbcopy', 'w') { |f| f << token }