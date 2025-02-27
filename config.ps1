# Load the JSON configuration file
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

# Define the serial port and baud rate
$portName = $config.portName  # Read portName from the JSON configuration
$baudRate = 115200   # Replace with the appropriate baud rate

# Open the serial port
$serialPort = New-Object System.IO.Ports.SerialPort $portName, $baudRate, "None", 8, "One"
$serialPort.Open()

# Function to send a command over the serial port
function Send-Command {
    param (
        [string]$command
    )
    $serialPort.WriteLine($command)
    Start-Sleep -Milliseconds 100
}

# Function to send file content over the serial port
function Send-FileContent {
    param (
        [string]$filePath
    )
    $content = Get-Content -Raw -Path $filePath
    $serialPort.WriteLine($content)
    Start-Sleep -Milliseconds 500
}

# Define the URL and destination folder
$url = "https://www.amazontrust.com/repository/SFSRootCAG2.pem"
$certsFolder = "certs"
$fileName = "SFSRootCAG2.pem"
$filePath = Join-Path $certsFolder $fileName

# Create the certs folder if it doesn't exist
if (-not (Test-Path -Path $certsFolder)) {
    New-Item -ItemType Directory -Path $certsFolder
}

# Download the file
Invoke-WebRequest -Uri $url -OutFile $filePath
Write-Host "Downloaded $fileName to $certsFolder"

Write-Host "reset"
Send-Command "reset"

Start-Sleep 1

# Send the specified commands from the JSON configuration
Write-Host "Setting mqtt_endpoint $($config.mqtt_endpoint)"
Send-Command "conf set mqtt_endpoint $($config.mqtt_endpoint)"

Write-Host "Setting mqtt_port $($config.mqtt_port)"
Send-Command "conf set mqtt_port $($config.mqtt_port)"

Write-Host "Setting wifi_ssid $($config.wifi_ssid)"
Send-Command "conf set wifi_ssid $($config.wifi_ssid)"

Write-Host "Setting wifi_credential $($config.wifi_credential)"
Send-Command "conf set wifi_credential $($config.wifi_credential)"

Write-Host "commit"
Send-Command "conf commit"

Start-Sleep 2

Write-Host "Setting AWS Root CA"
Send-Command "pki import cert root_ca_cert"
Send-FileContent $config.root_ca_cert

Start-Sleep 2

Write-Host "reset"
Send-Command "reset"

# Close the serial port
$serialPort.Close()
