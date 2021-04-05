json=$(python3 /app/check_group_validity.py "$1" "$2" "$3" "$4" "$5" "$6")
echo "Helloooooooooooooooooooooooooo"
echo $json

json="${json//'%'/'%25'}"
json="${json//$'\n'/'%0A'}"
json="${json//$'\r'/'%0D'}"

echo $json >> output.json

if [[ $(cat output.json | jq ".student_submission") == "\"true\"" ]]
then 
  if [[ $(cat output.json | jq ".ids_match") == "\"false\"" ]]
  then
    exit 1
  fi
fi

if [[ $(cat output.json | jq ".student_submission") == "\"true\"" ]]
then 
  if [[ $(cat output.json | jq ".valid_group") == "\"false\"" ]]
  then
    exit 1
  fi
fi

