English follows

*Annonce: il est fort probable que si le script a été téléchargé avant le 7 décembre qu'il ne fonctionne plus, il semble qu'Arte a modifié les règles d'accès à son api. Les dernières versions règlent le problème.*

# ProjetArte

## Téléchargement

Tapez dans le terminal:

`wget https://raw.githubusercontent.com/Magalame/ProjetArte/master/capt.sh`

Ensuite il faut le rendre exécutable:

`chmod +x capt.sh`

## Utilisation 

### Utilisation basique

Premièrement, rendez vous sur la page de l'émission que vous voulez télécharger, par exemple, [ici](https://www.arte.tv/fr/videos/069098-000-A/zika-enquete-sur-une-epidemie/), [ici](https://www.arte.tv/fr/videos/064380-000-A/plutot-mourir-que-mourir/) ou [là](https://www.arte.tv/fr/videos/067093-040-A/tu-mourras-moins-bete/).
*Notez que l'url ne doit PAS venir d'une playlist. Si vous voulez télécharger une vidéo inclue dans une playlist il faut d'abord que vous trouvier la page propre à la vidéo. Par exemple, ce lien [là](https://www.arte.tv/fr/videos/RC-015569/les-films-incontournables-du-mois-de-janvier/) ne fonctionnera pas, mais [celui-ci](https://www.arte.tv/fr/videos/077814-046-A/le-cid-d-anthony-mann-un-regard-une-minute/) oui.*

Ensuite copiez l'url de la page, et exécutez: 

*Notez qu'il faut aussi que l'url commence par `https` ou `http`: le programme analyse l'url et présume (pour l'instant) qu'elle commence par "https://" ou "http://".*

`./capt.sh url`

Ainsi, par exemple, pour ce lien: https://www.arte.tv/fr/videos/067093-040-A/tu-mourras-moins-bete/, tapez:

`./capt.sh https://www.arte.tv/fr/videos/067093-040-A/tu-mourras-moins-bete/`

Le fichier sera téléchargé là où se trouve le script. 

### Options

Il est possible de choisir la langue du fichier que vous voulez télécharger, le programme vous le demandera au tout début. **Cela ne signifie pas que l'interface changera de langue**, elle restera en français, par contre l'émission que vous aurez téléchargée elle sera dans la langue que vous aurez choisie. 

Notez que toutes les langues ne sont pas toujours disponibles. Si l'allemand et le français sont quasi systématiquement disponible, ce n'est pas le cas pour l'anglais, l'espagnol et le polonais. 

## Fonctionnement

Le script fonctionne de manière très basique. Il cherche le code url l'adresse du player utilisé par Arte. Cette addresse a la forme suivante:

`https://www.arte.tv/player/v3/index.php?json_url=https%3A%2F%2Fapi.arte.tv%2Fapi%2Fplayer%2Fv1%2Fconfig%2Ffr%2F067093-040-A%3Fautostart%3D1%26lifeCycle%3D1&lang=fr_FR`

On peut observer qu'elle est composer de plusieurs parties, l'adresse du player lui même avec la déclaration de l'usage d'un paramètre (`https://www.arte.tv/player/v3/index.php?json_url=`), puis l'adresse du fichier de configuration de l'api (`https%3A%2F%2Fapi.arte.tv%2Fapi%2Fplayer%2Fv1%2Fconfig%2Ffr%2F067093-040-A%3Fautostart%3D1%26lifeCycle%3D1&lang=fr_FR`). Ce fichier de configuration sert notamment à dire où est exactement le fichier vidéo, celui que l'on veut qui contient réellement la vidéo. 

Le script continue donc par enlever l'encodage url, l'adresse du fichier de configuration devient donc `https://api.arte.tv/api/player/v1/config/fr/067093-040-A?autostart=1&lifeCycle=1&lang=fr_FR`. Le script le télécharge puis se rend à la catégorie "HTTPS_SQ_1" qui contient le fichier de meilleure qualité, et le télécharge.

----------------------------------------------------

## Downloading

Open your terminal and type

`wget https://raw.githubusercontent.com/Magalame/ProjetArte/master/capt.sh`

Then make it executable:

`chmod +x capt.sh`

## Use

Spot the page of the podcast you want to download, and copy the url. For example [here](https://www.arte.tv/fr/videos/069098-000-A/zika-enquete-sur-une-epidemie/), [here](https://www.arte.tv/fr/videos/064380-000-A/plutot-mourir-que-mourir/) or [there](https://www.arte.tv/fr/videos/067093-040-A/tu-mourras-moins-bete/).*Note it won't work if you pick a url from a playlist, for example [this link](https://www.arte.tv/fr/videos/RC-015569/les-films-incontournables-du-mois-de-janvier/) won't work, but [that one](https://www.arte.tv/fr/videos/077814-046-A/le-cid-d-anthony-mann-un-regard-une-minute/) will. The program, for parsing purposes, also assumes the url starts with 'http(s)://'*

Then type

`./capt.sh url_of_the_podcast`

For example for this link https://www.arte.tv/fr/videos/067093-040-A/tu-mourras-moins-bete/ do that

`./capt.sh https://www.arte.tv/fr/videos/067093-040-A/tu-mourras-moins-bete/`

The file will be downloade where the script is located.

## Options

There is the possibility to chose the english, french, german etc version of the same podcast. You'll be asked what version you want to download at the very beginning. **It won't change the interface language**, unfortunately I don't have time to set up an English interface, but I think that the french one should be straightforward enough. 

*Note: not all languages are always available. French and German almost always are, but it isn't the case for English Spanish and Polish*
