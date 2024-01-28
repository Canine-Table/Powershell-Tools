Function  Show-Menu() {

    [CmdletBinding()] param (
        [Parameter()] $Choices,
        [Parameter()][System.String] $ErrorMessage = "please try again.",
        [Parameter()][System.String] $PromptString = "Enter a digit between"
    );

    Begin {
        foreach ($Private:__Object in @([System.Object[]], [System.Collections.Hashtable])) {
            if (($Choices).GetType().Equals($__Object)) {
                [System.Boolean] $Private:__Valid_Set = $true;
            }
        }

        if ($null -eq (Get-Variable -Name __Valid_Set -ErrorAction SilentlyContinue)) {
            Write-Error -Message "You must supply a hash map or object to the options parameter to use this function." `
                                -Exception 'System.Exception' `
                                -Category 'InvalidArgument' `
                                -ErrorId "InvalidParameter" `
                                -CategoryReason "The Choices parameter must be of type hashtable or an object." `
                                -CategoryTargetName "$Choices" `
                                -TargetObject $Choices `
                                -CategoryTargetType 'System.Object[],System.Collections.Hashtable' `
                                -ErrorAction 'Stop';
        }

        [System.Array]  $Private:__Menu = @();
        [System.UInt32] $Private:__Index;
        [System.Boolean] $Private:__Exception;
        [System.Boolean] $Private:__Has_Description = $false;
    }

    Process {
        switch ($Choices) {
            System.Collections.Hashtable {
                $__Has_Description = $true;
                foreach ($Private:__Key in $Choices.Keys) {
                    $__Menu += @{$__Key = $Choices[$__Key]};
                }

                Remove-Variable -Name __Key;
                break;
            } Default { 
                foreach ($Private:__Value in $Choices) {
                    $__Menu += @{$($__Menu.Count + 1) =  $__Value};
                }

                Remove-Variable -Name __Value;
                break;
            }
        }
    }

    End { 
        do {
            $__Exception = $false;
            
            if ($null -ne (Get-Variable -Name __Response -ErrorAction SilentlyContinue)) {
                Get-Message -Type Error -Message "'${__Response}' is not a one of the options, ${ErrorMessage}";
            } else {
                [System.String] $Private:__Response;
                Write-Host;
            }

            for ($__Index = 0; $__Index -lt $Choices.Count; $__Index++) {
                Write-Host -ForegroundColor Green -NoNewline " $($__Index + 1))  ";

                if ($__Has_Description) {
                    Write-Host -ForegroundColor White -NoNewline  " $($__Menu[$__Index].Keys[0])";
                    Write-Host -ForegroundColor Yellow -NoNewline ": ";
                    Write-Host -ForegroundColor Gray "$($__Menu[$__Index].Values[0])";
                } else {
                    Write-Host  -ForegroundColor White "$($__Menu[$__Index].Values[0]) ";
                }
            }

            $__Response = Set-Prompt -Message "${PromptString} [1-${__Index}]";
            Write-Host;

            if ($__Response.ToLower() -match "^(q(u(i(t)?)?)?)$") {
                exit;
            } elseif ($__Response.ToLower() -match "^(b(a(c(k)?)?)?)$") {
                break 1 2> ${null};
            }

            try {
                $__Response = [System.Convert]::ToUInt32("$__Response");
            }  catch {
                $__Exception = $true;
            }

        } while ($__Response -lt 1 -or $__Response -gt $__Index -or $__Exception -ne $false);

        if ($__Has_Description) {
            return $__Menu[$__Response - 1].Keys[0];
        } else {
            return $__Menu[$__Response - 1].Values[0];
        }
    }
}

Function Use-WindowsFeature() {
    param ([Parameter()][System.Object[]] $Features);

    foreach ($Feature in $Features) {
        if ('Available' -eq (Get-WindowsFeature -Name "${Feature}" | select -ExpandProperty 'InstallState' -ErrorAction SilentlyContinue)) {
            Install-WindowsFeature "${Feature}" -IncludeManagementTools -Verbose;
        }
    }
}


