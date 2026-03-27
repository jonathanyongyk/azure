# =============================================
#  Add User to Entra Security Group
#  Usage: .\add_user_to_group.ps1 -UserUPN <USER_UPN> -GroupName <GROUP_NAME>
#  Example: .\add_user_to_group.ps1 -UserUPN john@contoso.com -GroupName "SG-Developers"
# =============================================

param(
    [Parameter(Mandatory = $true, HelpMessage = "User Principal Name (e.g. john@contoso.com)")]
    [string]$UserUPN,

    [Parameter(Mandatory = $true, HelpMessage = "Entra Security Group display name")]
    [string]$GroupName
)

$ErrorActionPreference = 'Stop'

# -- Login to Azure --
# Assume you are already connected via Connect-AzAccount
# Connect-AzAccount

# -- Get User Object ID --
try {
    $user = Get-AzADUser -UserPrincipalName $UserUPN
} catch {
    Write-Error "ERROR: Could not find user with UPN: $UserUPN"
    exit 1
}

if (-not $user) {
    Write-Error "ERROR: Could not find user with UPN: $UserUPN"
    exit 1
}

$UserOID = $user.Id
Write-Host "User Object ID: $UserOID"

# -- Get Group Object ID --
try {
    $group = Get-AzADGroup -DisplayName $GroupName
} catch {
    Write-Error "ERROR: Could not find group with name: $GroupName"
    exit 1
}

if (-not $group) {
    Write-Error "ERROR: Could not find group with name: $GroupName"
    exit 1
}

$GroupOID = $group.Id
Write-Host "Group Object ID: $GroupOID"

# -- Add User to Group --
Add-AzADGroupMember -TargetGroupObjectId $GroupOID -MemberObjectId @($UserOID)
Write-Host "User $UserUPN has been added to group: $GroupName"

# -- Verify --
Write-Host ""
Write-Host "---- Current Members of $GroupName ----"
Get-AzADGroupMember -GroupObjectId $GroupOID |
    Select-Object DisplayName, UserPrincipalName |
    Format-Table -AutoSize
