argparse i/invert -- $argv

set -l casing (test (string length -- "$_flag_invert") -gt 0; echo $status)

set content "$argv[1..-1]"
# use stdin if no args were given
string match -qa "" "$content"; and read content

string split '' "$content" | while read char
    # passthrough non-alpha characters
    string match -qr "[[:alpha:]]" $char; or begin
        echo $char
        continue
    end

    # transform alpha
    switch "$casing"
        case 0
            string lower $char
        case 1
            string upper $char
        case "" "*"
            echo "unknown casing state" >/dev/stderr
            return 1
    end

    # set the casing for the next character
    set casing (math bitand 1, $casing+1)
end | string join ''