Function Set-Values() {
    param (
        [Parameter(Mandatory)][System.String] $Noun,
        [Parameter()][System.String] $Value = 'Value',
        [Parameter()][System.String] $Key = 'Name',
        [Parameter()][System.Collections.Hashtable] $Arguments,
        [Parameter()][System.Collections.Hashtable] $Items
    );

    foreach ($Private:__Item in ([System.Collections.Hashtable] $Private:__Items = @{
        __Get = 'Stop';
        __New = 'Stop';
        __Set = 'SilentlyContinue';
        __Remove = 'SilentlyContinue';
    }).Keys) {
        Invoke-Expression "[System.Object[]] `$Private:${__Item} = Get-Command -Noun ${Noun} -Verb $(${__Item}.split('_')[2]) -ErrorAction $(${__Items}.${__Item})";
    }

    foreach ($Private:__Key in $Items.Keys) {
        $Arguments.${Key} = "${__Key}";
        $Arguments.${Value} = $Items[$__Key];

        if ( -not (. $__Get -Name "${__Key}" -ErrorAction SilentlyContinue)) {
            . $__New @Arguments | Out-Null;
        } elseif ($null -ne $__Set -and "${__Key}" -ne (. $__Get -Name "${__Key}" -ErrorAction SilentlyContinue).Value) {
            if ($null -ne $__Remove -and $null -ne (. $__Get -Name "${__Key}" -ErrorAction SilentlyContinue).Name) {
                . $__Remove  -Name "${__Key}" 2> $null;
            }
            . $__Set @Arguments | Out-Null;
        }
    }
}

Function Get-Emoji() {
       [CmdletBinding()] param ([Parameter()][System.String] $Hexadecimal);

    try {
        $Hexadecimal = "$([System.Char]::ConvertFromUtf32([System.Convert]::toInt32("${Hexadecimal}",16)))";
    } catch {
        return $null;
    }

    return $Hexadecimal;
}

Function Prompt() {
    New-Variable -Option ReadOnly -Name ESC -Value "$([char] 0x1B)" -Visibility Public -Scope Global;
    return "`n ${ESC}[0;1;37m┌──[${ESC}[4;1;37m${env:USERNAME}${ESC}[4;1;35m@${ESC}[4;1;34m${env:COMPUTERNAME}${ESC}[0;1;34m]{$(Get-Emoji  -Hexadecimal 1F4DD)${ESC}[0;1;34m}${ESC}[0;1;33m[${ESC}[4;1;33m$((Get-History | Select-Object -Last $true).Id)${ESC}[0;1;33m]${ESC}[0;1;31m(${ESC}[4;1;31m$(Get-Date)${ESC}[0;1;31m)${ESC}[0;1;32m(${ESC}[4;1;32m$(Get-Location)${ESC}[0;1;32m)${ESC}[0;1;37m`n │`n └${ESC}[0;0;38m$(Get-Emoji  -Hexadecimal 1F4B2) ";
}

Function Set-Prompt() {
    [CmdletBinding()] param (
        [Parameter()][System.String] $Message = "Please Enter a Value"
    );

    Write-Host -NoNewline "`n ${ESC}[0;97;44m ${ESC}[1;4;97;44m${Message}${ESC}[0;97;44m ${ESC}[0;0;98;48m$(Get-Emoji -Hexadecimal 1F4B2) ";
    return Read-Host;
}

Function Get-Message() {
    [CmdletBinding()] param (
        [Parameter(Mandatory)][System.String][ValidateSet(
            'Error',
            'Information',
            'Warning',
            'Success'
        )] $Type,
        [System.String] $Message
   );

    Function Set-Properties() {
        [CmdletBinding()] param (
            [Parameter()][System.String] $Message,
            [Parameter()][System.String] $Default,
            [Parameter()][System.Int32] $Foreground = 30,
            [Parameter()][System.Int32] $Background,
            [Parameter()][System.String] $Character,
            [Parameter()][System.String] $Weight = 1
        );

        if ($Message.Length -eq 0) {
            $Message = $Default;
        }

        $Global:__Message_Attributes = @{
            Message = "${Message}";
            Foreground = "${Foreground}";
            Background = "${Background}";
            Character = "$(Get-Emoji  -Hexadecimal "${Character}")";
            Weight = "${Weight}";
        } 
    }

    Switch ($Type) {
        'Error' {
            Set-Properties -Message "${Message}"  -Weight '6;1' -Default "${Type}!" -Background 41 -Foreground 97 -Character 26D4;
            break;
        } 'Information' {
            Set-Properties -Message "${Message}"  -Default "${Type}!" -Background 104 -Character 1F4C4;
            break;
        } 'Warning' {
            Set-Properties  -Message "${Message}"  -Default "${Type}!" -Background 103 -Character 203C;
            break;
        } 'Success' {
            Set-Properties -Message "${Message}" -Default "${Type}!" -Background 42 -Foreground 97 -Character 2705 ;
            break;
        }
    }

    Write-Host "`n ${ESC}[$($__Message_Attributes.Weight);$($__Message_Attributes.Foreground);$($__Message_Attributes.Background)m $($__Message_Attributes.Character) $($__Message_Attributes.Message) $($__Message_Attributes.Character) ${ESC}[0;98;48m ";
    return $null
}

