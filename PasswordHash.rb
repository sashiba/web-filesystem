require 'securerandom'
require 'openssl'
require 'base64'

module PasswordHash

  PBKDF2_ITERATIONS = 1000
  SALT_BYTE_SIZE = 24
  HASH_BYTE_SIZE = 24

  HASH_SECTIONS = 4
  SECTION_DELIMITER = ':'
  ITERATIONS_INDEX = 1
  SALT_INDEX = 2
  HASH_INDEX = 3

  # securerandom.base64 - salt_byte_size e parametyr koito opredelq duljinata i wrushta 4/3 po-dylyg ot salt_byte_size niz, koito e random i towa e solta
  # pkcs5 - dawa kriptirana parola : parolata (wuwedenata), solta, iterations-pozwolqwa
  #da se promenq duljinata koqto shte se zaeme ot izchislenieto,kolkoto po-golqm mu e broq,
  #tolko poweche wreme she otneme
  #hash_byte_size -e duljinata na kritpiranata parola w baitowe
  def self.createHash( password )
    salt = SecureRandom.base64( SALT_BYTE_SIZE )
    pbkdf2 = OpenSSL::PKCS5::pbkdf2_hmac_sha1( 
      password,
      salt,
      PBKDF2_ITERATIONS, 
      HASH_BYTE_SIZE
    )
    return ["sha1", PBKDF2_ITERATIONS, salt, Base64.encode64( pbkdf2 )].join( SECTION_DELIMITER )
  end
  #base64 encode kriptira parolata, pbkdf2 e string sled izpulnenieto na pbkdf2_hmac_sha1
#returna prawi finalniq niz, koito shte e kriptiranata parola, syshtoi se ot sha1,broq iteracii,
#solta i kriptirane na predishniq niz, kato gi swurzwa s :

 
  #prowerka dali parolata suotwetstwa na hasha, kato correctHash e takuw suzdaden or predniq def
  #1wo go razdelqme - protiwopolojnoto na returna gore
  #false ako e s poweche parametura ot 4
  #dekodirame posledniq element w params koito e kriptiranata parola ot Openssl
  #prawim testhash koito se prawi tochno kakto edna parola, s parametrite na tekushtiq hash
  # i ako sa ednakwi znachi suwpadat i e prawilna parolata
  def self.validatePassword( password, correctHash )
    params = correctHash.split( SECTION_DELIMITER )
    return false if params.length != HASH_SECTIONS

    pbkdf2 = Base64.decode64( params[HASH_INDEX] )
    testHash = OpenSSL::PKCS5::pbkdf2_hmac_sha1(
      password,
      params[SALT_INDEX],
      params[ITERATIONS_INDEX].to_i,
      pbkdf2.length
    )
    
    return pbkdf2 == testHash
  end
end