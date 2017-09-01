$script:GocdServer = ''
$script:GocdUser   = ''
$script:GocdToken  = ''

Get-ChildItem -Path "$PSScriptRoot" -Filter '*.ps1' -Recurse | ForEach-Object {
    . "$($_.FullName)"
}