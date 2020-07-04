function domaincert -d "extract domain certificate infro from a given URL"
  echo | openssl s_client -showcerts -servername (domain $argv[1]) -connect (domain $argv[1]):443 2>/dev/null | openssl x509 -inform pem -noout -text
end
