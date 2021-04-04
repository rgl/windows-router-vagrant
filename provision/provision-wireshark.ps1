choco install -y wireshark

Import-Module C:\ProgramData\chocolatey\helpers\chocolateyInstaller.psm1
Install-ChocolateyShortcut `
    -ShortcutFilePath "$env:USERPROFILE\Desktop\Wireshark.lnk" `
    -TargetPath 'C:\Program Files\Wireshark\Wireshark.exe'

# leave npcap on the desktop for the user to install manually.
# (it does not have a silent installer).
# see https://github.com/nmap/npcap/releases
$url = 'https://nmap.org/npcap/dist/npcap-1.20.exe'
$expectedHash = 'ef8113e595694a14d35bd31043ed6ea73ac5793cf53985ae950f4e65b406e363'
$localPath = "$env:USERPROFILE\Desktop\$(Split-Path -Leaf $url)"
(New-Object Net.WebClient).DownloadFile($url, $localPath)
$actualHash = (Get-FileHash $localPath -Algorithm SHA256).Hash
if ($actualHash -ne $expectedHash) {
    throw "downloaded file from $url to $localPath has $actualHash hash that does not match the expected $expectedHash"
}
