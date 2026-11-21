<#
.SYNOPSIS
    Step 2: create the Trainees security group and add the lab users to it.

.NOTES
    Requires the users from 01-create-users.ps1.
    Next: 03-apply-password-policy.ps1
#>

$group   = "Trainees"
$members = "Trainee25", "Billa", "Jack", "Client1"

if (-not (Get-ADGroup -Filter "Name -eq '$group'")) {
    New-ADGroup -Name $group -GroupScope Global -GroupCategory Security
    Write-Host "Created group $group"
}

Add-ADGroupMember -Identity $group -Members $members
Write-Host "Added $($members -join ', ') to $group"
