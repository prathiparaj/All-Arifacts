function Create-Folder {
    Param ([string]$path)
    if ((Test-Path $path) -eq $false) 
    {
        Write-Host "$path doesn't exist. Creating now.."
        New-Item -ItemType "directory" -Path $path
    }
}

function Download-File{
    Param ([string]$src, [string] $dst)

    (New-Object System.Net.WebClient).DownloadFile($src,$dst)
    #Invoke-WebRequest $src -OutFile $dst
}

function WaitForFile($File) {
  while(!(Test-Path $File)) {    
    Start-Sleep -s 10;   
  }  
} 


#Setup Folders

$setupFolder = "c:\Software-Modules"
Create-Folder "$setupFolder"

#Create-Folder "c:\Spring-Framework"




if((Test-Path "$setupFolder\mysql-5.7.20-winx64.zip") -eq $false)
{
  
        Download-File "https://mylibrary123.blob.core.windows.net/reposit/mysql-5.7.20-winx64.zip" "$setupFolder\mysql-5.7.20-winx64.zip"  
}

if((Test-Path "$setupFolder\sql.bat") -eq $false)
{
  
        Download-File "https://mylibrary123.blob.core.windows.net/reposit/sql.bat" "$setupFolder\sql.bat"  
}

if((Test-Path "$setupFolder\vcredist_x64.exe") -eq $false)
{
  
        Download-File "https://mylibrary123.blob.core.windows.net/reposit/vcredist_x64.exe" "$setupFolder\vcredist_x64.exe"  
}

Start-Process -FilePath “$setupFolder\vcredist_x64.exe” -ArgumentList “/passive” -Wait -Passthru

   

Add-Type -assembly "system.io.compression.filesystem"

$BackUpPath = "$setupFolder\mysql-5.7.20-winx64.zip"

$destination = "C:\"



Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)







Start-Process -FilePath $setupFolder\sql.bat

#$env:Path += ";C:\mysql-5.7.20-winx64\bin"

#mysqld --initialize
#mysqld
#& cmd /c  'mysqld --initialize' 
#& cmd /c  'mysqld'

#Remove-Item –path "C:\Software-Modules\spring-framework-5.0.1.RELEASE-dist.zip" -Recurse
