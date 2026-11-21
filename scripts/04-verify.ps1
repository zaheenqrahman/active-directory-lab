<#
.SYNOPSIS
    Step 4: verify the users, group, password policy, and Group Policy.

.NOTES
    Run on the domain controller. The gpresult check shows the Group Policy
    Object (the screen lock, created in Group Policy Management) once refreshed.
#>

Write-Host "`n== Users =="
Get-ADUser -Filter * | Select-Object Name, SamAccountName

Write-Host "`n== Trainees group members =="
Get-ADGroupMember -Identity "Trainees" | Select-Object Name

Write-Host "`n== Policy subjects =="
Get-ADFineGrainedPasswordPolicySubject -Identity "Policy for Trainee"

Write-Host "`n== Policy that applies to Trainee25 =="
Get-ADUserResultantPasswordPolicy -Identity Trainee25 |
    Select-Object MinPasswordLength, ComplexityEnabled, LockoutThreshold, LockoutDuration

Write-Host "`n== Group Policy (refresh, then show applied GPOs) =="
gpupdate /force
gpresult /r /scope user