Function Submit-Input() {
    Param (
        [Parameter()][System.String] $PromptString = "Enter your value that matches this regex",
        [Parameter()][System.String] $ErrorString = "Invalid Input",
        [Parameter()][System.String] $Pattern
    );

    Begin {
        if ($Pattern.Length -eq 0) {
            Write-Error -Message "You must supply a pattern to match to use this function." `
                            -Exception 'System.Exception' `
                            -Category 'InvalidArgument' `
                            -ErrorId "InvalidParameter" `
                            -CategoryReason "The Pattern parameter must be of type hashtable or an object." `
                            -CategoryTargetName "$Pattern" `
                            -TargetObject $Pattern `
                            -CategoryTargetType 'System.String' `
                            -ErrorAction 'Stop';
                }

        [System.String] $Private:__Input;
    }

    End {
        do {
            if ($null -eq (Get-Variable -Name __Error_String -ErrorAction SilentlyContinue)) {
                [System.String] $Private:__Error_String = "${ErrorString}";
            } else {
                Show-Error -Message "${__Error_String}. Please enter a value that maches '${Pattern}'";
            }
            
            $__Input = Set-Prompt -Message "${PromptString} [${Pattern}]";
            Write-Host;
            } until ("${__Input}" -match "^${Pattern}$");
            return "${__Input}";
     }
}

Function Add-Modules() {

    [CmdletBinding()] param ([Parameter()][System.Object[]] $Modules);

    foreach ($Private:__Module in $Modules) {
        if ( $null -eq (Get-Command -Module "${Module}" -ErrorAction SilentlyContinue)) {
            Install-Module -Name "${Module}" -Verbose -ErrorAction Stop;
        }

        if ( -not (Get-Command -Module "${Module}" -ErrorAction SilentlyContinue)) {
            Import-Module -Name "${Module}" -Force;
        }
    }
}


Function Merge-Characters() {
    [CmdletBinding()] param (
        [Parameter(Mandatory)][System.UInt32] $Times,
        [Parameter(Mandatory)][System.Char] $Character,
        [Parameter()][Switch] $Print,
        [System.Collections.Hashtable] $Properties
    );

    [System.String] $Private:__String = "";

    if (${Times} -gt 0) {
        do {
            $__String += "${Character}";
        } while (--${Times});
    }
    
    if (${Print}) {
        Write-Host @Properties "${__String}";
    } else {
        return "${__String}";
    }
}

