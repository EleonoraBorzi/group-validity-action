json=$(python3 /app/check_group_validity.py "$1" "$2" "$3" "$4" "$5" "$6")
echo "Helloooooooooooooooooooooooooo"
echo $json

json="${json//'%'/'%25'}"
json="${json//$'\n'/'%0A'}"
json="${json//$'\r'/'%0D'}"

if [ $($json | jq -r '.student_submission') == "true" ]; then exit 1; fi
isItStudent= $json | jq '.student_submission'
echo $isItStudent
