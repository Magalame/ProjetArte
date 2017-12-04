#!/bin/bash

if [ ! -d "work" ]; then
  mkdir work
fi
cd work
rm -f *
wget -q -O html_page $1



ligne2=$(cat html_page | grep 'https://www.arte.tv/player/v3/' | head -n 1) #cherche la ligne où il y a l'api
LINE=$(echo $ligne2 | tr ' ' '\n' | grep -A 2 "src" | head -n 1  | cut -d '"' -f 2) #extrait l'adresse du player qui contient aussi l'api

test_curl=`curl -Is "$LINE" | head -1 | cut -f 2 -d " "` #test si le player est accessible

choix=""

while [ "$choix" != "fr" ] && [ "$choix" != "de" ]
do
    #echo "Entrez 'fr' pour télécharger la version française ou 'de' pour la version allemande:"
    read -p "Entrez 'fr' pour télécharger la version française ou 'de' pour la version allemande:" choix
done



if [ "$test_curl" = "200" ];then
	#echo "---------------------------------------------------"
	#echo "Line:" $LINE
	echo "---------------------------------------------------"
	url_enc=$(echo "$LINE" | cut -f 2 -d "=") #récupère uniquement l'adresse de l'api
	echo "Url api enc:" $url_enc
	echo "---------------------------------------------------"
	url_dec=$(printf "${url_enc//%/\\x}")	#enlève l'encodage html
	
	if [ "$choix" = "fr" ];then
	    #echo "Français choisi"
        url_dec=$(echo "$url_dec" | python -c "import sys; tmp = sys.stdin.readline().split('/'); tmp[7] = 'fr';print '/'.join(tmp)")
	fi
	
	if [ "$choix" = "de" ];then
	    #echo "Allemand choisi"
        url_dec=$(echo "$url_dec" | python -c "import sys; tmp = sys.stdin.readline().split('/'); tmp[7] = 'de';print '/'.join(tmp)")
	fi 
	
	echo "Url api dec:" $url_dec
	wget -q -O api_page $url_dec #télécharge l'api
	
else
    echo "Probleme avec l'url, fin du programme"
	exit
fi


#cat api_page | grep -w -A 7 "HTTP_MP4_SQ_1" | sed 's/"/\n/g' | sed 's/[\]//g' > fichier_frag_2
cat api_page | grep -w -A 7 "HTTPS_SQ_1" | sed 's/"/\n/g' | sed 's/[\]//g' > fichier_frag_2 # télécharge la version française 

title1=$(echo -en "$(cat api_page | grep "VTI" | cut -d '"' -f 4 | tr -d ':' | tr -d '?')")
title0=$(echo -en "$(cat api_page | grep "subtitle" | cut -d '"' -f 4 | tr -d ':' | tr -d '?')")

if [ -z "$subtitle" ]; then
    echo "---------------------------------------------------"
    echo "Nom du programme:" $title0
    echo "---------------------------------------------------"
    echo "Nom du podcast:" $title1
else 
    echo "---------------------------------------------------"
    echo "Nom du podcast:" $title0
fi



cat fichier_frag_2 | while read LINE



do
#echo "This is a line:" $LINE
    test_curl=`curl -Is "$LINE" | head -1 | cut -f 2 -d " "`

#echo "Test line:" $test_curl

    if [ "$test_curl" = "200" ];then
            echo "---------------------------------------------------"
            echo "Lien du fichier:" $LINE
	        echo $LINE>url
            echo "---------------------------------------------------"
            break
    fi

done

url=$(cat url)

cd ../
rm -R work

url_frag=(${url//*:\/\// })
url_var=${url_frag[0]}

echo "url var:" $url_var

echo "test:$title .mp4"

if [ -z "$subtitle" ]; then
    wget -O "$title0 - $title1 .mp4" $url_var
else 
    wget -O "$title1 .mp4" $url_var
fi

