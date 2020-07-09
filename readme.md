# plex-mediaserver-win
## Docker Container for Plex Media Server Windows
### Things to note
- Attach to a transparent network
- You can install the updates from the Web UI as they come along
- Use a volume to store/import the configuration database
- Use a managed service identity + credential spec for accessing files on network shares (e.g. NAS)
### Sample Docker Compose
- hostname: plex
- static mac address
- MSI credential spec