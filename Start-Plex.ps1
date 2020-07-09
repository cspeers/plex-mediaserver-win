[CmdletBinding()]
param
(
    
)

$RegFileName='C:\Plex\current_settings.reg'
if ((Test-Path $RegFileName) -and ($env:IMPORT_REGISTRY) -and ($env:IMPORT_REGISTRY -in 'YES','1','TRUE'))
{
    Write-Host "Importing Existing Registry Settings..."
    Start-Process -FilePath 'reg.exe' -ArgumentList 'import',$RegFileName -NoNewWindow -Wait
}

try
{
    Write-Host "Exporting Current Registry Settings"
    Start-Process -FilePath 'reg.exe' -ArgumentList 'export','"HKCU\Software\Plex, Inc.\Plex Media Server"',$RegFileName,'/y' -NoNewWindow -Wait
    Write-Host "Starting Plex Media Server $($env:PLEX_VERSION)"
    Start-Process -FilePath 'C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe' -NoNewWindow -Wait   
}
finally
{
    Write-Host "All Done!"
}
