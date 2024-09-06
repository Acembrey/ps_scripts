# CertificateOID is used to encrypt external drives with digital certificates from smart cards. This script added the property so BitLocker could use those certs

$regPath = "Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\FVE"
$propertyName = "CertificateOID"
$propertyValue = ""
$propertyType = "String"

$properties = Get-ItemProperty $regPath | ForEach-Object { $_.PSObject.Properties } | Where-Object {$_ -like "*$propertyName*"}
$propertyNames = $properties.Name
$propertyNames

if(-not($propertyNames -contains $propertyName)){
    New-ItemProperty -Path $regPath -PropertyType $propertyType -Name $propertyName -Value $propertyValue
    Get-ItemProperty $regPath
} elseif ($propertyNames -contains $propertyName) {
    Write-Host "Property already exists"
    Get-ItemProperty $regPath
}
