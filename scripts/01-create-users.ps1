<#
.SYNOPSIS
    Step 1: create the lab user accounts in corp.testlab.local.

.NOTES
    Run on the domain controller in an elevated PowerShell session.
    Prompts for a lab password, so no password is stored in this file.
    Next: 02-create-group.ps1
#>

$domain = "corp.testlab.local"
$users  = "Trainee25", "Billa", "Jack", "Client1"
$pw     = Read-Host "Lab password for the new users" -AsSecureString

foreach ($u in $users) {
    if (Get-ADUser -Filter "SamAccountName -eq '$u'") {
        Write-Host "$u already exists, skipping"
        continue
    }
    New-ADUser -Name $u -SamAccountName $u -UserPrincipalName "$u@$domain" -AccountPassword $pw -Enabled $true
    Write-Host "Created $u"
}
