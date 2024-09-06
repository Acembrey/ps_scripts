#   Date: May 15, 2024
#   Part of a larger script, .NET does not play nice with SCCM deployment options, checks version of .NET in registry.

function Get-DotNetFrameworkVersions {
    $frameworks = @()

    # Registry paths for .NET Framework versions
    $regPaths = @(
        "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP",
        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP"
    )

    foreach ($regPath in $regPaths) {
        $keys = Get-ChildItem -Path $regPath -Recurse | Where-Object { $_.PSChildName -match '^(v\d+(\.\d+)?(Full)?)$' }
        foreach ($key in $keys) {
            $version = $null
            $install = $null
            if ($key.GetValue("Version")) {
                $version = $key.GetValue("Version")
            }
            if ($key.GetValue("Install")) {
                $install = $key.GetValue("Install")
            }

            if ($version -and $install -eq 1) {
                $frameworks += [PSCustomObject]@{
                    Version = $version
                    Path    = $key.PSPath
                }
            }
        }
    }

    return $frameworks
}

# Retrieve .NET Framework versions
$dotNetVersions = Get-DotNetFrameworkVersions

# Display the results
if ($dotNetVersions) {
    Write-Output "Installed .NET Framework Versions:"
    $dotNetVersions | ForEach-Object {
        Write-Output "Version: $($_.Version) - Path: $($_.Path)"
    }
} else {
    Write-Output "No .NET Framework versions found."
}
