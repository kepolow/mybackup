#!/bin/bash
clear
#string data###
echo "Pilih singa apa aust ? (s/a)";read sss
 if [ $sss == "s" ]; then
server="62/singapore";servers="62"
elif [ $sss == "a" ]; then
server="19/australia";servers="19"
fi
ua="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
cookie="HstCfa3102037=1569872884444; HstCmu3102037=1569872884444; __dtsu=3DD172A78AA0FE5C1E2CB9B702BF9381; PHPSESSID=7l8bp65aalildqfeop9ch73jd4; HstCnv3102037=3; HstCns3102037=3; HstCla3102037=1569983938326; HstPn3102037=6; HstPt3102037=11"
###############
reload=$(curl -s "https://bestvpnssh.com/create-account/vpn/$server" \
-H "User-Agent: $ua" -H "Cookie: $cookie")
csrf=$(echo $reload|awk -F 'csrf' '{print $6}'|awk -F 'value="' '{print $2}'|awk -F '"' '{print $1}')
session=$(echo $reload|awk -F 'sess=' '{print $2}'|awk -F '"' '{print $1}')
curl -s 'https://bestvpnssh.com/plugins/captcha.php?width=100&height=34&characters=5' \
-H "User-Agent: $ua" -H "Cookie: $cookie" > /var/www/html/captcha.jpg
capca=$(tesseract /var/www/html/captcha.jpg stdout)
capca=$(echo $capca|awk -F " " '{print $1}')
user=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w6 | head -n1)
c=$(curl -s "https://bestvpnssh.com/c-user.php?sess=$session" \
-H "User-Agent: $ua" -H "Cookie: $cookie" \
-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
--data "username=$user&password=1&captcha=$capca&type=vpn&server=$servers&csrf=$csrf")
exp=$(echo $c|awk -F 'Expired date:</b> ' '{print $2}'|awk -F '<' '{print $1}')
echo $c;echo
echo "#####################################"
echo $c|awk -F '</strong> ' '{print $2}'|awk -F '<' '{print $1}'
echo "Selesai."
echo "bestvpnssh.com-$user" > pass.txt;echo "1" >> pass.txt
echo "#Expired: $exp" >> pass.txt
echo "Akun VPN terbuat"
