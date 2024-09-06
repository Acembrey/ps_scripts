# Dated script, left as is to see how I used to script something like this
# Used to add ENV: variables to allow communication to server, and alter temp directory to bypass ENS temporarily

$rootPath = ""
$newTMPdir = ""

# See if programinstall exists, if it does, check if scratch already exists. If not for either, create the directories. 
if(Test-Path $rootPath){
    $checkPath = Test-Path ""
    if(-not ($checkPath)){
        New-Item -ItemType Directory $newTMPdir
    } else {
        Write-Host "Directory: $newTMPdir already exists."
    }
} else {
    New-Item -ItemType Directory $newTMPdir
}

# Set user variables for the temp directory
[System.Environment]::SetEnvironmentVariable('TEMP', '$newTMPdir', [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('TMP', '$newTMPdir', [System.EnvironmentVariableTarget]::User)

# Set system variable for the license servers
[System.Environment]::SetEnvironmentVariable('', '', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('', '', [System.EnvironmentVariableTarget]::Machine)
