function dogesay -d "Shibe has something to say"
  unbuffer doge | tee /dev/tty | tr -d "▄▀" | sed -e (echo -e 's/\033\[[0-9;]*m//g') | awk 'NF==0{next};{$1=$1};{print $0";"}' | say &
  disown (jobs -lp | tail +1)
end
