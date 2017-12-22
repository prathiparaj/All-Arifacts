
$drive = "C:\Program Files\Windows NT" 
$folderName = "oraclesetup" 
New-Item -Path $drive -Name $folderName -ItemType "directory"


$url = 'https://globalartifactstg.blob.core.windows.net/globalsoftwarelink4artifact/winx64_12201_database.zip'

$vscodeSetup = "C:\Program Files\Windows NT\oraclesetup\winx64_12201_database.zip"

try
{
    (New-Object System.Net.WebClient).DownloadFile($Url, $vscodeSetup)
    Write-Host "downloadning  successfull"
}
catch
{
    Write-Error "Failed to oraclesetup zip";
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Unzip "C:\Program Files\Windows NT\oraclesetup\winx64_12201_database.zip" "C:\"


$responsefile= 'https://globalartifactstg.blob.core.windows.net/globalsoftwarelink4artifact/db12c.rsp'

$vscodeSetup1 = "C:\database\db.rsp"

try
{
    (New-Object System.Net.WebClient).DownloadFile($responsefile, $vscodeSetup1)
    Write-Host "downloadning  successfull"
}
catch
{
    Write-Error "Failed to download configurationfile";
}

Set-Location "C:\database"  

$filepath="C:\database\setup.exe"

try
{
   
    Start-Process -FilePath $filepath -ArgumentList "-silent -responseFile C:\database\db.rsp"

    Write-Host "Successfully installed initiated process of oracle12c";

}
catch
{
    Write-Error "Failed to install oracle12c in machine";
}
