# Download and install Google Chrome on Windows
#

$chromeUrl = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$installerPath = "$env:TEMP\googlechromestandaloneenterprise64.msi"

Write-Host "Downloading Google Chrome MSI installer..."
Invoke-WebRequest -Uri $chromeUrl -OutFile $installerPath -UseBasicParsing

if (Test-Path $installerPath) {
    Write-Host "Download successful. Installing Google Chrome..."
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait
    Remove-Item -Path $installerPath -Force
    Write-Host "Google Chrome has been installed successfully."
} else {
    Write-Host "Failed to download the Chrome installer. Please check your internet connection or the URL."
}
