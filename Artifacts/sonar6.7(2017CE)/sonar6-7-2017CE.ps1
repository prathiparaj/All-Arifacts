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
Create-Folder $setupFolder



#download sonar file
if((Test-Path "$setupFolder\sonarqube-6.7.zip") -eq $false)
{
  
        Download-File "https://mylibrary123.blob.core.windows.net/reposit/sonarqube-6.7.zip" "$setupFolder\sonarqube-6.7.zip"  
}


#unzip
	
	Add-Type -assembly "system.io.compression.filesystem"
	
	$BackUpPath = "$setupFolder\sonarqube-6.7.zip"
	
	$destination = "$setupFolder\"
	
	
	
	Add-Type -assembly "system.io.compression.filesystem"
	
	[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)

#Remove Zip file
Remove-Item –Path "$setupFolder\sonarqube-6.7.zip" -Recurse
	

#change wrapper.java.command path in wrapper.conf file
$fileName ='C:\Software-Modules\sonarqube-6.7\conf\wrapper.conf' 
$original = '#wrapper.java.command=/path/to/my/jdk/bin/java'
$content = 'wrapper.java.command=C:\Program Files\Java\jdk1.8.0_152\bin\java'


(Get-Content $fileName) | % {
   if ($_.ReadCount -eq 3) {
   $_ -replace "$original", "$content"
   } else {
      $_
   }
   } | Set-Content $fileName

#Start-Process -FilePath "C:\Software-Modules\sonarqube-6.7\bin\windows-x86-64\StartSonar.bat"


