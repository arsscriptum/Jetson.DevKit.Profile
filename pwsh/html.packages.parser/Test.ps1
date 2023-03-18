


$Urls = @("https://developer.nvidia.com/embedded/linux-tegra-r2421",
    "https://developer.nvidia.com/linux-tegra-rel-21",
    "https://developer.nvidia.com/linux-tegra-r213",
    "https://developer.nvidia.com/linux-tegra-r214",
    "https://developer.nvidia.com/linux-tegra-r214",
    "https://developer.nvidia.com/embedded/linux-tegra-r231",
    "https://developer.nvidia.com/embedded/linux-tegra-r232",
    "https://developer.nvidia.com/embedded/linux-tegra-r241",
    "https://developer.nvidia.com/embedded/linux-tegra-r242",
    "https://developer.nvidia.com/embedded/linux-tegra-r2421",
    "https://developer.nvidia.com/embedded/linux-tegra-271",
    "https://developer.nvidia.com/embedded/linux-tegra-r281",
    "https://developer.nvidia.com/embedded/linux-tegra-r2821",
    "https://developer.nvidia.com/embedded/linux-tegra-r281",
    "https://developer.nvidia.com/linux-tegra-r215")

$Urls.Count
$Urls = $Urls | select -Unique

$ParserScript = "$PsScriptRoot\Invoke-ParseHtml.ps1"
$testPath = Join-Path "$PSScriptRoot" "test"
if((Test-Path -Path "$testPath" -PathType "Container")){
    $null = Remove-Item "$testPath" -Recurse -Force -ErrorAction Ignore
}
$null = New-Item "$testPath" -ItemType directory -Force -ErrorAction Ignore
ForEach($u in $Urls){
    [Uri]$MyUri = $u
    [string]$UrlId = $MyUri.Segments[$MyUri.Segments.Count-1]
    $testLogPath = Join-Path "$testPath" "$UrlId"
    if(-not (Test-Path -Path "$testLogPath" -PathType "Container")){
        $null = New-Item "$testLogPath" -ItemType directory -Force -ErrorAction Ignore
    }
    [string]$LogFile = "{0}\{1}.out" -f "$testLogPath", "$UrlId"

    Write-Host "[TEST] " -f DarkCyan -n
    Write-Host "start test for url `"$u`" " -f Gray

    $ScriptOutput = . "$PsScriptRoot\Invoke-ParseHtml.ps1" -Url $u | Out-String
    Set-Content -Path "$LogFile" -Value "$ScriptOutput"
    Write-Host "[TEST] " -f DarkCyan -n
    Write-Host "done. LogFile $LogFile" -f Gray
    
}