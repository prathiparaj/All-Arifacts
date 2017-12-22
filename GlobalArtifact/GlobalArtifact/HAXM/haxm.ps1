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

$setupFolder = "c:\haxm"
Create-Folder "$setupFolder"






# haxm 
if((Test-Path "$setupFolder\haxm-windows_v6_2_1.zip") -eq $false)
{
  
        Download-File "https://g7crtipl-my.sharepoint.com/personal/proloy_saha_g7cr_in/_layouts/15/guestaccess.aspx?docid=18f32b8ec2e7a42e1a06f09cda05811b5&authkey=Aea2y6k2y-zRIsd4m9zliVI" "$setupFolder\haxm-windows_v6_2_1.zip"  
}



Add-Type -assembly "system.io.compression.filesystem"

$BackUpPath = "C:\haxm\haxm-windows_v6_2_1.zip"

$destination = "C:\haxmextracted"



Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)


Start-Process -FilePath C:\haxmextracted\silent_install.bat -WorkingDirectory C:\haxmextracted\
