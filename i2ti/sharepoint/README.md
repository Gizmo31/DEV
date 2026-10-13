# Page native SharePoint I2TI (.aspx)

Ce dossier permet de créer une véritable page moderne SharePoint Online dans la bibliothèque SitePages. Le fichier .aspx est généré par SharePoint ; un fichier HTML renommé n’est pas une page moderne valide.

## Résultat

- Introduction et raison d’être I2TI.
- Six piliers en deux sections de trois colonnes.
- Valeur apportée aux sites, livrables clés et indicateurs d’impact.
- Conclusion sur l’ambition commune.
- Composants Texte natifs, modifiables dans SharePoint ; adaptation aux petits écrans gérée par SharePoint.
- Page nouvelle en brouillon, sans remplacement de la page existante.

Les filtres et les panneaux dépliables de la maquette HTML ne sont pas repris. La typographie et les couleurs suivent le thème SharePoint du site. Le logo officiel pourra être ajouté avec un composant Image.

## Prérequis

PowerShell compatible avec la version de PnP.PowerShell installée (PowerShell 7.4.6 ou supérieur pour PnP.PowerShell 3.x), module PnP.PowerShell, droits de création de pages sur le site et identifiant d’une application Entra ID autorisée pour la connexion interactive PnP. Demandez cet identifiant à votre administrateur Microsoft 365 ; aucun secret ne doit être ajouté au dépôt.

Documentation : https://pnp.github.io/powershell/articles/authentication.html

## Utilisation

Téléchargez ce dossier en conservant Create-I2TIPage.ps1 et pillars.json ensemble, puis lancez :

```powershell
Install-Module PnP.PowerShell -Scope CurrentUser
./Create-I2TIPage.ps1 -SiteUrl "https://pfabre.sharepoint.com/teams/Dir-OPERATIONS/manufacturing" -ClientId "VOTRE-IDENTIFIANT-APPLICATION-ENTRA"
```

Le script crée SitePages/I2TI-Industrie-de-demain.aspx. Il refuse de remplacer un fichier existant. Pour une autre version, utilisez un nom distinct :

```powershell
./Create-I2TIPage.ps1 -SiteUrl "https://pfabre.sharepoint.com/teams/Dir-OPERATIONS/manufacturing" -ClientId "VOTRE-IDENTIFIANT-APPLICATION-ENTRA" -PageName "I2TI-Industrie-de-demain-v2"
```

En cas d’erreur après création, une page partielle peut rester en brouillon : vérifiez-la dans SharePoint avant de relancer avec un nouveau nom.

Après création, vérifiez le contenu et la présentation, ajoutez le logo approuvé et publiez depuis SharePoint. Les pages soumises à approbation suivent les règles de votre bibliothèque.

## Validation

Les six piliers sont repris du contenu de la maquette. Le script n’a pas été exécuté contre votre tenant ; PowerShell/PnP et l’accès SharePoint ne sont pas disponibles dans l’environnement de création. Aucune page SharePoint n’a été modifiée lors de l’export GitHub.
