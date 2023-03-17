[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory=$true)]
    [String]$Url
)

# ---------------------------------------------------------------
# Invoke-GenerateIndexFromHtml
#
# Tools to help creating my resources index page 
#
# Go to the JetPack archives https://developer.nvidia.com/embedded/jetpack-archive 
#
# After selecting a specific driver version, i.e https://developer.nvidia.com/embedded/linux-tegra-r214
# Download the html file 
# wget https://developer.nvidia.com/embedded/linux-tegra-r214
#
# 
# ---------------------------------------------------------------


function Initialize-HtmlData {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [String]$Url
    )

    $tmppath = Join-Path "$PSScriptRoot" "tmp"
        if(-not (Test-Path -Path "$tmppath" -PathType "Container")){
            $null = New-Item "$tmppath" -ItemType directory -Force -ErrorAction Ignore
        }

    [Uri]$MyUri = $Url
    [string]$localfilename = (New-Guid).Guid

    $htmldatapath = "{0}\{1}.html" -f $tmppath, $localfilename
    
    Invoke-WebRequest -Uri $Url -OutFile "$htmldatapath"
    $cnt = Get-Content $htmldatapath -Raw
    $len = $cnt.Length

    $ihead = $cnt.IndexOf('</head><body')
    $datasection = $cnt.SubString($ihead, $len - $ihead)

    $datasection = $datasection.Replace('/embedded/','https://developer.nvidia.com/embedded/')
    $datasection = $datasection.Replace("<a target=","<a")
    $datasection = $datasection.Replace("`"_blank`"","")

    $firstdllink = $datasection.IndexOf('Quick Start Guide')
    Write-Verbose "Quick Start Guide. firstdllink $firstdllink"
    $lastdllink = $datasection.LastIndexOf('Release SHA Hashes')
    Write-Verbose "Release SHA Hashes. lastdllink $lastdllink"

    $len = $datasection.Length
    $ilinks = $datasection.LastIndexOf('<a href',$firstdllink)
    $elinks = $datasection.IndexOf('</a>',$lastdllink)
    Write-Verbose "first link index $ilinks"
    Write-Verbose "last link index $elinks"
    $linkssection = $datasection.SubString($ilinks, $elinks - $ilinks)
    $linkssection = $linkssection.Replace('<a href',"`n<a href")
    $linkssection = $linkssection.Replace('</a>',"</a>`n")
    $linkssection = $linkssection.Replace('</li><li>',"")

    Set-Content -Path "$htmldatapath" -Value "$linkssection"
    return $htmldatapath
}

function Invoke-ParseHtmlPage {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [String]$Path
    )


    [regex]$urlpattern = [regex]::new('(?<start>[/<a href=/]*)\"(?<url>[0-9a-zA-Z_\.\ /\:\"\-]*)\>*(?<name>[\-\.\ a-zA-Z0-9]*)\<*')
    try{
        $List = Get-Content $Path
        $LinksList = [System.Collections.ArrayList]::new()
        ForEach($line in $List){
            if($line -match $urlpattern){

                $url = $Matches.url
                $name  = $Matches.name
                
                $o = [PsCustomObject]@{
                    Name = $name 
                    Url = $url
                }
                [void]$LinksList.Add($o)
            }
        }
        $LinksList
    }catch{
        Show-ExceptionDetails $_ -ShowStack
    }
}



function Invoke-GenerateIndexFromHtml {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [String]$Url,
        [Parameter(Mandatory=$false)]
        [Switch]$DownloadFile
    )

    try{
        $outpath = Join-Path "$PSScriptRoot" "out"

        if(-not (Test-Path -Path "$outpath" -PathType "Container")){
            $null = New-Item "$outpath" -ItemType directory -Force -ErrorAction Ignore
        }

        $tmppath = Join-Path "$PSScriptRoot" "tmp"
         $null = Remove-Item "$tmppath" -Recurse -Force -ErrorAction Ignore
        if(-not (Test-Path -Path "$tmppath" -PathType "Container")){
            $null = New-Item "$tmppath" -ItemType directory -Force -ErrorAction Ignore
        }


        [Uri]$MyUri = $Url
        $Title = $MyUri.Segments[$MyUri.Segments.Count-1]
        $invalidTitle = $Title.Contains(" ")
        if($invalidTitle){ throw "title must not have spaces" }

        $Path = Initialize-HtmlData -Url $Url

        $resourcefolder = Join-Path "$outpath" "$Title"
        if((Test-Path -Path "$resourcefolder" -PathType "Container") -eq $True){
            $null = Remove-Item "$resourcefolder" -Recurse -Force -ErrorAction Ignore
        }
        $null = New-Item "$resourcefolder" -ItemType "Directory" -Force -ErrorAction Stop

        $filespath = Join-Path "$resourcefolder" "files"
        $null = New-Item "$filespath" -ItemType "Directory" -Force -ErrorAction Stop

        Write-Verbose "parsing logs from $Path"
        $ObjectsList = Invoke-ParseHtmlPage -Path $Path

        $indexpath = Join-Path "$resourcefolder" "README.md"
        $null = New-Item "$indexpath" -ItemType file -ErrorAction Stop

        ForEach($obj in $ObjectsList){
         
            [string]$u = $obj.url
            [string]$n = $obj.name
            [string]$u = $u.Trim("`"")
            [Uri]$MyUri = $u

            Write-Host "Deteced new resources data" -f DarkCyan

            $IsUrlInvalid = (([string]::IsNullOrEmpty($($MyUri.Host))) -Or ([string]::IsNullOrEmpty($($MyUri.LocalPath))))
            $filebasename = ''
            $IsUrlInvalid = (([string]::IsNullOrEmpty($($MyUri.Host))) -Or ([string]::IsNullOrEmpty($($MyUri.LocalPath))))
            if($IsUrlInvalid -eq $True){
                if(($u.LastIndexOf('/')) -ne -1){
                    $lastslashid = $u.LastIndexOf('/') + 1
                    $filebasename = $u.SubString($lastslashid)
                }
            }else{
                $filebasename = $MyUri.Segments[$MyUri.Segments.Count-1]
            }

            $filebasename = $filebasename.Trim()
            $fullfilename = Join-Path "$filespath" "$filebasename"
            $masterlink = "http://jetson.distrib.server/jetson/linux-tegra-r214"
            $link = "{0}/files/{1}" -f $masterlink, $filebasename

            Write-Host "`t`"$n`" added to index file" -f Gray
            $MdStr = "- [{0}]({1})" -f $n, $link
            Add-Content "$indexpath"  -Value $MdStr

            if($DownloadFile){
                Write-Host "`tdownloading asset `"$filebasename`""
                $ProgressPreference = 'SilentlyContinue'
                Invoke-WebRequest -Uri "$u"  -OutFile "$fullfilename" | out-null
                $ProgressPreference = 'Continue'
            }
        }
    }catch{
        Show-ExceptionDetails $_ -ShowStack
    }
}


Invoke-GenerateIndexFromHtml -Url $Url 