function favicongrabber -a domain
  if test (count $argv) = 0
    echo "Missing required argument: domain"
    return 1
  end

  set -l domain (domain $domain)
  set -l url http://favicongrabber.com/api/grab/$domain

  echo "requesting $url"
  set -l response (curl -fsSL "$url")
  set -l error (echo $response | jq -r '.error // ""')
  test -n "$error"; and begin
    echo $error
    return 1
  end

  echo $response | jq -r '.icons[].src' | while read -l url
    echo "downloading $url"
    curl -fsSLO "$url"
  end
end
