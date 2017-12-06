<##################################################################################################
Description
    ===========

                - This script does the following - 
                                - installs chocolatey
                                - installs specified chocolatey packages

                - This script generates logs in the following folder - 
                                - %ALLUSERSPROFILE%\ChocolateyPackageInstaller-{TimeStamp}\Logs folder.


    Usage examples
    ==============
    
    Powershell -executionpolicy bypass -file ChocolateyPackageInstaller.ps1


    Pre-Requisites
    ==============

    - Ensure that the powershell execution policy is set to unrestricted (@TODO).


    Known issues / Caveats
    ======================
    
    - No known issues.


    Coming soon / planned work
    ==========================

    - N/A.    

##################################################################################################>

#
# Optional arguments to this script file.
#

Param(
    # comma or semicolon separated list of chocolatey packages.
    [ValidateNotNullOrEmpty()]
    [string]
    $RawPackagesList="sqlite --version 3.16.2"
)

##################################################################################################

#
# Powershell Configurations
#

# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.  
$ErrorActionPreference = "Stop"

# Ensure that current process can run scripts. 
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force 

###################################################################################################

#
# Custom Configurations
#

$ChocolateyPackageInstallerFolder = Join-Path $env:ALLUSERSPROFILE -ChildPath $("ChocolateyPackageInstaller-" + [System.DateTime]::Now.ToString("yyyy-MM-dd-HH-mm-ss"))

# Location of the log files
$ScriptLog = Join-Path -Path $ChocolateyPackageInstallerFolder -ChildPath "ChocolateyPackageInstaller.log"
$ChocolateyInstallLog = Join-Path -Path $ChocolateyPackageInstallerFolder -ChildPath "ChocolateyInstall.log"

##################################################################################################

# 
# Description:
#  - Displays the script argument values (default or user-supplied).
#
# Parameters:
#  - N/A.
#
# Return:
#  - N/A.
#
# Notes:
#  - Please ensure that the Initialize() method has been called at least once before this 
#    method. Else this method can only write to console and not to log files. 
#

function DisplayArgValues
{
    WriteLog '========== Configuration =========='
    WriteLog "RawPackagesList : $RawPackagesList"
    WriteLog '========== Configuration =========='
}

##################################################################################################

# 
# Description:
#  - Creates the folder structure which'll be used for dumping logs generated by this script and
#    the logon task.
#
# Parameters:
#  - N/A.
#
# Return:
#  - N/A.
#
# Notes:
#  - N/A.
#

function InitializeFolders
{
    if ($false -eq (Test-Path -Path $ChocolateyPackageInstallerFolder))
    {
        New-Item -Path $ChocolateyPackageInstallerFolder -ItemType directory | Out-Null
    }
}

##################################################################################################

# 
# Description:
#  - Writes specified string to the console as well as to the script log (indicated by $ScriptLog).
#
# Parameters:
#  - $message: The string to write.
#
# Return:
#  - N/A.
#
# Notes:
#  - N/A.
#

function WriteLog
{
    Param(
        <# Can be null or empty #>
        [string]$Message,
        [switch]$LogFileOnly
    )

    $timestampedMessage = "[$([System.DateTime]::Now)] $Message" | ForEach-Object {
        if (-not $LogFileOnly)
        {
            Write-Host -Object $_
        }
        Write-Host $timestampedMessage
        Out-File -InputObject $_ -FilePath $ScriptLog -Append
    }
}

##################################################################################################

# 
# Description:
#  - Installs the chocolatey package manager.
#
# Parameters:
#  - N/A.
#
# Return:
#  - If installation is successful, then nothing is returned.
#  - Else a detailed terminating error is thrown.
#
# Notes:
#  - @TODO: Write to $chocolateyInstallLog log file.
#  - @TODO: Currently no errors are being written to the log file ($chocolateyInstallLog). This needs to be fixed.
#

function InstallChocolatey
{
    Param(
        [ValidateNotNullOrEmpty()] $chocolateyInstallLog
    )

    WriteLog 'Installing Chocolatey ...'

    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) | Out-Null

    WriteLog 'Success.'
}

##################################################################################################

#
# Description:
#  - Installs the specified chocolatey packages on the machine.
#
# Parameters:
#  - N/A.
#
# Return:
#  - N/A.
#
# Notes:
#  - N/A.
#

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

        # Install git via chocolatey.
        choco install $package --force --yes --acceptlicense --verbose --allow-empty-checksums | Out-Null  
        if (-not $?)
        {
            $errMsg = 'Installation failed. Please see the chocolatey logs in %ALLUSERSPROFILE%\chocolatey\logs folder for details.'
            throw $errMsg 
        }
    
        WriteLog 'Success.'
    }
}

##################################################################################################

#
# 
#

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

    # IMPORTANT NOTE: We rely on startChocolatey.ps1 to manage the workflow. It is there where we need to
    # ensure an exit code is correctly sent back to the calling process. From here, all we need to do is
    # throw so that startChocolatey.ps1 can handle the state correctly.
    throw
}
