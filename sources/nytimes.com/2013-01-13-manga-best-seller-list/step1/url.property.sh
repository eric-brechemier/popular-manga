# read URL from meta.txt and replace API Key
url=$(
  grep '^URL:' ../meta.txt |
  cut -d' ' -f2 |
  sed "s/\[your-key\]/$apiKey/"
)
