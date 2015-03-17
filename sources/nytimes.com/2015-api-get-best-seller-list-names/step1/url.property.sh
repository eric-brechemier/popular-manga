# read URL from meta.txt and replace API Key
apiKey=${apiKey:-}
url=$(
  grep '^URL:' ../meta.txt |
  cut -d' ' -f2 |
  sed "s/\[your-key\]/$apiKey/"
)
echo "URL: $url"

