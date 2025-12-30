read -z | sed -e 's/{ /{\n/g' -e 's/; /;\n/g' | awk 'BEGIN {LEVEL=0}; /}/ {LEVEL-=1}; { indent = sprintf("%*s", LEVEL, ""); gsub(".", "\t", indent); print indent $0 }; /{/ {LEVEL+=1}'
