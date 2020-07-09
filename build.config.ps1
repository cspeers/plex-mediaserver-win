$env:DOCKER_REPO = "cspeers"
$env:DOCKER_IMAGE = "plex-windows"
$env:DOCKER_IMAGE_TAG='1809'
$env:DOCKER_BASE_IMAGE = "mcr.microsoft.com/windows:$env:DOCKER_IMAGE_TAG"

$PLEX_UPDATE_FEED='https://plex.tv/api/downloads/5.json?channel=plexpass'
$Downloads=Invoke-RestMethod -UseBasicParsing -uri $PLEX_UPDATE_FEED
$WindowsDownload=$Downloads.computer.Windows
$ReleaseInfo=$WindowsDownload.releases
Write-Host "The current version of Plex Media Server is $($WindowsDownload.version)"
Write-Host "What's New: `n$($WindowsDownload.items_added)"
Write-Host "What's Fixed: `n$($WindowsDownload.items_fixed)"

$env:DOCKER_APPLICATION_VERSION = $WindowsDownload.version.Substring(0,$WindowsDownload.version.LastIndexOf('-'))
$env:PLEX_INSTALL_URI = $ReleaseInfo.url