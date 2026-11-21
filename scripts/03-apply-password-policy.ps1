<#
.SYNOPSIS
    Step 3: apply the fine-grained password policy to the Trainees group
    and set the minimum password length to 12.

.NOTES
    The password settings object "Policy for Trainee" must already exist
    (lockout after 4 attempts for 20 minutes, complexity enabled).
    Requires the group from 02-create-group.ps1.
    Next: 04-verify.ps1
#>

$policy = "Policy for Trainee"
$group  = "Trainees"

Add-ADFineGrainedPasswordPolicySubject -Identity $policy -Subjects $group
Set-ADFineGrainedPasswordPolicy -Identity $policy -MinPasswordLength 12
Write-Host "Applied '$policy' to $group with a 12-character minimum"
