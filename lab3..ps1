using module ./Modules/classes.psm1

function Invoke-Main() {

    Begin {
        Import-Module -Force "${PSScriptRoot}\Modules\functions.psm1";
        Import-Module -Force "${PSScriptRoot}\Modules\lab-functions.psm1";
        Use-WindowsFeature -Features @('GPMC', 'DNS','AD-Domain-Services');
        Add-Modules -Modules @('GroupPolicy','7Zip4PowerShell','DNS','ADDSDeployment','ActiveDirectory');
        
        [System.Object[]] $Private:__Root = ((Get-ADOrganizationalUnit -Filter * | Select-Object -Property DistinguishedName | Where-Object -Property DistinguishedName -Like "*Domain Controllers*").DistinguishedName.Split(','));
        [System.String] $Private:__Distinguished_Name_Root = "";

        for ($Private:__Index = 1; ${__Index} -lt ${__Root}.Count; ${__Index}++) {
            $__Distinguished_Name_Root += ",$(${__Root}[${__Index}])";
        }

        ### Defined the OUs ###
        [System.Collections.Hashtable] $Private:__Organizational_Units = @{
            LTS = "$(${__Distinguished_Name_Root}.Substring(1))";
            HelpDesk = "OU=LTS${__Distinguished_Name_Root}";
            Development = "OU=LTS${__Distinguished_Name_Root}";
            CustSupport = "OU=LTS${__Distinguished_Name_Root}";
        };

        foreach ($Private:__Organizational_Unit in $__Organizational_Units.Keys) {
            if ($null -eq (Get-aDOrganizationalUnit -Filter * | Select-Object -Property Name | Where-Object -Property Name -eq ${__Organizational_Unit})) {
                New-ADOrganizationalUnit -Name "${__Organizational_Unit}" -Path "$(${__Organizational_Units}.${__Organizational_Unit})";
            } else {
                Get-Message -Type Information -Message "The '${__Organizational_Unit}' already exists at $(${__Organizational_Units}.${__Organizational_Unit}).";
            }
        }

        Remove-Variable -Name __Root;
        Update-OrganizationalUnit -OuPath 'LTsS' -GetRoot
        [System.Security.SecureString] $Private:__Password = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force;

# Update-OrganizationalUnit -Action Get

<#
        ### Defined the Users ###
        [System.Collections.Hashtable] $Private:__Users = @{
            "ITSAdmin" = 'LTS';
            "HDUser" = 'HelpDesk';
            "DevUser" = 'Development';
            "CSUser" = 'CustSupport';
        }
        foreach ($Private:__User in $__Users.Keys) {
            Write-Host ${__Organizational_Units}.$(${__Users}.${__User});
        }

        # Loop through each OU and user name
        #for ($i = 0; $i -lt $OUs.Count; $i++) {
          # Create the user account
        #  New-ADUser -Name $UserNames[$i] -GivenName $OUs[$i] -Surname "User" -DisplayName "$($OUs[$i]) User" -UserPrincipalName "$($UserNames[$i])@contoso.com" -Path "OU=$($OUs[$i]),DC=contoso,DC=com" -AccountPassword $Password -PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true
   #     }
        #        Get-ADOrganizationalUnit -Filter * | Select-Object -Property Name | Where-Object -Property Name -eq        
#>

    }
}

