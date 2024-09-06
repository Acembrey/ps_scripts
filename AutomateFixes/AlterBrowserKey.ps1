#   Date:   July 29, 2024
#   Desc:   Script to check if properties exist under browser keys in registry, edit/add necessary properties for appropriate authentication
#           This is the second script I did for this, as using a function here reduced the amount of lines, and made it more readable
#           Could have appended results to csv, but deemed it unnessary. It still prints whether changes needed to be made

# main function handles the checking and alteration to key properties in registry
function Set-RegistryProperty {
    param (
        [string]$RegistryPath,
        [string]$PropertyName,
        [string]$PropertyValue,
        [string]$PropertyType = "String"
    )
    # Check if path exists (i.e if the browser is installed)
    if (Test-Path $RegistryPath) {
        $Properties = Get-ItemProperty $RegistryPath
        if ($Properties.PSObject.Properties[$PropertyName]) {
            $currentValue = $Properties.$PropertyName
            if ($currentValue -ne $PropertyValue) {
                Set-ItemProperty -Path $RegistryPath -Name $PropertyName -Value $PropertyValue
                return 1
            }
        } else {
            New-ItemProperty -Path $RegistryPath -Name $PropertyName -Value $PropertyValue -PropertyType $PropertyType
            return 1
        }
    } else {
        Write-Output "Path does not exist: $RegistryPath"
    }
    return 0
}

# New to using functions, but property values differed depending on browser, so I defined them outside of the function
$ChromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
$AuthSchemesPropertyName = ""
$AllowListPropertyName = ""
$ChromeAuthValue = ""
$EdgeAuthValue = ""
$AllowedServer = ""
$changesMade = 0

# append the return value to the $changesMade variable, if the value was altered by any of the steps, it would let the admin know a change had to be made. This was prior to SCCM deployment, and would be removed once script proved to be functional.
$changesMade += Set-RegistryProperty -RegistryPath $ChromePath -PropertyName $AuthSchemesPropertyName -PropertyValue $ChromeAuthValue
$changesMade += Set-RegistryProperty -RegistryPath $ChromePath -PropertyName $AllowListPropertyName -PrAuthServerAllowlistopertyValue $AllowedServer

$changesMade += Set-RegistryProperty -RegistryPath $EdgePath -PropertyName $AuthSchemesPropertyName -PropertyValue $EdgeAuthValue
$changesMade += Set-RegistryProperty -RegistryPath $EdgePath -PropertyName $AllowListPropertyName -PrAuthServerAllowlistopertyValue $AllowedServer

if ($changesMade -gt 0) {
    Write-Output "$changesMade changes had to be made to registry. Computer should be able to authenticate to <> now."
} else {
    Write-Output "No changes had to be made in registry. If the user is unable to connect to Alloy, this may be a separate problem. Be sure to check their account."
}
