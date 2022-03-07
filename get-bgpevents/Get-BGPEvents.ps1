$ProgressPreference = 'SilentlyContinue'
$InformationPreference = 'SilentlyContinue'
[string]$varPath = $env:OneDrive +"\VS Code Workspace\set-genericfactoid\get-bgpevents\jsonconfigs\"
[string]$filePossibleHijack = "PossibleHijack.json"
[string]$fileBGPLeak = "BGPLeak.json"
[string]$filePossibleHijackOld = "PossibleHijackOld.json"
[string]$fileBGPLeakOld = "BGPLeakOld.json"
[string]$filePossibleHijackOneRecord = "PHJ1.json"
[string]$fileBGPLeakOneRecord = "BGPL1.json"
[string]$outPossibleHijack = $varPath + $filePossibleHijack
[string]$outBGPLeak = $varPath + $fileBGPLeak
[string]$outPossibleHijackold = $varPath + $filePossibleHijackold
[string]$outBGPLeakold = $varPath + $fileBGPLeakold
[string]$outPHJ1 = $varPath + $filePossibleHijackOneRecord
[string]$outBGPL1 = $varPath + $fileBGPLeakOneRecord
if ((test-path $outPossibleHijackold) -eq $True)
    {
        Remove-Item $outPossibleHijackold
    }
if ((test-path $outBGPLeakold) -eq $True)
    {
        Remove-Item $outBGPLeakold
    }
if ((test-path $outPossibleHijack) -eq $True)
    {
        Move-Item $outPossibleHijack $outPossibleHijackold
        new-item -ItemType file -path $outPossibleHijack
    }
else 
    {
        new-item -ItemType file -path $outPossibleHijack
    }
if ((test-path $outBGPLeak) -eq $true)
    {
        Move-Item $outBGPLeak $outBGPLeakold
        new-item -ItemType file -path $outBGPLeak
    }
else 
    {
        new-item -ItemType file -path $outBGPLeak
    }
if ((test-path $outPossibleHijackold) -eq $False)
    {
        new-item $outPossibleHijackold
        [DateTime]$dateStart = ([datetime]::Now).AddDays(-1000)
        $myObj = new-object psobject
        $myObj | add-member -MemberType NoteProperty -Name "StartTime" -value $dateStart
        $myObj | Add-Member -MemberType NoteProperty -Name "URL" -value "https://bgpstream.com"
        $myObj | add-member -MemberType NoteProperty -Name "Description" -value "Dummy Data"
        $myObj | ConvertTo-Json | Out-File $outPossibleHijackold
    }
if ((test-path $outBGPLeakold) -eq $False)
    {
        New-Item $outBGPLeakold
        [DateTime]$dateStart = ([datetime]::Now).AddDays(-1000)
        $myObj = new-object psobject
        $myObj | add-member -MemberType NoteProperty -Name "StartTime" -value $dateStart
        $myObj | Add-Member -MemberType NoteProperty -Name "URL" -value "https://bgpstream.com"
        $myObj | add-member -MemberType NoteProperty -Name "Description" -value "Dummy Data"
        $myObj | ConvertTo-Json | Out-File $outBGPLeakold
    }
