Import-Module ActiveDirectory -WhatIf

$domain = "Thompsonshotel.nl"
$group = Import-Csv -Delimiter ";" -Path "C:\Scripts\groepen.csv" 

# Create Active Directory groups
ForEach ($item In $group) { 
    $create_group = New-ADGroup -Name $item.GroupName -GroupCategory $item.GroupCategory -GroupScope $item.GroupScope
    Write-Host -ForegroundColor Green "Group $($item.GroupName) created!" 
}

# Add users to Active Directory groups
ForEach ($user in $group) {
    $memberOf = Get-ADUser -Identity $user -Properties MemberOf | Select-Object -ExpandProperty MemberOf
    Add-ADGroupMember -Identity $user.GroupName -Members $memberOf
}

# Create Active Directory group folders on D drive
ForEach ($item In $group) { 
    $create_folder = New-Item -ItemType Directory -Path "D:\$domain\$($item.GroupName)" -Force
    Write-Host -ForegroundColor Green "Folder $($item.GroupName) created!" 
}

# Add permissions to Active Directory group folders on D drive
ForEach ($item in $group) { 
    $Acl = Get-Acl "D:\$domain\$($item.GroupName)"
    $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($item.GroupName,"Write","ReadAndExecute","Allow")
    $Acl.SetAccessRule($Ar)
    Set-Acl "D:\$domain\$($item.GroupName)" $Acl
    Write-Host -ForegroundColor Green "Permissions $($item.GroupName) added!" 
}
    else 
    { Write-Host -ForegroundColor Red "permissions $($item.GroupName) failed" }













