$ConfigFile = "aria2.conf"
$TrackersFile = "trackers_all.txt"
$DownloadLink = "https://ngosang.github.io/trackerslist/trackers_all.txt"

Invoke-WebRequest -Uri $DownloadLink -OutFile $env:TEMP\$TrackersFile

$TrackersStream = (Get-Content $env:TEMP\$TrackersFile -Raw).Replace("`n`n", ",").Insert(0, "bt-tracker=")
$TrackersStream = $TrackersStream.Substring(0, $TrackersStream.Length - 1)

$ExcludeLineNum=(Select-String -Path $ConfigFile -SimpleMatch "bt-tracker=").LineNumber
$ConfigStream = Get-Content $ConfigFile
$ConfigStream[$ExcludeLineNum-1]=$TrackersStream
Set-Content -Path $ConfigFile -Value $ConfigStream -Encoding Default

Remove-Item -Path $env:TEMP\trackers*


./aria2c --conf-path=aria2.conf