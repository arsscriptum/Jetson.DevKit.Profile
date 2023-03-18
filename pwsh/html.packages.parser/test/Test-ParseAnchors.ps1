[CmdletBinding(SupportsShouldProcess)]
param()

$Script:FatalError = $False
$Script:Quiet = $True  

try{
    $RootPath = (Resolve-Path "$PSScriptRoot\..").Path
    [string]$DependenciesImporter = "{0}\{1}" -f "$RootPath", "Import-Dependencies.ps1"
    . "$DependenciesImporter" -Quiet:$Script:Quiet

    [string]$DependenciesTester = "{0}\{1}" -f "$RootPath", "Test-Dependencies.ps1"
    . "$DependenciesTester" -Quiet:$Script:Quiet
}catch{
    $Script:FatalError = $true
    Write-Host "[ERROR] " -n -f DarkRed
    Write-Host "$_" -f DarkYellow
}

if($Script:FatalError -eq $True){
    Write-Host "Fatal Error. Exiting." -f DarkRed
}



function Get-HtmlAnchorsPositions {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [String]$Path
    )

    try{
        $HtmlData = Get-Content "$Path" -Raw
        $AnchorList = Search-HtmlAnchors -Text "$HtmlData"

        $AnchorListCount = $AnchorList.Count
        Write-Host "[TEST] " -n -f DarkYellow
        Write-Host "Search-HtmlAnchors returned $AnchorListCount itmes found" -f Gray
        $AnchorList
    }catch{
        Show-ExceptionDetails $_ -ShowStack
    }
}




$testdatapath = "C:\Users\gp\jetson\pwsh\html.packages.parser\test\testdata"
$testdata_path_0 = Join-Path "$testdatapath" "test-anchors_00.html"
$testdata_path_1 = Join-Path "$testdatapath" "test-anchors_01.html"
$testdata_path_2 = Join-Path "$testdatapath" "test-anchors_02.html"

[System.Collections.ArrayList]$DataFiles = [System.Collections.ArrayList]::new()
[void]$DataFiles.Add($testdata_path_0)
[void]$DataFiles.Add($testdata_path_1)
[void]$DataFiles.Add($testdata_path_2)

[System.Collections.ArrayList]$PositionList = [System.Collections.ArrayList]::new()
$PositionList = Get-HtmlAnchorsPositions -Path "$testdata_path_0" 
$PositionListCount = $PositionList.Count

$HtmlData = Get-Content "$testdata_path_0" -Raw
[System.Collections.ArrayList]$ErrorList = Get-HtmlAnchorsErrors -Text "$HtmlData" -Positions $PositionList  -Verbose

# sort
$ErrorList = $ErrorList | sort -Descending -Property start

#Invoke-ApplyTextCorrections -Text "$HtmlData" -ErrorsList $ErrorList -Verbose

