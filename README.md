# PowerShell - File Servers and DFS Namespaces
PowerShell script to automate deployment of DFS and File Servers
- Adds File Server and DFS services.
- Configures required namespaces (skype/sql witness) and replication group between 2 File Servers 
- Creates new share on the second file server as it's required during DFS namespace configuration.
- Create additional file shares for services such as skype for business and witness