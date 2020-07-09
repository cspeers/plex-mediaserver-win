[CmdletBinding()]
param
(
    [Parameter()]
    [switch]$TagLatest
)
$ErrorActionPreference = "Stop"
. $(Join-Path $PSScriptRoot ".\build.config.ps1")


$PLEX_URI=$env:PLEX_INSTALL_URI
$BASE_IMAGE=$env:DOCKER_BASE_IMAGE
Write-Host $env:DOCKER_APPLICATION_VERSION
$IMAGEVERSION="win1809-$($env:DOCKER_APPLICATION_VERSION)"

$imageFullName = ("{0}/{1}:{2}" -f $env:DOCKER_REPO, $env:DOCKER_IMAGE, $IMAGEVERSION)
$imageLatestName = ("{0}/{1}:latest" -f $env:DOCKER_REPO, $env:DOCKER_IMAGE)

Write-Host "Building $imageFullName"
$dockerArgs=@('build',
'--build-arg',"BASE_IMAGE=$BASE_IMAGE",
'--build-arg',"PLEX_INSTALLER=$PLEX_URI",
'--build-arg', "APP_VERSION=$env:DOCKER_APPLICATION_VERSION",
'.','-t',$imageFullName
)
Start-Process -FilePath 'docker.exe' -ArgumentList $dockerArgs -NoNewWindow -Wait
if($TagLatest) {
    Write-Host "Tagging image $imageFullName as latest"
    Start-Process -FilePath 'docker.exe' -ArgumentList 'tag',$imageFullName,$imageLatestName -NoNewWindow -Wait
}