Function Expand-Everything() {
    [CmdletBinding()] param (
        [Parameter()] $Collection,
        [Parameter()][System.UInt32] $Indent = 2,
        [Parameter()][System.Char] $IndentChar = " ",
        [Parameter()][System.Char] $PadChar = " ",
        [Parameter()][System.Boolean] $IndentBackground = $true,
        [Parameter()][System.Boolean] $IndentForeground = $true,
        [Parameter()][System.Boolean] $Background = $false,
        [Parameter()][System.Boolean] $Foreground = $true,
        [Parameter()][System.Boolean] $Newline = $true,
        [Parameter()][System.UInt32] $Pad = 0,
        [Parameter()][System.String] $Separator = "=>"
    );

    [System.Object] $Local:__Colors = @(
        'Black:White', 'Blue:DarkBlue', 'Cyan:DarkCyan', 'DarkBlue:Blue', 'DarkCyan:Cyan'
        'DarkGray:Gray', 'DarkGreen:Green', 'DarkMagenta:Magenta', 'DarkRed:Red', 'DarkYellow:Yellow'
        'Gray:DarkGray', 'Green:DarkGreen', 'Magenta:DarkMagenta', 'Red:DarkRed', 'White:Black', 'Yellow:DarkYellow'
    );

    Function Add-Indentation() {
         [CmdletBinding()] param (
             [Parameter(Mandatory)][System.Int32] $Indent,
            [Parameter()][System.Collections.Hashtable] $Properties
         );

        if ($Indent -gt 0) {
            Set-Properties  -NoNewline -Indent -Properties ${Properties};
            do {
                Write-Host @Properties ${__Indentation};
            } while (--${Indent});
        }
    }

    Function Test-CollectionType() {
         [CmdletBinding()] param ([Parameter()] $TestType);

        Switch (($TestType).GetType().ToString()) {
            'System.Object[]' {
                return $true;
             } 'System.Collections.Hashtable' {
                return $true;
            } Default {
                return $false;
            }
        }
    }

    Function Set-Properties() {
        [CmdletBinding()] param (
            [Parameter()][System.Collections.Hashtable] $Properties,
            [Parameter()][Switch] $NoNewline,
            [Parameter()][Switch] $Indent,
            [Parameter()][System.UInt32] $Counter = 0
        );

        [System.UInt32] $Private:__State = 0;

        if (${Indent}) {
            ${__State}++;
            ${Properties}.NoNewline = $true;
        }

        if ((${PSBoundParameters}).ContainsKey('Properties')) {
            if ((${Properties}).ContainsKey('Foreground')) {
                    (${Properties}).Remove('Foreground');
            }

            if ((${Properties}).ContainsKey('Background')) {
                    (${Properties}).Remove('Background');
            }

            if ($(${true} -eq ${Background} -and ${__State} -eq 0) -or $(${true} -eq ${IndentBackground} -and ${__State} -eq 1)) {
                ${Properties}.Background = ${__Colors}[((${__Color} + ${Counter}) % 16)].Split(':')[((1 + ${__State}) % 2)] ;
            }

            if ($(${true} -eq ${Foreground} -and ${__State} -eq 0) -or $(${true} -eq  ${IndentForeground} -and ${__State} -eq 1)) {
                ${Properties}.Foreground = $__Colors[(($__Color + $Counter) % 16)].Split(':')[((2 + $__State) % 2)] ;
            }
        }

        if (${__State} -ne 1) {
            if (${NoNewline}) {
                ${Properties}.NoNewline = $true;
            } else {
                ${Properties}.NoNewline = -not ${Newline};
            }
        }
    }

    if (${null} -eq (Get-Variable -Name __Color -ErrorAction SilentlyContinue)) {
        [System.UInt32] $Local:__Color = 1;

    } else {
        ${__Color}++;
    }

    if (${null} -eq (Get-Variable -Name __Padding -ErrorAction SilentlyContinue)) {
        [System.String] $Local:__Padding = "{0,${Pad}}" -f "$(Merge-Characters -Times ${Pad} -Character ${PadChar})";
    }

    if (${null} -eq (Get-Variable -Name __Indentation -ErrorAction SilentlyContinue)) {
        [System.String] $Local:__Indentation= "{0,${Indent}}" -f "$(Merge-Characters -Times ${Indent} -Character ${IndentChar})"
    }

    [System.Collections.Hashtable] $Private:__Properties = @{};
   
    Switch ((${Collection}).GetType().ToString()) {
        'System.Object[]' {
            for ([System.UInt32] $Private:__Index = 0; ${__Index} -lt (${Collection}).Count; ${__Index}++) {
                if (${__Color} -eq 1) {
                    Out-Host;
                }

                if (${true} -eq (Test-CollectionType  -TestType ${Collection}[$__Index])) {
                    Expand-Everything -Newline ${Newline} -IndentForeground ${IndentForeground} -IndentBackground ${IndentBackground}  -IndentChar ${IndentChar} -Foreground ${Foreground} -Background ${Background} -Separator ${Separator} -Indent ${Indent} -Collection ${Collection}[${__Index}];
                } else {
                    Add-Indentation -Indent (${__Color} - 1) -Properties ${__Properties};
                    Set-Properties -Properties ${__Properties};

                    if (${__Color} -eq 1) {
                        ${__Properties}.NoNewline = $false;
                    } else {
                        ${__Properties}.NoNewline = -not ${Newline};
                    }

                    Write-Host @__Properties "${__Padding}$(${Collection}[${__Index}])${__Padding}";
                }
            }
        } 'System.Collections.Hashtable' {
            foreach ($Private:__Key in ${Collection}.Keys) {
                Add-Indentation -Indent (${__Color} - 1) -Properties ${__Properties};
                Set-Properties -Properties $__Properties -NoNewline;

                    if (${__Color} -eq 1) {
                        ${__Properties}.NoNewline = $false;
                    } else {
                        ${__Properties}.NoNewline =  $true
                        ;
                    }

                Write-Host  @__Properties  "${__Padding}$($__Key)${__Padding}";

                if (${true} -eq (Test-CollectionType  -TestType ${Collection}[${__Key}])) {
                    if (${Newline}) {
                        Write-Host;
                    }

                    Expand-Everything -Newline ${Newline} -IndentForeground ${IndentForeground} -IndentBackground ${IndentBackground}  -IndentChar ${IndentChar} -Foreground ${Foreground} -Background ${Background} -Separator ${Separator} -Indent ${Indent} -Collection ${Collection}[${__Key}];
                } else {
                    Set-Properties -Properties ${__Properties}  -Counter 1 -NoNewline;
                    Write-Host @__Properties "  ${Separator}  ";
                    Set-Properties -Properties ${__Properties}   -Counter 2;
                    Write-Host  @__Properties "${__Padding}$(${Collection}[${__Key}])${__Padding}";
                }
            }
        } Default {
            Write-Error -Message "You must supply a hash map or object to the options parameter to use this function." `
                -Exception 'System.Exception' `
                -Category 'InvalidArgument' `
                -ErrorId "InvalidParameter" `
                -CategoryReason "The Choices parameter must be of type hashtable or an object." `
                -CategoryTargetName "${Options}" `
                -TargetObject ${Options} `
                -CategoryTargetType 'System.Object[],System.Collections.Hashtable' `
                -ErrorAction 'Stop';
        }
    }
}