#   Date: August 15, 2024
#   Desc: Recurses through Control Set key to find an service paths that are unquoted. Common vulnerability

$ServicePaths = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services"
$notInclude = @("system32*", "C:\Windows*", "\SystemRoot*", "\??*", "*/*", "*-*")

foreach ($ServicePath in $ServicePaths) {
    $ProgramProperties = Get-ItemProperty $ServicePath.PSPath

    if ($ProgramProperties.ImagePath) {
        $exclude = $false
        foreach ($pattern in $notInclude) {
            if ($ProgramProperties.ImagePath -like $pattern) {
                $exclude = $true
                break
            }
        }

        # Check if the ImagePath is not enclosed in double quotes
        if (-not $exclude -and $ProgramProperties.ImagePath -notmatch '^".*"$') {
            $quotedPath = '"' + $ProgramProperties.ImagePath + '"'
            Write-Host "The following service path was quoted: $quotedPath"
        }
    }
}
