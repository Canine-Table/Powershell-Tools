using module ./Modules/classes.psm1

function Invoke-Main() {

    Begin {
        Import-Module -Force "${PSScriptRoot}\Modules\functions.psm1";

        [Hive] $Private:__Hive = [Hive]::New();
        [System.Int32] $Private:__Index = 0;
#        [System.Collections.Generic.List[System.String]] $Private:__Array = @();
        [System.Collections.Hashtable] $Private:__Hash_Map = @{};
    }

    Process {
        [System.String] $Private:__PARENT = "$(Split-Path  "${PROFILE}" -Parent)";
        [System.String] $Private:__LEAF = "$(Split-Path  "${PROFILE}" -Leaf)";

        if ( -not (Test-Path -LiteralPath "${__PARENT}" -Type Container -ErrorAction SilentlyContinue)) {
            New-Item -Path "${__PARENT}" -Type Directory -Force;
        }

        if ( -not (Test-Path -LiteralPath "${PROFILE}" -Type Leaf -ErrorAction SilentlyContinue)) {
            New-Item -Path "${__PARENT}" -Name "${__LEAF}" -Type File -Force;
        }

        Copy-Item -Path "${PSScriptRoot}\Modules\*.psm1" -Destination "${__PARENT}\Modules";
        Copy-Item -Path  "${PSScriptRoot}\profile.ps1" -Destination "${PROFILE}";

        Remove-Variable -Name __PARENT,__LEAF;

        $__Hive.SetLocation('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced').SetHives(@{
            'HideFileExt' = 0
            'LaunchFolderWindows' = 1
            'ShowCortanaButton' = 0
            'Hidden' = 1
            'ShowSuperHidden' = 1
            'TaskbarAnimations' = 1
            'ShowSecondsInSystemClock' = 1
            'ShowEncryptCompressedColor' = 1
            'ShowStatusBar' = 1
            'HideDrivesWithNoMedia' = 0
            'HideMergeConflicts' = 0
            'ShowSyncProviderNotifications' = 1
            'FolderContentsInfoTip' = 1
            'LaunchTo' = 1
            'ShowPreviewHandlers' = 1
        }).ExecuteHives().SetLocation('HKCU:\Control Panel\Colors').SetHives(@{
            'ActiveBorder' = '0 64 0'
            'ActiveTitle' = '144 201 147'
            'AppWorkspace' = '60 208 112'
            'Background' = '108 147 92'
            'ButtonAlternateFace' = '0 0 0'
            'ButtonDkShadow' = '114 134 120'
            'ButtonFace' = '93 134 114'
            'ButtonHilight' = '127 255 0'
            'ButtonLight' = '128 255 0'
            'ButtonShadow' = '0 255 128'
            'ButtonText' = '0 0 0'
            'GradientActiveTitle' = '128 255 128'
            'GradientInactiveTitle' = '255 128 255'
            'GrayText' = '128 64 0'
            'Hilight' = '0 128 64'
            'HilightText' = '0 240 168'
            'HotTrackingColor' = '0 128 0'
            'InactiveBorder' = '133 96 136'
            'InactiveTitle' = '152 97 165'
            'InactiveTitleText' = '154 122 141'
            'InfoText' = '0 0 0'
            'InfoWindow' = '108 147 92'
            'Menu' = '59 51 28'
            'MenuBar' = '0 0 0'
            'MenuHilight' = '0 64 0'
            'MenuText' = '128 64 0'
            'Scrollbar' = '64 128 128'
            'TitleText' = '0 0 0'
            'Window' = '176,194,181'
            'WindowFrame' = '0 68 37'
            'WindowText' = '0 0 0'
        }).ExecuteHives().SetLocation('HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies\System').SetHives(@{
            "legalnoticecaption"="Windows Server 2022 Datacenter"
            "legalnoticetext"="Virtual Machine for CST8242"
        }).ExecuteHives().SetLocation('HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize').SetHives(@{
            'ColorPrevalence' = 1
            'EnableTransparency' = 1
            'AppsUseLightTheme' = 0
            'SystemUsesLightTheme' = 0        
        }).ExecuteHives().SetLocation('HKCU:\Software\Microsoft\Windows\DWM').SetHives(@{
            'ColorPrevalence' = 1
            'EnableWindowColorization' = 1
            'ColorizationAfterglow' = 'c4000000'
            'ColorizationAfterglowBalance' = 10
            'ColorizationBlurBalance' = 1
            'ColorizationGlassAttribute' = 1
            'Composition' = 1
            'ColorizationColorBalance' = 59
            'AccentColor' = 'ff000000'
        }).ExecuteHives().SetLocation('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects').SetHives(@{
            'VisualFXSetting' = 3
        }).ExecuteHives().SetLocation('HKLM:\System\ControlSet001\Control\Session Manager\Memory Management').SetHives(@{
            'PagingFiles' = 'c:\pagefile.sys 32768 32768'
        }).ExecuteHives().SetLocation('HKLM:\SYSTEM\ControlSet001\Control\Terminal Server').SetHives(@{
            'fDenyTSConnections' = 0
        }).ExecuteHives().SetLocation('HKCU:\Software\Microsoft\Internet Explorer\Main').SetHives(@{
            'Start Page' = 'https://www.google.ca/'
        }).ExecuteHives().Done();

        
        [System.String] $Private:__Drive = "C Drive Stro0123";

        # Volume Optimization
        if ((Get-Volume -DriveLetter C).FileSystemLabel -ne $__Drive) {
            Set-Volume -DriveLetter C -NewFileSystemLabel $__Drive;
            Optimize-Volume -FileSystemLabel $__Drive;
            Optimize-Volume -FileSystemLabel $__Drive -Analyze -Defrag -TierOptimize;
        }

        Remove-Variable -Name __Drive;

        # Remote User Group Addons
        foreach ($Private:__User in @('Stro0123','Administrator')) {
            if ( -not ( Get-LocalGroupMember -Group 'Remote Desktop Users' -Member $__User -ErrorAction SilentlyContinue)) {
                Add-LocalGroupMember -Group 'Remote Desktop Users' -Member $__User 2> $null;
            }
        }

        # Adapter Names
        Remove-Variable -Name __User;
        if (($__Index = (Get-NetAdapter | Select-Object -Property Name | Measure-Object | Select-Object -Property Count).Count) -eq 2) {
            $__Hash_Map = @{'Red' = $false; 'Blue' = $false};
            foreach ($Private:__Adapter in (Get-NetAdapter | Select-Object -ExpandProperty Name)) {
                if ($__Adapter -notin @('Nat (Blue)','Bridged (Red)')) {
                    if ((Get-NetIPAddress -InterfaceAlias $__Adapter -AddressFamily IPv4 | Select-Object -Property IPAddress).IPAddress -like '192.168.*.*' -and $__Adapter -ne 'Nat (Blue)' -and $__Hash_Map.Blue -ne $true) {
                        $__Hash_Map.Blue = $true;
                        Rename-NetAdapter -Name $__Adapter -NewName 'Nat (Blue)';
                    } elseif ($__Adapter -ne 'Bridged (Red)' -and $__Hash_Map.Red -ne $true) {
                        $__Hash_Map.Red = $true;
                        Rename-NetAdapter -Name $__Adapter -NewName 'Bridged (Red)';
                    }
                }
            }

            $__Hash_Map.Clear();
        } else {
            Show-Error -Message "You should have 2 network adapters, you currently have ${__Adapter}.";
            return 1;
        }

        ### Blue Network ###
        $__Adapter = 'Nat (Blue)';
        
        if ((Get-DnsClient -InterfaceAlias $__Adapter).ConnectionSpecificSuffix -eq "") {
            do {
                if ($null -ne (Get-Variable -Name __Suffix -ErrorAction SilentlyContinue)) {
                    Write-Host -ForegroundColor  White -BackgroundColor DarkRed "`n '${__Suffix}' must match this regex '^dm\d{5}$', please try again `n";
                } else {
                    Write-Host;
                }

                Write-Host -ForegroundColor White -BackgroundColor DarkBlue -NoNewline " Enter your connection secific suffix domain. example [dm12345] ";
                [System.String] $Private:__Suffix = Read-Host -prompt " ";

            } until ($__Suffix -match "^dm\d{5}$");

            Set-DnsClient -InterfaceAlias "${__Adapter}" -ConnectionSpecificSuffix "${__Suffix}.cst8342.com";
        }

        function Get-Tcp {
            param (
                [Parameter()][System.Boolean] $Value,
                [Parameter()][System.String] $ComponentID,
                [Parameter()][System.String] $Name
            );
            
            End {
                return Get-NetAdapterBinding -Name $Name | Where-Object -Property ComponentID -EQ $ComponentID | Where-Object -Property Enabled -EQ $Value -ErrorAction SilentlyContinue;
            }
        }

        foreach ($__Adapter in (Get-NetAdapter | select-Object -Property Name).Name) {
            if ((Get-Tcp -Name $__Adapter -ComponentID ms_tcpip6 -Value $true)) {
                Disable-NetAdapterBinding -Name $__Adapter -ComponentID ms_tcpip6;
            } elseif (Get-Tcp -Name $__Adapter -ComponentID ms_tcpip -Value $false) {
                Enable-NetAdapterBinding -Name $__Adapter -ComponentID ms_tcpip;
            }
        }

        ### Red Network ###
        $__Adapter = 'Bridged (Red)';

        if ( -not (Get-NetIPInterface -InterfaceAlias $__Adapter -Dhcp Disabled -ErrorAction SilentlyContinue)) {
            [System.Int32] $Private:__Octet = [System.Convert]::ToInt32({
                Submit-Input -ErrorString "Input must match this regex '^\d{1,3}$', please try again" `
                -PromptString "Enter Your Third Octet connection secific suffix." `
                -Pattern "\d{1,3}";
            })

            New-NetIPAddress -PrefixLength 16 -InterfaceAlias $__Adapter -IPAddress "172.16.94.${__Octet}";
            Set-DNSClientServerAddress -InterfaceAlias $__Adapter -ServerAddresses ("172.16.94.${__Octet}");
            Set-NetIPInterface -InterfaceAlias $__Adapter -Dhcp Disabled;
            Remove-Variable -Name __Octet;
        }

        if ((Get-DnsClient -InterfaceAlias $__Adapter).ConnectionSpecificSuffix -eq "") {
            [System.String] $Private:__Suffix = Submit-Input -errorString "Input must match this regex '^dm\d{5}$', please try again." `
                -PromptString "Enter your connection secific suffix domain. example [dm12345]" `
                -Pattern "dm\d{5}";
            Set-DnsClient -InterfaceAlias "${__Adapter}" -ConnectionSpecificSuffix "${__Suffix}.cst8342.com";
        }

        Remove-Variable -Name __Adapter;

        ### WinDefend Service ###
        Use-WindowsFeature -Features @('GPMC', 'DNS','AD-Domain-Services');
        Add-Modules -Modules @('GroupPolicy','7Zip4PowerShell','DNS','ADDSDeployment','ActiveDirectory');

        if ( -not (Get-Item -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -ErrorAction SilentlyContinue)) {
            New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'Windows Defender';
        }

        if ( -not (Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware' -ErrorAction SilentlyContinue)) {
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -PropertyType 'DWord' -Name 'DisableAntiSpyware' -Value 1;
        }

        if (1 -ne (Get-ItemPropertyValue 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware')) {
            Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware' -value 1;
        }

        if ("Running" -eq (Get-Service -Name WinDefend | Select-Object -ExpandProperty Status)) {
            Stop-Service -Name WinDefend;
            Set-Service -Name WinDefend -StartupType Disabled;
        }

        ### Shortcuts ###
        foreach ($Private:__Shortcut in ([System.Collections.Hashtable] $Private:__Shortcuts = @{
            'Dns Manager' = "${env:SystemRoot}\system32\dnsmgmt.msc";
            'Microsoft Edge' = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe";
            'Server Manager' = "${env:SystemRoot}\system32\ServerManager.exe";
        }).Keys) {
            if (-not (Get-ItemProperty -LiteralPath "${env:USERPROFILE}\Desktop\${__Shortcut}" -ErrorAction SilentlyContinue).Exists) {
                New-Item -ItemType SymbolicLink -Value ${__Shortcuts}.${__Shortcut} -Name "${__Shortcut}" -Path "${env:USERPROFILE}\Desktop";
            }
        }

        ### Primary Zones ###
        $Private:__Primary_Zone = Get-DnsClient -InterfaceAlias 'Bridged (Red)' | Select-Object -ExpandProperty 'ConnectionSpecificSuffix';

        if (-not (Get-DnsServerZone -ZoneName "${__Primary_Zone}" -ErrorAction SilentlyContinue)) {
            Add-DnsServerPrimaryZone -Name "${__Primary_Zone}" -ZoneFile "${__Primary_Zone}.dns" -DynamicUpdate NonsecureAndSecure;
        } else {
            Get-Message -Type Information -Message "The primary forward lookup zone '${__Primary_Zone}' already exists.";
    #        Get-DnsServerResourceRecord -ZoneName "${__Primary_Zone}" | Format-List;
        }

        if (-not (Get-DnsServerZone -ZoneName "16.172.in-addr.arpa" -ErrorAction SilentlyContinue)) {
            Add-DnsServerPrimaryZone -NetworkID "172.16.0.0/16" -DynamicUpdate NonsecureAndSecure -ZoneFile '16.172.in-addr.arpa'
        } else {
            Get-Message -Type Information -Message "The primary reverse lookup zone '16.172.in-addr.arpa' already exists.";
    #        Get-DnsServerResourceRecord -ZoneName "16.172.in-addr.arpa" | Format-List;
        }
        
        [System.Boolean] $Private:__Exists = $false;

        ### PTR Records ###
        [System.String[]] $Private:__Pointer = [System.Convert]::ToString((Get-NetIPAddress | Select-Object -Property IPAddress | Where-Object -Property IPAddress -like '172.16.*' | Select-Object -ExpandProperty IPAddress)).Split('.')
        [System.String] $Private:__Pointer_Name = "$($__Pointer[3]).$($__Pointer[2])";
        Remove-Variable -Name __Pointer;

        foreach ($Private:__Pointer in (Get-DnsServerResourceRecord -ZoneName 16.172.in-addr.arpa -RRType Ptr | Select-Object -expandProperty HostName)) {
            if (${__Pointer} -eq ${__Pointer_Name}) {
                $__Exists = $true;
            }
        }

        if ("${__Exists}" -eq $false) {
            Add-DnsServerResourceRecordPtr -Name "$($__Pointer[3]).$($__Pointer[2])" -ZoneName "16.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "${__Primary_Zone}";
            Add-DnsServerResourceRecordPtr -Name "89.253" -ZoneName "16.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "Server89253.cst8242.com";
        }

        ### A Records ###
        foreach ($Private:__Adapter in (Get-NetAdapter | select-Object -ExpandProperty Name)) {
            $Private:__Record_Data = "$(Get-NetIPAddress -InterfaceAlias $__Adapter | Select-Object -Expand IPAddress)";
            $__Exists = $false;

            foreach ($Private:__Record in (Get-DnsServerResourceRecord -ZoneName "${__Primary_Zone}" -RRType "A" | Select-Object @{n='Data';e={$_.RecordData.IPv4Address}})) {
                if (${__Record_Data} -eq ${__Record}.Data) {
                    $__Exists = $true;
                }
            }

            if ("${__Exists}" -eq $false) {
                Add-DnsServerResourceRecordA -Name "$($env:COMPUTERNAME.ToLower())" `
                    -IPv4Address "${__Record_Data}" `
                    -AllowUpdateAny -TimeToLive '01:00:00' `
                    -ZoneName "${__Primary_Zone}";
            }
        }

        ### Forwarders ###

        [System.Object[]] $Private:__Reference_Object = @('172.16.89.253', '10.50.10.253', '10.254.21.22', '8.8.8.8');
        [System.Object[]] $Private:__Difference_Object = (Get-DnsServerForwarder | Select-Object -expandProperty ReorderedIPAddress).IPAddressToString;
        [System.Boolean] $Private:__Objects_Match = ${true};
        
        if (${__Reference_Object}.Count -ne ${__Difference_Object}.Count) {
            $__Objects_Match = ${false};
        } else {
            for ([System.UInt32] $__Index = 0; $__Index -lt ${__Reference_Object}.Count; $__Index++) {
                if (${__Reference_Object}[${__Index}] -ne ${__Difference_Object}[${__Index}]) {
                    $__Objects_Match = ${false};
                    break;
                }
            }
        }

        if (-not (${__Objects_Match})) {
            Set-DnsServerForwarder $__Reference_Object;
        } else {
            Get-Message -Type Information -Message "Forwarder have been set correctly.";
        }

        Remove-Variable __Objects_Match,__Reference_Object,__Difference_Object

        ### Active Directory ###
        if ( -not (Get-Service -Name adws,kdc,netlogon,dns -ErrorAction SilentlyContinue)) {
            Install-ADDSForest -SafeModeAdministratorPassword (Read-Host -Prompt "Enter Safe Mode Administrator Password" -AsSecureString) `
                -CreateDnsDelegation:$false `
                -DatabasePath "C:\Windows\NTDS" `
                -DomainMode "WinThreshold" `
                -DomainName "$(${env:COMPUTERNAME}.ToLower()).cst8242.com" `
                -DomainNetbiosName "DM$(${env:COMPUTERNAME}.Split('R')[2])" `
                -ForestMode "WinThreshold" `
                -InstallDns:$true `
                -LogPath "C:\Windows\NTDS" `
                -NoRebootOnCompletion:$false `
                -SysvolPath "C:\Windows\SYSVOL" `
                -Force:$true;
        } else {
            Get-Message -Type Information -Message "Active Directory Domain Services has already been configured.";
        }

        ### AD Users ###
        [System.Collections.Hashtable] $Private:__User_Properties = @{
            Identity = 'Stro0123';
            EmailAddress = 'stro0123@algonquinlive.com';
            GivenName = 'Benjamin';
            Surname = 'Wilson';
        }

        if ((Get-ADGroupMember -Identity 'Domain Admins' -Recursive | Select-Object -ExpandProperty Name) -notcontains ${__User_Properties}.Identity) {
            Add-ADGroupMember -Identity 'Domain Admins' -Members ${__User_Properties}.Identity;
        } else {
            Get-Message -Type Information -Message "$(${__User_Properties}.Identity) is already a member of 'Domain Admins'.";
        }

        foreach ($Private:__Property in $__User_Properties.Keys) {
            if (${__Property} -ne 'Identity') {
                if ((Get-ADUser -Identity ${__User_Properties}.Identity -Properties "${__Property}").${__Property} -ne ${__User_Properties}.${__Property}) {
                    Get-Message -Type Information -Message "Updating $(${__User_Properties}.Identity) ${__Property} to $(${__User_Properties}.${__Property})...";

                    switch (${__Property}) {
                        'EmailAddress' { Set-ADUser -Identity ${__User_Properties}.Identity EmailAddress "$(${__User_Properties}.${__Property})" }
                        'GivenName' { Set-ADUser -Identity ${__User_Properties}.Identity -GivenName "$(${__User_Properties}.${__Property})" }
                        'Surname' { Set-ADUser -Identity ${__User_Properties}.Identity -Surname "$(${__User_Properties}.${__Property})" }
                    }
                }
            }
        }

        ### AD Integrated Zones ###
        if (-not (Get-DnsServerZone -ZoneName "${__Primary_Zone}" | Select-Object -ExpandProperty IsDsIntegrated)) {
            ConvertTo-DnsServerPrimaryZone "${__Primary_Zone}" -PassThru -Verbose -ReplicationScope Domain -Force;
        }

        if ('Secure' -ne (Get-DnsServerZone -ZoneName "${__Primary_Zone}" | Select-Object -ExpandProperty DynamicUpdate)) {
            Set-DnsServerPrimaryZone -DynamicUpdate Secure -Name "${__Primary_Zone}";
        }

        if (-not (Get-DnsServerZone -ZoneName '16.172.in-addr.arpa'| Select-Object -ExpandProperty IsDsIntegrated)) {
            ConvertTo-DnsServerPrimaryZone '16.172.in-addr.arpa' -PassThru -Verbose -ReplicationScope Domain -Force;
        }

        if ('Secure' -ne (Get-DnsServerZone -ZoneName '16.172.in-addr.arpa' | Select-Object -ExpandProperty DynamicUpdate)) {
            Set-DnsServerPrimaryZone -DynamicUpdate Secure -Name '16.172.in-addr.arpa';
        }

    } End {
        Get-Message -Type Success -Message "All Done :)";
        return $null;
    }
}

Invoke-Main;
# SIG # Begin signature block
# MIIGgQYJKoZIhvcNAQcCoIIGcjCCBm4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCB9kLdGSFOzYeZ
# A6SaNndjoCFBJoFjrEJbrr6OdtgRcaCCA6gwggOkMIICjKADAgECAhAe6ommKFuT
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
# FTAvBgkqhkiG9w0BCQQxIgQgKgffRP6xYnVf4iaF2jgXDDVxrJbtiyIzZyn7pMBF
# wv0wDQYJKoZIhvcNAQEBBQAEggEADCkv/8d8ep9Vfz3SWuy71KEuHn78TpWWps8b
# V/S+UlQo39Aaq8T6VcH4UUGszJwVPD6u6zS2Wd1a7CuiaPQ9POEg80nOCH3IrI0W
# vjlaB4MQGHSyeimAQaqyAbzsrvn5f8lywEx5f8Jrvfkelcn3mfYKIAqZn5aRrKJT
# xSaJQDFdF+PUB5e6BSdzq7f38e/StRRda8jm4Gy/xkZQo46aKRf5v/zglnRZJ6Lg
# LlfhRHemQzrVaWvZgVxaI5gwScqyhsSztgUgwTYdPF8rOZHRqJ18C10fGK+nVorA
# rZrtfe+rPT/NEeUPf7uNTYCfpBgNhc7XncjxhuxUdyMtZO0Jbw==
# SIG # End signature block
