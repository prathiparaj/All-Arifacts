try
{

cmdkey /add:executeablesrepo.file.core.windows.net /user:executeablesrepo /pass:a9I1VAGZyxE9Vn+apQ8dSL6LPkM5FOAqA5DGJJk0OFNKbo/yFaGFVi5HbDgiKQEcvz6z8eWje6jhwuk8D7ubjw==

net use z: \\executeablesrepo.file.core.windows.net\repo /u:AZURE\executeablesrepo a9I1VAGZyxE9Vn+apQ8dSL6LPkM5FOAqA5DGJJk0OFNKbo/yFaGFVi5HbDgiKQEcvz6z8eWje6jhwuk8D7ubjw==
}
catch
{
    Write-Error "Failed to map file share" 
}



