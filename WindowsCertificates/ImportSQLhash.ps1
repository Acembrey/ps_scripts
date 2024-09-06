# Organization at the time did not have central SQL for certain applications. Machines would generate a Self signed.
# This script just ensures that the machine is utilizing the signed cert provided by org for SQL

$cert = Get-ChildItem -Recurse "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\" | Where PSPath -Like "*SuperSocketNetLib" | Where Property -Contains "Certificate"
$Name = 'Certificate'
$Value = Get-ChildItem Cert:\LocalMachine\My\ | Where issuer -EQ "" | Sort NotAfter -Descending
if ($Value.count -gt 1)
{
        $Value = $Value[0]
}
    If (Test-Path (($cert.Name).Replace('HKEY_LOCAL_MACHINE','HKLM:'))) {
         Set-ItemProperty -Path $cert -Name $Name -Value $Value.Thumbprint -PropertyType REG_SZ -Force
    }
         
net stop MSSQL$TEW_SQLEXPRESS
net start MSSQL$TEW_SQLEXPRESS
