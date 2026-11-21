Active Directory Lab
A hands-on Active Directory lab built in VirtualBox: a Windows Server domain controller, a Windows 11 client joined to the domain, users created with PowerShell, a password policy for a security group, and a Group Policy Object for a screen lock.

What I built
Domain controller: Windows Server promoted to a domain controller for the domain corp.testlab.local.
Client: a Windows 11 machine joined to the domain.
Users: four user accounts created with PowerShell (Trainee25, Billa, Jack, Client1).
Security group: Trainees, with the users above as members.
Fine-grained password policy ("Policy for Trainee") applied to the Trainees group:
minimum password length: 12 characters
complexity: enabled
account lockout after 4 failed attempts, locked for 20 minutes
Group Policy Object (CONTOS050 STANDARDS), linked at the domain level: screen saver with a password lock after 600 seconds (10 minutes).
Key commands
Create users (lab password only):

$pw = ConvertTo-SecureString "<lab password>" -AsPlainText -Force
$users = "Jack","Client1"
foreach ($u in $users) {
    New-ADUser -Name $u -SamAccountName $u -UserPrincipalName "$u@corp.testlab.local" -AccountPassword $pw -Enabled $true
}
Create a group and add members:

New-ADGroup -Name "Trainees" -GroupScope Global -GroupCategory Security
Add-ADGroupMember -Identity "Trainees" -Members "Trainee25","Billa","Jack","Client1"
Apply the fine-grained password policy to the group:

Add-ADFineGrainedPasswordPolicySubject -Identity "Policy for Trainee" -Subjects "Trainees"
Set-ADFineGrainedPasswordPolicy -Identity "Policy for Trainee" -MinPasswordLength 12
How I verified it
Get-ADUserResultantPasswordPolicy -Identity Trainee25
Get-ADFineGrainedPasswordPolicySubject -Identity "Policy for Trainee"
gpupdate /force
gpresult /r /scope user
Get-ADUserResultantPasswordPolicy showed "Policy for Trainee" applying to the user through the Trainees group. After gpupdate /force, gpresult listed the Group Policy Object under the user's applied policies.

Fine-grained password policy vs. Group Policy
These are two different features, and I used both:

A fine-grained password policy sets password and lockout rules for specific users or groups. I created it and applied it with PowerShell.
A Group Policy Object (GPO) applies settings to users and computers in a domain or OU. I used one for the screen saver lock.
Problems I ran into and how I fixed them
Windows Server setup failed in VirtualBox ("Windows cannot find the Microsoft Software License Terms"). The usual fix is to skip VirtualBox's unattended install and check the ISO.
Adding a user to the policy failed with "Cannot find an object with identity". The users didn't exist yet, so I created them first.
A multi-line New-ADUser command broke because of a line break, which made PowerShell prompt for a name. Two accidental accounts were created from my answers at the prompt, and I deleted them. Lesson: press Ctrl+C when a command unexpectedly asks for input.
gpresult did not show my GPO at first. It needed gpupdate /force to refresh. After that, the GPO appeared.
What I learned
How a domain controller, a domain, and a joined client fit together.
The difference between a fine-grained password policy and Group Policy.
How to verify what actually applies (Get-ADUserResultantPasswordPolicy, gpresult) instead of assuming.
Screenshots
Add screenshots here (remove any passwords before uploading):

Get-ADUser output showing the created users
Get-ADUserResultantPasswordPolicy output
gpresult /r /scope user output showing the applied GPO
Next steps
Link the GPO to an organizational unit and compare with a domain-level link.
Add more settings to the GPO and test them from the client.
