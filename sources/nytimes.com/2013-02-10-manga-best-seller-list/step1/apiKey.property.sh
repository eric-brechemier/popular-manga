# read API key from config
apiConfigFile='../../../../config/nytimes.txt'
if test ! -f "$apiConfigFile"
then
  echo "Configuration file not found: $apiConfigFile"
  exit 1
fi
apiKey=$(grep '^Key:' "$apiConfigFile" | cut -d' ' -f2)
