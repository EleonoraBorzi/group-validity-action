json=$(python3 /app/check_group_validity.py "$1" "$2" "$3" "$4" "$5" "$6")
echo "Helloooooooooooooooooooooooooo"
echo $json

json="${json//'%'/'%25'}"
json="${json//$'\n'/'%0A'}"
json="${json//$'\r'/'%0D'}"

echo $json | jq -r ".student_submission" | echo
echo $json | jq ".student_submission" | echo
echo $json | jq ".report" | echo
echo $json >> test.json
cat test.json | jq "."
cat test.json | jq ".report"
cat test.json | jq ".student_submission"
echo "----------------------"
echo {"ett":"1a", "two":"2nd"}
echo '{"ett":"1a", "two":"2nd"}'
echo '{"ett":"1a", "two":"2nd"}' | jq ".ett"
echo {"ett":"1a", "two":"2nd"} | jq ".ett"

echo$(jq -r '.student_submission' <<< "$githubjson")

if [[ $(jq -r '.student_submission' <<< "$githubjson" | echo) == "true" ]]; then echo "sant"; exit 1; else echo "falskt"; fi