$uriBGPStream = @(); $arrColumnName = @(); $arrDataResult = @(); $arrTableRow = @(); $arrFinalResult = @();
$arrDataResult = New-Object System.Collections.ArrayList;
$arrColumnName = New-Object System.Collections.ArrayList;
$arrFinalResult = New-Object System.Collections.ArrayList;
$arrPossibleHijack = New-Object System.Collections.ArrayList;
$arrBGPLeak = New-Object System.Collections.ArrayList;
$arrTableRow = New-Object System.Collections.ArrayList;
$arrContent = New-Object System.Collections.ArrayList;
[string]$strURI = "https://bgpstream.com/";
$uriBGPStream = Invoke-WebRequest -Uri $strURI;
$arrColumnName = $uriBGPStream.ParsedHtml.getElementsByTagName("TH") | ForEach-Object { $_.innerText -replace "^\s*|\s*$" }
[int64]$intColumnCount = $arrColumnName.Count
$arrTableRow = $uriBGPStream.ParsedHtml.getElementsByTagName("TR")
$arrContent = $arrTableRow | ForEach-Object {
    $_.getElementsByTagName("TD") 
} 
#$arrContent.Add(($arrTableRow | ForEach-Object {$_.getElementsByTagName("TD")}))
#$arrContent.Add((($uriBGPStream.ParsedHtml.getElementsByTagName("TR")) | ForEach-Object {$_.getElementsByTagName("TD")}))
$arrOuterHtml = $arrContent.outerHtml
[int64]$i = 0
foreach ($a in $arrOuterHtml)
    {
        #Get Event_Type
        if ($a -match '(\<TD\sclass\=)(?<p1>event_type)(\>)(?<q1>.*)(\<\/TD\>)')
            {
                [string]$strEvtType = "Event_Type"
                [string]$strEvtTypeValue = $Matches.q1
                $splatALL = @{
                    $strEvtType = $strEvtTypeValue
                    #"ID" = $i
                }
                $arrDataResult.Add($splatALL)
            }
        #Get Country
        elseif ($a -match '(\<TD\sclass\=)(?<p2>country)(\>)(?<q2>.*)(\<\/TD\>)')
            {
                [string]$strCountry = "Country"
                [string]$strCountryValue = $Matches.q2
                $splatALL = @{
                    $strCountry = $strCountryValue
                    #"ID" = $i
                }
                $arrDataResult.Add($splatALL)
            }
        #Get ASN
        elseif ($a -match '(\<TD\sclass\=)(?<p3>asn)(\>)(?<q3>.*)(\<\/TD\>)')
            {
                [string]$strASN = "ASN"
                [string]$strASNValue = $Matches.q3
                $splatALL = @{
                    $strASN = $strASNValue
                    #"ID" = $i
                }
                $arrDataResult.Add($splatALL)
            }
        #Get StartTime
        elseif ($a -match '(\<TD\sclass\=)(?<p4>starttime)(\>)(?<q4>.*)(\<\/TD\>)')
            {
                [string]$strstime = "StartTime"
                [string]$strstimeValue = $Matches.q4
                $splatALL = @{
                    $strstime = $strstimeValue
                    #"ID" = $i
                }
                $arrDataResult.Add($splatALL)
            }
        #Get EndTime
        elseif ($a -match '(\<TD\sclass\=)(?<p5>endtime)(\>)(?<q5>.*)(\<\/TD\>)')
            {
                [string]$stretime = "EndTime"
                [string]$stretimeValue = $Matches.q5
                $splatALL = @{
                    $stretime = $stretimeValue
                    #"ID" = $i
                }
                $arrDataResult.Add($splatALL)
            }
        #Get MoreDetail
        elseif ($a -match '(\<TD\sclass\=)(?<p6>moredetail)(\>)(\<A\shref\=\"\/event\/)(?<q6>\d*)(\"\>.*\<\/TD\>)')
            {
                [string]$strMD = "MoreDetail"
                [string]$strMDValue = $Matches.q6
                [string]$strEventURL = $strURI + "event/" + $strMDValue
                $splatALL = @{
                    $strMD = $strEventURL
                    #"ID" = $i
                }
                $arrDataResult.Add($splatALL)
            }
        $i++         
    }
<# 
Okay, so now everything is tucked inside $arrdataresult
PS C:\Users\chuck\OneDrive\VS Code Workspace\BGP> $arrDataResult[0]
Name                           Value
----                           -----
ID                             0
Event_Type                     Outage
PS C:\Users\chuck\OneDrive\VS Code Workspace\BGP> $arrDataResult[1]
Name                           Value
----                           -----
Country
ID                             1
PS C:\Users\chuck\OneDrive\VS Code Workspace\BGP> $arrDataResult[2]
Name                           Value
----                           -----
ASN                            NEWS TELECOM LTDA, BR (AS 265010)
ID                             2

