# PowerShell - File Servers and DFS Namespaces
PowerShell script to automate deployment of DFS and File Servers
- Adds File Servers and DFS services.
- Configures required namespaces (skype/sql witness) and replication group between 2 File Servers 
- Creates new share on the second file server as it's required during DFS namespace configuration.
- Create additional file shares for services such as skype for business and witness
- Originally was used together with VMM templates (replace args if necessary)

## Folder structure (use them in the following order)
- DomainFS01.cr includes the script for joining FS01 up to domain
- DomainFS02.cr includes the script for joining FS02 up to domain
- ShareFS02.ps1 includes the script for setting up required shares
- DfsnFS01.cr includes script for setting DFS on FS01 server