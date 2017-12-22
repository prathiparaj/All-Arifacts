[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$True)]
    [string] $Uri,
    
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$True)]
    [string] $Path,
    
    [int] $TimeoutSec = 60
)

try
{
    (New-Object System.Net.WebClient).DownloadFile($Uri, $Path)
    Write-Host "downloadning successfull"
}
catch
{
    Write-Error "Failed to download"
}
