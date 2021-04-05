json=$(python3 /app/check_group_validity.py "$1" "$2" "$3" "$4" "$5" "$6")
echo "Helloooooooooooooooooooooooooo"
echo $json

json="${json//'%'/'%25'}"
json="${json//$'\n'/'%0A'}"
json="${json//$'\r'/'%0D'}"

echo $json | jq -r ".student_submission"
echo $json | jq ".student_submission"
echo $json | jq ".report"
echo $json >> output.json
cat output.json | jq "."
cat output.json | jq ".report"
cat output.json | jq ".student_submission"
echo "----------------------"
echo {"ett":"1a", "two":"2nd"}
echo '{"ett":"1a", "two":"2nd"}'
echo '{"ett":"1a", "two":"2nd"}' | jq ".ett"
echo {"ett":"1a", "two":"2nd"} | jq ".ett"

echo $(cat output.json | jq '.student_submission')
echo $(cat output.json | jq ".student_submission")

if [[ $(cat output.json | jq ".student_submission") == "true" ]]; then echo "sant1"; exit 1; else echo "falskt1"; fi
if [[ $(cat output.json | jq ".student_submission") == true ]]; then echo "sant2"; exit 1; else echo "falskt2"; fi
if [ $(cat output.json | jq ".student_submission") = "true" ]; then echo "sant3"; exit 1; else echo "falskt3"; fi

if [[ $(echo "true" | echo) == "true" ]]; then echo "sant4"; exit 1; else echo "falskt4"; fi
if [[ $(echo "true") == "true" ]]; then echo "sant5"; exit 1; else echo "falskt5"; fi
if [[ "true" == "true" ]]; then echo "sant6"; exit 1; else echo "falskt6"; fi
temp=$(cat output.json | jq '.student_submission')
echo $temp
if [[ $temp == "true" ]]; then echo "sant7"; exit 1; else echo "falskt7"; fi
