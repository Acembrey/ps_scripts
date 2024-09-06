# Andrew Embrey
# 08/19/24
# Scripts that checks if properties exist under Windows Update key in registry, creates if not
function Ensure-RegProp {
    param (
        [string]$registryPath,
        [string]$propertyName,
        [string]$propertyValue,
        [ValidateSet("String", "DWord", "QWord", "Binary", "MultiString", "ExpandString")]
        [string]$propertyType = "String"
    )

    # Check if the registry key exists
    if (-not (Test-Path $registryPath)) {
        Write-Host "Registry path does not exist: $registryPath"
        return
    }

    # Get the registry key properties
    $properties = Get-ItemProperty -Path $registryPath

    # Check if the property exists by using `Get-ItemProperty` and checking for `$null`
    if ($null -eq $properties.PSObject.Properties[$propertyName]) {
        # If the property does not exist, create it
        New-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -PropertyType $propertyType
        Write-Host "Created registry property '$propertyName' with value '$propertyValue' at '$registryPath'"
    } else {
        Write-Host "Property '$propertyName' already exists at '$registryPath'"
    }
}
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

# Properties that seem to be missing
$Prop1 = ""
$Prop2 = ""
$Prop3 = ""
$Prop4 = ""
$Prop5 = ""

# Values to be created for new properties
$CommonValue = ""
$Prop5Value = ""

Ensure-RegProp -registryPath $regPath -propertyName $Prop1 -propertyValue $CommonValue
Ensure-RegProp -registryPath $regPath -propertyName $Prop2 -propertyValue $CommonValue
Ensure-RegProp -registryPath $regPath -propertyName $Prop3 -propertyValue $CommonValue
Ensure-RegProp -registryPath $regPath -propertyName $Prop4 -propertyValue $CommonValue
Ensure-RegProp -registryPath $regPath -propertyName $Prop5 -propertyValue $Prop5Value
