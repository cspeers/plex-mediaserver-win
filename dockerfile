ARG BASE_IMAGE=mcr.microsoft.com/windows/server:10.0.20348.707
FROM ${BASE_IMAGE}

ARG IMPORT_PREFS=YES
ENV IMPORT_REGISTRY ${IMPORT_PREFS}

ARG APP_VERSION
ENV PLEX_VERSION=${APP_VERSION}

ARG PLEX_INSTALLER
ENV PLEX_INSTALLER_URI ${PLEX_INSTALLER}

SHELL ["powershell.exe", "-Command", "$ErrorActionPreference = 'Stop';"]
RUN New-Item -Path C:\ -ItemType Directory -Name Plex
# Copy/download install files to container
RUN New-Item -Path C:\ -ItemType Directory -Name PlexSetup
WORKDIR C:/PlexSetup
# Download the installer
ADD ${PLEX_INSTALLER_URI} Setup.exe

# Install Plex
#RUN Start-Process -FilePath Setup.exe -ArgumentList "/VERYSILENT","/NORESTART","/SUPPRESSMSGBOXES" -NoNewWindow -Wait
RUN Start-Process -FilePath Setup.exe -ArgumentList /quiet -NoNewWindow -Wait
RUN New-ItemProperty -Path 'HKCU:\Software\Plex, Inc.\Plex Media Server' -Name 'LocalAppDataPath' -Value 'C:\Plex' -Force

# Cleanup
RUN Remove-Item -Path Setup.exe -Force
RUN New-Item -Path C:\Users\ContainerAdministrator\Documents -ItemType Directory -Name WindowsPowerShell
RUN Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
RUN Add-Content -Value 'Write-Host "Plex Media Server $($env:PLEX_VERSION)"' -Path $profile

COPY Start-Plex.ps1 /PlexSetup/

VOLUME [ "C:/Plex" ]

# Expose images possible configuration
EXPOSE 32400/tcp

# Define the entrypoint
#CMD Start-Process -FilePath 'C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe' -NoNewWindow -Wait
CMD C:\PlexSetup\Start-Plex.ps1


HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 CMD powershell -Command {Test-NetConnection $env:COMPUTERNAME -Port 32400}