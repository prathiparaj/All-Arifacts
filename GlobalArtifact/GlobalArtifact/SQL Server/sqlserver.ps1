Param(
    [ValidateNotNullOrEmpty()]
    [string]
    $RawPackagesList="sql-server-express"
)
  
$ErrorActionPreference = "Stop"
 
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force 
$ChocolateyPackageInstallerFolder = Join-Path $env:ALLUSERSPROFILE -ChildPath $("ChocolateyPackageInstaller-" + [System.DateTime]::Now.ToString("yyyy-MM-dd-HH-mm-ss"))
$ScriptLog = Join-Path -Path $ChocolateyPackageInstallerFolder -ChildPath "ChocolateyPackageInstaller.log"
$ChocolateyInstallLog = Join-Path -Path $ChocolateyPackageInstallerFolder -ChildPath "ChocolateyInstall.log"
function DisplayArgValues
{
    WriteLog '========== Configuration =========='
    WriteLog "RawPackagesList : $RawPackagesList"
    WriteLog '========== Configuration =========='
}
function InitializeFolders
{
    if ($false -eq (Test-Path -Path $ChocolateyPackageInstallerFolder))
    {
        New-Item -Path $ChocolateyPackageInstallerFolder -ItemType directory | Out-Null
    }
}

function WriteLog
{
    Param(
        
        [string]$Message,
        [switch]$LogFileOnly
    )
    $timestampedMessage = "[$([System.DateTime]::Now)] $Message" | % {
        if (-not $LogFileOnly)
        {
            Write-Host -Object $_
        }
        Out-File -InputObject $_ -FilePath $ScriptLog -Append
    }
}
function InstallChocolatey
{
    Param(
        [ValidateNotNullOrEmpty()] $chocolateyInstallLog
    )
    WriteLog 'Installing Chocolatey ...'
    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) | Out-Null
    WriteLog 'Success.'
}

function InstallPackages
{
    Param(
        [ValidateNotNullOrEmpty()][string] $packagesList
    )
    $separator = @(";",",")
    $splitOption = [System.StringSplitOptions]::RemoveEmptyEntries
    $packages = $packagesList.Trim().Split($separator, $splitOption)
    if (0 -eq $packages.Count)
    {
        WriteLog 'No packages were specified. Exiting.'
        return        
    }
    foreach ($package in $packages)
    {
        $package = $package.Trim()
        WriteLog "Installing package: $package ..."
        choco install $package --force --yes --acceptlicense --verbose --allow-empty-checksums | Out-Null  
        if (-not $?)
        {
            $errMsg = 'Installation failed. Please see the chocolatey logs in %ALLUSERSPROFILE%\chocolatey\logs folder for details.'
            throw $errMsg 
        }
    
        WriteLog 'Success.'
    }
}

try
{
    #
    InitializeFolders
    #
    DisplayArgValues
    
    # install the chocolatey package manager
    InstallChocolatey -chocolateyInstallLog $ChocolateyInstallLog
    # install the specified packages
    InstallPackages -packagesList $RawPackagesList
}
catch
{
    $errMsg = $Error[0].Exception.Message
    if ($errMsg)
    {
        WriteLog -Message "ERROR: $errMsg" -LogFileOnly
    }
    throw
}
 