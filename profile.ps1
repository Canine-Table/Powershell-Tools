Import-Module -Force "${PSScriptRoot}\Modules\functions.psm1";

Set-Values -Value 'Value' -Noun 'Alias' -Arguments @{
    Scope = 'Global';
    Force = $true;
    Option = 'AllScope';
} -Items @{
    p = 'Get-Location';
    l = 'Get-ChildItem';
    h = 'Get-History';
    vi = 'vim'
}

Set-Values -Value 'Value' -Noun 'Variable' -Arguments @{
    Force = $true;
    Visibility = 'Public';
    Option = 'ReadOnly';
    Scope = 'Global';
} -Items @{
    ESC = "$([char] 0x1B)";
    TRANSCRIPTS = "${env:USERPROFILE}\Transcript";
    HISTORY = "${env:USERPROFILE}\Transcript\Microsoft.PowerShell_history.log";
    LOG = "${env:USERPROFILE}\Transcript\$(Split-Path -Path "${PROFILE}" -LeafBase).log";
}

Set-Values -Noun 'PSDrive' -Value 'Root' -Arguments @{
    Scope = 'Global';
    PSProvider = 'Registry';
} -Items @{
    HKCR = 'HKEY_CLASSES_ROOT';
    HKCC = 'HKEY_CURRENT_CONFIG';
    HKU = 'HKEY_USERS';
}

if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $host.ui.RawUI.WindowTitle = "  \(^o^)/  𝐑𝐮𝐧𝐧𝐢𝐧𝐠 𝐖𝐢𝐧𝐝𝐨𝐰𝐬 𝐏𝐨𝐰𝐞𝐫𝐒𝐡𝐞𝐥𝐥 𝐕𝐞𝐫𝐬𝐢𝐨𝐧 𝟕 𝐚𝐬 𝐚𝐧 𝐀𝐝𝐦𝐢𝐧𝐢𝐬𝐭𝐫𝐚𝐭𝐨𝐫  \(^o^)/"; 
} else {
    $host.ui.RawUI.WindowTitle = "  ┻━┻ ︵ ヽ(°□°ヽ)  𝐑𝐮𝐧𝐧𝐢𝐧𝐠 𝐖𝐢𝐧𝐝𝐨𝐰𝐬 𝐏𝐨𝐰𝐞𝐫𝐒𝐡𝐞𝐥𝐥 𝐕𝐞𝐫𝐬𝐢𝐨𝐧 𝟕 𝐚𝐬 𝐚 𝐒𝐭𝐚𝐧𝐝𝐚𝐫𝐝 𝐔𝐬𝐞𝐫  (╯°□°)╯︵ ┻━┻";
}

if ( -not (Test-Path -LiteralPath "${TRANSCRIPTS}" -Type Container -ErrorAction SilentlyContinue)) {
    New-Item -Path "${TRANSCRIPTS}" -Type Directory -Force;
}

if ( -not (Test-Path -LiteralPath "${LOG}\" -Type Leaf -ErrorAction SilentlyContinue)) {
    New-Item -Path "${TRANSCRIPTS}" -Name "$(Split-Path  "${LOG}" -Leaf)" -Type File -Force;
}

Start-Transcript -Append -LiteralPath "${LOG}" -Force -UseMinimalHeader 2>&1 | Out-Null;
# SIG # Begin signature block
# MIIGgQYJKoZIhvcNAQcCoIIGcjCCBm4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDVcY5DSfufro+p
# +kydHK83cS5GkhYhjAKXxuRvE5foJ6CCA6gwggOkMIICjKADAgECAhAe6ommKFuT
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
# FTAvBgkqhkiG9w0BCQQxIgQgMwSvHNyEh999tpKrphu1CmYUwZAW39Tc5MNqYXIQ
# i30wDQYJKoZIhvcNAQEBBQAEggEAGylCni2Y4AHZYkHozJ7BNKvM3DU2/w9O8EOZ
# nmnOf8ZpgwnoHHQjseMdvyyopgb0RgiDY1GPCtzmtmNkorUKj3u1cwPcCwnSfxuo
# PghDTrr3MQ0EKcNwCNyTXa5Zmia0MiXsatC3cRqmtpeaNKcH163gvh//xgup0hBL
# fe+LhDHj1pEv2Br7DYrcoSjVhl/s6zc8o3B1Wd+kkwRlhwzAGOE9eu1+K7QGsCGF
# zSaoYMigEiXv5i/wOP50tJPC0JTV8BUm0/Hq7z76OdMdiIGCjIp6N6GrsE4tHPiu
# 9AQnlBzJRDPzqAeh0jxOsN1hHXzYFKEizXhRMaGcamkpkd+8Dg==
# SIG # End signature block
