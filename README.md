# Active Directory Lab

A hands-on Active Directory lab in VirtualBox: a Windows Server domain controller, a domain-joined Windows 11 client, users created with PowerShell, a password policy, and a Group Policy screen lock.

## Overview

- Domain controller for `corp.testlab.local` on Windows Server
- Windows 11 client joined to the domain
- Four users created with PowerShell, grouped in a `Trainees` security group
- Fine-grained password policy for the group
- Group Policy Object enforcing a password-protected screen saver

## Environment/SDK/Stack

| Item | Details |
|---|---|
| Virtualization | Oracle VirtualBox |
| Server | Windows Server (domain controller) |
| Client | Windows 11 |
| Tools | PowerShell, Group Policy Management |

## Configuration

| Setting | Value |
|---|---|
| Users | Trainee25, Billa, Jack, Client1 |
| Group | Trainees |
| Minimum password length | 12 characters, complexity on |
| Account lockout | 4 failed attempts, locked for 20 minutes |
| Screen saver lock (GPO) | 600 seconds (10 minutes) |

## Key Commands

```powershell
# Create users
foreach ($u in "Jack","Client1") {
    New-ADUser -Name $u -SamAccountName $u -UserPrincipalName "$u@corp.testlab.local" -AccountPassword $pw -Enabled $true
}

# Create the group and add members
New-ADGroup -Name "Trainees" -GroupScope Global -GroupCategory Security
Add-ADGroupMember -Identity "Trainees" -Members "Trainee25","Billa","Jack","Client1"

# Apply the password policy to the group
Add-ADFineGrainedPasswordPolicySubject -Identity "Policy for Trainee" -Subjects "Trainees"
Set-ADFineGrainedPasswordPolicy -Identity "Policy for Trainee" -MinPasswordLength 12
```

## Verification

```powershell
Get-ADUserResultantPasswordPolicy -Identity Trainee25
gpupdate /force
gpresult /r /scope user
```

The first command confirmed the policy applied through the `Trainees` group. After `gpupdate /force`, `gpresult` listed the GPO under the user's applied policies.

## Troubleshooting Notes

- **VirtualBox setup error** ("Windows cannot find the Microsoft Software License Terms"): skip unattended install and check the ISO.
- **"Cannot find an object with identity":** the users did not exist yet, so I created them first.
- **GPO not showing in `gpresult`:** it needed `gpupdate /force` to refresh.

## Key Takeaway

Password rules come from a fine-grained password policy, while the screen lock comes from a Group Policy Object. They are separate features, and I verified each one instead of assuming it applied.

## Screenshots

Add images here (remove any passwords first).