Now i need to count every 6. 
/#>
[int64]$intDataResultCount = $arrDataResult.Count
[int64]$intCounter = ( $intColumnCount -1 )
#Break table data into smaller chuck of data.
[int64]$ii = 0
$splatALL = $null
for ($i = 0; $i -le $intDataResultCount; $i+=$intCounter) #$i+= ($thead.count - 1))
    {
        if ($intDataResultCount -eq $i)
            {
                break
            } 
        if ($value.starttime)
            {
                $varSTIME = ($value.starttime).ToDateTime($_)
            }
        else 
            {
                $varSTIME = $null
            }
       $count = $i + $intCounter
       $value = $null; $value = $arrDataResult[$i..$count]
       [hashtable]$splatAll = [ordered]@{
           "ID" = $ii
           [string]"EventType" = $value.event_type
           [string]"Country" = $value.country
           [string]"ASN" = $value.ASN
           "StartTime" = $varSTIME
           "EndTime" = $value.endtime
           [string]"URL" = $value.moredetail
       }
       $arrFinalResult.Add($splatALL)
       $ii++
    }
# Get rid of null junk
$arrFinalResult = $arrFinalResult | Where-Object {$_.ID -ne $null}
# Parsing stuff
$arrPossibleHijack = $arrFinalResult | Where-Object {$_.EventType -match "Possible Hijack"}
$arrBGPLeak = $arrFinalResult | Where-Object {$_.EventType -match "BGP Leak"}
$arrFinalPossibleHijack = New-Object System.Collections.ArrayList; 
$arrFinalBGPLeak = New-Object System.Collections.ArrayList; 
$a = $null
foreach ($a in $arrPossibleHijack)
    {
        if (($a).StartTime)
        {
            [DateTime]$dateStart = ($a.StartTime).ToDateTime($_)
            $myObj = new-object psobject
            $myObj | add-member -MemberType NoteProperty -Name "StartTime" -value $dateStart
            $myObj | Add-Member -MemberType NoteProperty -Name "URL" -value $a.URL
            $myObj | add-member -MemberType NoteProperty -Name "Description" -value $a.ASN
            $arrFinalPossibleHijack.Add($myObj); 
        }
    else 
        {
        }
    }
$a = $null;
foreach ($a in $arrBGPLeak)
    {
        if (($a).StartTime)
        {
            [DateTime]$dateStart = ($a.StartTime).ToDateTime($_)
            $myObj = new-object psobject
            $myObj | add-member -MemberType NoteProperty -Name "StartTime" -value $dateStart
            $myObj | Add-Member -MemberType NoteProperty -Name "URL" -value $a.URL
            $myObj | add-member -MemberType NoteProperty -Name "Description" -value $a.ASN
            $arrFinalBGPLeak.Add($myObj); 
        }
    else 
        {
        }
    }
#Sort the New Arrays
$arrFinalPossibleHijack = $arrFinalPossibleHijack | sort-object StartTime -Descending
$arrFinalBGPLeak = $arrFinalBGPLeak | sort-object StartTime -Descending
# Export a copy to json formatted txt file
$arrFinalPossibleHijack | ConvertTo-Json | Out-File $outPossibleHijack
$arrFinalBGPLeak | ConvertTo-Json | Out-File $outBGPLeak
# Load the old data
$hijackold = gc $outPossibleHijackold | ConvertFrom-Json | Sort-Object StartTime -Descending
$bgpleakold = gc $outBGPLeakold | ConvertFrom-Json | Sort-Object StartTime -Descending
# Check to see if we have a new alert
$new = $arrFinalPossibleHijack[0]
$old = $hijackold[0]
if ($new.StartTime -gt $old.StartTime)
    {
        write-host "New StartTime is more recent than Old StartTime "
        write-host "Generating Output"
        $new | ConvertTo-Json | Out-File $outPHJ1

    }
elseif ($new.StartTime -lt $old.StartTime)
    {
        write-host "New StartTime is less than Old StartTime "
    }
elseif ($new.StartTime -eq $old.StartTime)
    {
        write-host "New StartTime is equal to Old StartTime "
    }
$new = $null ; $old = $null
$new = $arrFinalBGPLeak[0]
$old = $bgpleakold[0]
if ($new.StartTime -gt $old.StartTime)
    {
        write-host "New StartTime is more recent than Old StartTime "
        write-host "Generating Output"
        $new | ConvertTo-Json | Out-File $outBGPL1

    }
elseif ($new.StartTime -lt $old.StartTime)
    {
        write-host "New StartTime is less than Old StartTime "
    }
elseif ($new.StartTime -eq $old.StartTime)
    {
        write-host "New StartTime is equal to Old StartTime "
    }