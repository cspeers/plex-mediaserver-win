[CmdletBinding()]
param
(
    [Parameter()]
    [switch]$TagLatest
)
$ErrorActionPreference = "Stop"
. $(Join-Path $PSScriptRoot ".\build.config.ps1")

Write-Host $env:DOCKER_APPLICATION_VERSION
$IMAGEVERSION="$($Env:DOCKER_IMAGE_TAG)-$($env:DOCKER_APPLICATION_VERSION)"

$imageFullName = ("{0}/{1}:{2}" -f $env:DOCKER_REPO, $env:DOCKER_IMAGE, $IMAGEVERSION)
$imageLatestName = ("{0}/{1}:latest" -f $env:DOCKER_REPO, $env:DOCKER_IMAGE)


Write-Host `Pushing $imageFullName`
Start-Process -FilePath 'docker.exe' -ArgumentList 'push',$imageFullName -NoNewWindow -Wait

if($TagLatest){
    Write-Host "Tagging image as latest"
    Start-Process -FilePath 'docker.exe' -ArgumentList 'push',$imagelatestName -NoNewWindow -Wait
}