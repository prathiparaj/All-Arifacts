$drive = "C:\Program Files\Windows NT" 
$folderName = "sqlsetup" 
New-Item -Path $drive -Name $folderName -ItemType "directory"

$url = 'https://globalartifactstg.blob.core.windows.net/globalsoftwarelink4artifact/SQLServer2016-x64-ENU.iso'

$vscodeSetup = "C:\Program Files\Windows NT\sqlsetup\SQLServer2016-x64-ENU.iso"

try
{
    (New-Object System.Net.WebClient).DownloadFile($Url, $vscodeSetup)
    Write-Host "downloadning  successfull"
}
catch
{
    Write-Error "Failed to download sql iso";
}

$url1 = 'https://globalartifactstg.blob.core.windows.net/globalsoftwarelink4artifact/ConfigurationFileDev.ini'

$vscodeSetup1 = "C:\ConfigurationFile.ini"

try
{
    (New-Object System.Net.WebClient).DownloadFile($Url1, $vscodeSetup1)
    Write-Host "downloadning  successfull"
}
catch
{
    Write-Error "Failed to download configurationfile";
}


try
{
    $mountResult = Mount-DiskImage "C:\Program Files\Windows NT\sqlsetup\SQLServer2016-x64-ENU.iso" -PassThr
    $driveLetter = ($mountResult | Get-Volume).DriveLetter
    $filepath=$driveLetter+":\"+"setup.exe"
    Mount-DiskImage -ImagePath "C:\Program Files\Windows NT\sqlsetup\SQLServer2016-x64-ENU.iso"
    Write-Host "Mounting  successfull"
}
catch
{
    Write-Error "failed to mount";
}

Set-Location "C:\"  

try
{
   
    Start-Process -FilePath $filepath -ArgumentList "/ConfigurationFile=ConfigurationFile.ini"

    Write-Host "Successfully installed SQL Developer 2016";

}
catch
{
    Write-Error "Failed to install SQL in machine";
}