Invoke-Main;
# SIG # Begin signature block
# MIIGgQYJKoZIhvcNAQcCoIIGcjCCBm4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBl0EgY3AVMXr3L
# h2hd0BdrlUxbTxmSienENJHRenZHpaCCA6gwggOkMIICjKADAgECAhAe6ommKFuT
# qEWRmELrgk40MA0GCSqGSIb3DQEBBQUAMGkxDzANBgNVBAYTBkNhbmFkYTEQMA4G
# A1UECAwHT250YXJpbzEhMB8GA1UECwwYQWRtaW5pc3RyYXRvcnMgIEw9T3R0YXdh
# MSEwHwYDVQQDDBhDb2RlIFNpZ25pbmcgQ2VydGlmaWNhdGUwIBcNMjIwNzAxMDQw
# MDAwWhgPMzIxMDAxMDUwNDAwMDBaMGkxDzANBgNVBAYTBkNhbmFkYTEQMA4GA1UE
# CAwHT250YXJpbzEhMB8GA1UECwwYQWRtaW5pc3RyYXRvcnMgIEw9T3R0YXdhMSEw
# HwYDVQQDDBhDb2RlIFNpZ25pbmcgQ2VydGlmaWNhdGUwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQDHucjdXvXBIaN98BDNte0V2zGS9Uf4QnE8MCguG0L2
# toBn5vIs60jbBONvoKnC1pMiFWqyaqHBdKwSGo1RrjyXFW/Nz4rCUonjhPq8L29D
# 5spRTwza0eaPSTwdKMQ6TzE6Ln04YKrQIRz4HsTIThnVQ+OkVy3uzaYJsX1PVUyn
# S1T7MJib6pPaB1QeCiCC2SQRmL6prtzsS0ZE5eCXM9yC7KYT304kkzH5zJIbQPkS
# n5cAixJ4c4Zv8iETrbLyO1puxKk2f2Ksik3g3Z+N/doc5mi1dkEERMwiwZ7/W/oe
# AglSicy1/XsaMRRl8g5NcoSTvBb0wjG9Gw9uUOfUW1C5AgMBAAGjRjBEMA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUx4WyWofC
# yyu7G1p+VWydNCHssCkwDQYJKoZIhvcNAQEFBQADggEBAKPGajbUBAbp11e7tddp
# rXCXhe4SKUQjcgU28h7gXDAAFKZL7w5Uw8tS3haMCPbk5Qs8iKs4z7Kgv6Y/grDE
# Q8khgCcaF2leukStzmJwqyM5NidvNKXjmOy7Q4Cd1drn2jW6a06QDT64wHC5ENud
# Xnl27B8Hm6pkC0DzWUHwIuBHAu4yj5sES/24SqiylaZO1YRtks/yQvx4QuDhn4ef
# Q5TQsPNPC4d79zulF+KDTGaKt5K8vGkeQtkmZvCUzuc1/WWNEq+WetSxmMp5TnFJ
# pTvhFaq0HFRoThkptKkIK8DXk+XjTN618x2hLDrC7pKxDMTQ23pwr5w9MsutOJ0m
# B1IxggIvMIICKwIBATB9MGkxDzANBgNVBAYTBkNhbmFkYTEQMA4GA1UECAwHT250
# YXJpbzEhMB8GA1UECwwYQWRtaW5pc3RyYXRvcnMgIEw9T3R0YXdhMSEwHwYDVQQD
# DBhDb2RlIFNpZ25pbmcgQ2VydGlmaWNhdGUCEB7qiaYoW5OoRZGYQuuCTjQwDQYJ
# YIZIAWUDBAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG
# 9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIB
# FTAvBgkqhkiG9w0BCQQxIgQghl7/D9kMoATmjIoPWJnli1pc8ObeOh+YHlxhDVb5
# USgwDQYJKoZIhvcNAQEBBQAEggEAxHU9eYSzaEyXNrAtRiuJ4YPw1+YI9jFSEEmq
# EqgwW+LZxiUauZ40PbabmL6x7ZjYKrRP+UBhMXutp4LTMfnuDzYEMzmWwWX92foB
# nK4TCuOBdw9UpB1ko+6SbXxM8LZs2/5a4ncml4JsnC2yEcuZgQGp+91vtlW2Jinv
# XBNW7rQppbFQZXCuFcr1itACzYrv4XZR53CiuKBY6FAxTBtvQU4k3OyLsXu4yWTq
# IvsPvKwfpKrjEueLwQDfNqDnfqrqxbmLT/Iox20dgXoLhb8BVtlHPA9TNnF3mdUG
# 7Nr3wRdY7NIeEQZKmFJ2vG8j+5+8AIBZLg2SWROvrQx/5E9c8g==
# SIG # End signature block
