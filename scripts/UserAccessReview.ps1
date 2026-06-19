<#
.SYNOPSIS
    Generates a CSV report of Active Directory users and their group memberships.

.DESCRIPTION
    This script simulates an IAM user access review by exporting each user in the
    SKCorp Users OU and listing their assigned AD security groups.
#>

Import-Module ActiveDirectory

$ReportPath = "C:\Reports\UserAccessReview.csv"
$SearchBase = "OU=Users,OU=SKCorp,DC=skcorp,DC=local"

if (-not (Test-Path "C:\Reports")) {
    New-Item -ItemType Directory -Path "C:\Reports" | Out-Null
}

Get-ADUser -Filter * -SearchBase $SearchBase | ForEach-Object {
    $Groups = Get-ADPrincipalGroupMembership $_ | Select-Object -ExpandProperty Name

    [PSCustomObject]@{
        User   = $_.SamAccountName
        Groups = ($Groups -join ", ")
    }
} | Export-Csv $ReportPath -NoTypeInformation

Write-Host "User access review report created at $ReportPath"
