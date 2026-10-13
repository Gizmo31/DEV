#requires -Version 7.4
#requires -Modules PnP.PowerShell
[CmdletBinding()]
param(
    [Parameter(Mandatory)][uri]$SiteUrl,
    [Parameter(Mandatory)][string]$ClientId,
    [ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9-]*$')]
    [string]$PageName = 'I2TI-Industrie-de-demain'
)
$ErrorActionPreference = 'Stop'
if ($SiteUrl.Scheme -ne 'https') { throw 'SiteUrl doit utiliser HTTPS.' }
$dataPath = Join-Path $PSScriptRoot 'pillars.json'
$pillars = @(Get-Content -LiteralPath $dataPath -Raw -Encoding utf8 | ConvertFrom-Json)
if ($pillars.Count -ne 6) { throw 'Le fichier de contenu doit contenir six piliers.' }
function Encode([string]$Value) {
    return [System.Net.WebUtility]::HtmlEncode($Value)
}
Connect-PnPOnline -Url $SiteUrl.AbsoluteUri -Interactive -ClientId $ClientId
$fileName = "$PageName.aspx"
# Vérification avant création : aucune page existante ne sera remplacée.
$query = "<View><Query><Where><Eq><FieldRef Name='FileLeafRef'/><Value Type='Text'>$fileName</Value></Eq></Where></Query><RowLimit>1</RowLimit></View>"
$existing = @(Get-PnPListItem -List 'SitePages' -Query $query)
if ($existing.Count -gt 0) {
    throw "La page $fileName existe déjà. Choisissez un autre PageName."
}
$page = Add-PnPPage -Name $PageName -Title 'I2TI — Les six piliers de notre futur' -LayoutType Article
Add-PnPPageSection -Page $page -SectionTemplate OneColumn -Order 1 | Out-Null
$intro = '<h2>Transformer l’industrie. Durablement.</h2><p>Transformer les ambitions du Groupe en solutions industrielles innovantes et durables.</p><p>Ingénierie · Innovation · Transformation industrielle</p><h2>Les six piliers de notre futur</h2><p>Une offre de services complémentaire pour créer de la valeur pour les sites.</p>'
Add-PnPPageTextPart -Page $page -Section 1 -Column 1 -Text $intro | Out-Null

# Deux rangées de trois colonnes : les textes restent éditables dans SharePoint.
for ($row = 0; $row -lt 2; $row++) {
    $section = $row + 2
    Add-PnPPageSection -Page $page -SectionTemplate ThreeColumn -Order $section | Out-Null
    for ($column = 1; $column -le 3; $column++) {
        $index = $row * 3 + $column - 1
        $p = $pillars[$index]
        $itemsHtml = ($p.items | ForEach-Object { '<li>' + (Encode $_) + '</li>' }) -join ''
        $text = '<p><strong>PILIER ' + ('{0:00}' -f ($index + 1)) + '</strong></p>' +
            '<h2>' + (Encode $p.title) + '</h2>' +
            '<p>' + (Encode $p.description) + '</p>' +
            '<h3>Livrables clés</h3><ul>' + $itemsHtml + '</ul>' +
            '<h3>Indicateurs d’impact</h3><p>' + (Encode $p.impact) + '</p>'
        Add-PnPPageTextPart -Page $page -Section $section -Column $column -Text $text | Out-Null
    }
}
Add-PnPPageSection -Page $page -SectionTemplate OneColumn -Order 4 | Out-Null
$closing = '<h2>Notre ambition commune</h2><p>Accélérer durablement la transformation industrielle du Groupe.</p><p>Concevoir, expérimenter, industrialiser et partager : une offre de services commune pour transformer les besoins des sites en résultats concrets.</p><p><em>Première version — Les indicateurs sont des axes de suivi, sans résultats chiffrés.</em></p>'
Add-PnPPageTextPart -Page $page -Section 4 -Column 1 -Text $closing | Out-Null
$page.Save()
Write-Host "Page créée en brouillon : $($SiteUrl.AbsoluteUri.TrimEnd('/'))/SitePages/$fileName"
Write-Host 'Ouvrez la page dans SharePoint pour vérifier la présentation, puis publiez-la depuis SharePoint.'
