using module ./Modules/classes.psm1

function main() {

    Begin {
        Import-Module -Force "${PSScriptRoot}\Modules\functions.psm1";

        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null;
        New-PSDrive -Name HKCC -PSProvider Registry -Root HKEY_CURRENT_CONFIG | Out-Null;
        New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null;
        
        [Hive] $Private:Hive = [Hive]::New();
        [System.String] $Private:Drive = "C Drive Stro0123";
        [System.Collections.Generic.List[System.String]] $Private:Users = @('Stro0123','Administrator');
    }

    Process {
        $Hive.SetLocation('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced').SetHives(@{
            'HideFileExt' = 0
            'LaunchFolderWindows' = 1
            'ShowCortanaButton' = 0
            'Hidden' = 1
            'ShowSuperHidden' = 1
            'TaskbarAnimations' = 1
        }).ExecuteHives().SetLocation('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects').SetHives(@{
            'VisualFXSetting' = 2
        }).ExecuteHives().SetLocation('HKLM:\System\ControlSet001\Control\Session Manager\Memory Management').SetHives(@{
            'PagingFiles' = 'c:\pagefile.sys 8096 8096'
        }).ExecuteHives().SetLocation('HKLM:\SYSTEM\ControlSet001\Control\Terminal Server').SetHives(@{
            'fDenyTSConnections' = 0
        }).ExecuteHives().Done();

        if ((Get-Volume -DriveLetter C).FileSystemLabel -ne $Drive) {
            Set-Volume -DriveLetter C -NewFileSystemLabel $Drive;
            Optimize-Volume -FileSystemLabel $Drive;
            Optimize-Volume -FileSystemLabel $Drive -Analyze -Defrag -TierOptimize;
        }


        foreach ($Private:User in $Users) {
            if ( -not ( Get-LocalGroupMember -Group 'Remote Desktop Users' -Member $User -ErrorAction SilentlyContinue)) {
                Add-LocalGroupMember -Group 'Remote Desktop Users' -Member $User;
            }
        }
    }
    
    End {
        Write-Host -ForegroundColor  White -BackgroundColor DarkGreen " All Done :) `n";
        return $null;
    }
}

using module ./Modules/classes.psm1

function main() {

    Begin {
        Import-Module -Force "${PSScriptRoot}\Modules\functions.psm1";

        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null;
        New-PSDrive -Name HKCC -PSProvider Registry -Root HKEY_CURRENT_CONFIG | Out-Null;
        New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null;
        
        [Hive] $Private:Hive = [Hive]::New();
        [System.String] $Private:Drive = "C Drive Stro0123";
        [System.Collections.Generic.List[System.String]] $Private:Users = @('Stro0123','Administrator');
    }

    Process {
        $Hive.SetLocation('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced').SetHives(@{
            'HideFileExt' = 0
            'LaunchFolderWindows' = 1
            'ShowCortanaButton' = 0
            'Hidden' = 1
            'ShowSuperHidden' = 1
            'TaskbarAnimations' = 1
        }).ExecuteHives().SetLocation('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects').SetHives(@{
            'VisualFXSetting' = 2
        }).ExecuteHives().SetLocation('HKLM:\System\ControlSet001\Control\Session Manager\Memory Management').SetHives(@{
            'PagingFiles' = 'c:\pagefile.sys 8096 8096'
        }).ExecuteHives().SetLocation('HKLM:\SYSTEM\ControlSet001\Control\Terminal Server').SetHives(@{
            'fDenyTSConnections' = 0
        }).ExecuteHives().Done();

        if ((Get-Volume -DriveLetter C).FileSystemLabel -ne $Drive) {
            Set-Volume -DriveLetter C -NewFileSystemLabel $Drive;
            Optimize-Volume -FileSystemLabel $Drive;
            Optimize-Volume -FileSystemLabel $Drive -Analyze -Defrag -TierOptimize;
        }


        foreach ($Private:User in $Users) {
            if ( -not ( Get-LocalGroupMember -Group 'Remote Desktop Users' -Member $User -ErrorAction SilentlyContinue)) {
                Add-LocalGroupMember -Group 'Remote Desktop Users' -Member $User;
            }
        }
    }
    
    End {
        Write-Host -ForegroundColor  White -BackgroundColor DarkGreen " All Done :) `n";
        return $null;
    }
}

main;
# SIG # Begin signature block
# MIIGgQYJKoZIhvcNAQcCoIIGcjCCBm4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBHeky/yEDSlaCe
# HnMyXzfgXJw3zZizdpljX2C6/qgpRqCCA6gwggOkMIICjKADAgECAhAe6ommKFuT
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
# FTAvBgkqhkiG9w0BCQQxIgQg8isc2lWNJoQ6u/pvdFJ8ben6v9C4LwsfFpKPUWu3
# ATAwDQYJKoZIhvcNAQEBBQAEggEAvzi6EQ6RJMokssbUpR1HyxoMrA0UXKoovXGc
# oiFSmgVulO13ZFhoibrV0FX7B4IUihjcbJDlyZS4NyWF+PISkVXST82+4la4gpim
# 5ogBpixRyqyNqKe00yRZkqE2Ad41sPF1urkSKc7P2Hz6bts5ALWND5w5uOXhYhN0
# j54yyOLXj0v2kkpDSr8NklBroKZSRlkKKE1IPt2iDzKAOftmP8Yr6O1cQZ3LqKmr
# qMspjwsBWDO1Jc3it6klNtx3UFrgMvjd9FjqjHwIP3UK/BdZv8RxqEvgB6iMKf9U
# 2hYnU1Y0Xi6/dsqXoQnK0EkOfXV4bjB2NhPjTy0XZQwYpAi97A==
# SIG # End signature block
