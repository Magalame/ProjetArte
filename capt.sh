#!/bin/bash

choix=""

while [ "$choix" != "1" ] && [ "$choix" != "2" ] && [ "$choix" != "3" ] && [ "$choix" != "4" ] && [ "$choix" != "5" ]
do
    #echo "Entrez 'fr' pour télécharger la version française ou 'de' pour la version allemande:"
	echo "---------------------------------------------------"
	echo "Entrez le numéro correspondant à la version que vous voulez télécharger:"
	echo "1 pour la version française"
	echo "2 pour la version allemande"
	echo "3 pour la version espagnole"
	echo "4 pour la version anglaise"
	echo "5 pour la version polonaise"
    read -p "Votre choix:" choix
done


currentdir=$(pwd)

cd /tmp

if [ ! -d "work" ]; then
  mkdir work
fi
cd work
rm -f *
wget -q -O html_page $1



ligne2=$(cat html_page | grep 'https://www.arte.tv/player/v3/' | head -n 1) #cherche la ligne où il y a l'api
LINE=$(echo $ligne2 | tr ' ' '\n' | grep -A 2 "src" | head -n 1  | cut -d '"' -f 2) #extrait l'adresse du player qui contient aussi l'api

test_curl=`curl -Is "$LINE" | head -1 | cut -f 2 -d " "` #test si le player est accessible

if [ "$test_curl" = "200" ];then
	#echo "---------------------------------------------------"
	#echo "Line:" $LINE
	#echo "---------------------------------------------------"
	url_enc=$(echo "$LINE" | cut -f 2 -d "=") #récupère uniquement l'adresse de l'api
	#echo "Url api enc:" $url_enc
	echo "---------------------------------------------------"
	url_dec=$(printf "${url_enc//%/\\x}")	#enlève l'encodage html
	
	if [ "$choix" = "1" ];then
        langue='fr'
	elif [ "$choix" = "2" ];then
	    langue='de'
	elif [ "$choix" = "3" ];then
	    langue='es'
	elif [ "$choix" = "4" ];then
	    langue='en'
	elif [ "$choix" = "5" ];then
	    langue='pl'
	fi
	
    url_dec=$(echo "$url_dec" | python -c "import sys; tmp = sys.stdin.readline().split('/'); tmp[7] = '$langue';print '/'.join(tmp)")
	
	test_langue=`curl -Is "$url_dec" | head -1 | cut -f 2 -d " "`
	
	if [ ! "$test_langue" = "200" ];then
	    echo "La langue demandée ne semble pas disponible, fin du programme"
	fi
	
	echo "Url du fichier de configuration de l'api:" $url_dec
	wget --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" -q -O api_page $url_dec #télécharge l'api
  
else
    echo "Le player semble inaccessible, fin du programme"
	exit
fi


#cat api_page | grep -w -A 7 "HTTP_MP4_SQ_1" | sed 's/"/\n/g' | sed 's/[\]//g' > fichier_frag_2
cat api_page | grep -w -A 7 "HTTPS_SQ_1" | sed 's/"/\n/g' | sed 's/[\]//g' > fichier_frag_2 # télécharge la version en meilleure qualité 

title0=$(echo -en "$(cat api_page | grep "VTI" | cut -d '"' -f 4 | tr -d ':' | tr -d '?')") #le VTI est toujours présent dans le code
title1=$(echo -en "$(cat api_page | grep "subtitle" | cut -d '"' -f 4 | tr -d ':' | tr -d '?')") #mais pas toujours le subtitle

if [ ! -z "$title1" ]; then #si $title1 n'est pas vide, alors on l'utilise
    echo "---------------------------------------------------"
    echo "Nom du programme:" $title0
    echo "---------------------------------------------------"
    echo "Nom du podcast:" $title1
else #sinon, just title 0
    echo "---------------------------------------------------"
    echo "Nom du podcast:" $title0
fi

echo "---------------------------------------------------"
echo "Cherche le lien du fichier de configuration de l'api (veuillez patienter quelques secondes)..."


cat fichier_frag_2 | while read LINE



do
#echo "This is a line:" $LINE
    test_curl=`curl -Is "$LINE" | head -1 | cut -f 2 -d " "` #on vérifie quelle ligne est un lien 

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

#echo "url var:" $url_var
echo "Téléchargement du fichier:"
echo 
echo
echo
#echo "test:$title .mp4"
cd "$currentdir"

if [ ! -z "$title1" ]; then
    wget -O "$title0 - $title1 [Arte].mp4" $url_var
else 
    wget -O "$title0 [Arte].mp4" $url_var
fi