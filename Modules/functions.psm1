Function Show-Menu() {
    [CmdletBinding()] param (
        [Parameter()] $Options,
        [Parameter()][System.UInt32] $Columns = 3,
        [Parameter()][System.UInt32] $Indent = 3,
        [Parameter()][System.UInt32] $KeyPadding = 0,
        [Parameter()][System.UInt32] $Padding = 0,
        [Parameter()][System.UInt32] $PadLeft = 1,
        [Parameter()][System.UInt32] $PadRight = 1,
        [Parameter()][System.UInt32] $PadLeftKey = 2,
        [Parameter()][System.UInt32] $PadRightKey = 2,
        [Parameter()][System.String] $Separator = ":",
        [Parameter()][System.String] $Message = 'Please Select One of the following choices.',
        [Parameter()][System.String] $Error = 'Invalid Choice, please chooce between the listed options.',
        [Parameter()][System.String] $Warning = 'Please only enter numbers',
        [Parameter()][System.String] $Prompt = 'Please Enter your Choice',
        [Parameter()][Switch] $Range
    );

    Begin {
        if (([System.String] $Private:__Collection = (${Options}).GetType().ToString()) -notin ('System.Object[]', 'System.Collections.Hashtable')) {
            Write-Error -Message "You must supply a  'System.Object[]' or 'System.Collections.Hashtable' to the manditory Options parameter." `
                -Exception 'System.Exception' `
                -Category 'InvalidArgument' `
                -ErrorId "InvalidParameter" `
                -CategoryReason "The Options parameter must be of type System.Object[] or of type System.Collections.Hashtable." `
                -CategoryTargetName "${Options}" `
                -TargetObject "${Options}" `
                -CategoryTargetType 'System.Object[],System.Collections.Hashtable' `
                -ErrorAction 'Stop';
        } else {
            [System.UInt32] $Private:__Index = 0;
            [System.UInt32] $Private:__Rows = 0;
            [System.UInt32] $Private:__Column = 0;
            [System.Boolean] $Private:__Exception = ${false};
            [System.String] $Private:__Response = "";
            [System.Object[]] $Private:__Menu = @();
            [System.Collections.Hashtable] $Private:__Display = @{};

            Write-Host -NoNewline "`n  ";
           Get-Message -Type Information -Message "${Message}";
            Write-Host;

            do {
                if (${null} -eq (Get-Variable -Name __Error -ErrorAction SilentlyContinue)) {
                    [System.String] $Private:__Error = "${Error}";

                    if (${Range}) {
                        $Prompt += "  [1 - $((${Options}).Count)]"
                    }

                } else {
                    $__Exception = ${false};
                    Get-Message -Type Error -Message "${__Error}";
                    Write-Host;
                }
                
                Switch (${__Collection}) {
                    'System.Object[]' {
                        $__Column = 0;
                        for ($__Index  = 0; ${__Index} -lt (${Options}).Count; ${__Index}++) {
                            Expand-Everything -Separator "${Separator}" -PadRightKey ${PadRightKey} -PadLeftKey ${PadLeftKey} -KeyPadding ${KeyPadding}  -Padding ${Padding} -PadLeft ${PadLeft} -PadRight ${PadRight} -IndentBackground ${false} -Indent ${Indent} -Newline ${false}  -Collection @(@{"$(${__Index} + 1))" = "$(${Options}[${__Index}])"});

                            if ((${__Menu}).Count -ne (${Options}).Count) {
                                ${__Menu} += (${Options}[${__Index}]);
                            }

                            $__Column++;
                            if ((${__Column} -eq ${Columns}) -or (${__Index} + 1) -eq (${Options}).Count) {
                                Write-Host;
                                $__Column = 0
                                ${__Rows}++;
                            }
                        }
                    } 'System.Collections.Hashtable' {
                            $__Index = 0;
                            $__Column = 0;
                            foreach ($Private:__Key in (${Options}).Keys) {
                                if ((${__Menu}).Count -ne (${Options}).Count) {
                                    $__Menu += (${__Key});
                                }

                               ${__Column}++
                                Expand-Everything -Separator "${Separator}"  -PadRightKey ${PadRightKey} -PadLeftKey ${PadLeftKey} -KeyPadding ${KeyPadding} -Padding ${Padding} -PadLeft ${PadLeft} -PadRight ${PadRight} -IndentBackground ${false} -Indent ${Indent} -Newline ${false}  -Collection @(@{"$(${__Index} + 1))" = @{"${__Key}" = "$(${Options}.${__Key})"}});
                                if (((${__Column} -eq ${Columns}) -or (${__Index} + 1) -eq (${Options}).Count)) {
                                        Write-Host;
                                        $__Column = 0;
                                        ${__Rows}++;
                                }
                                ${__Index}++;
                            }
                    }
                }

                $__Response = Set-Prompt -Message "${Prompt}";

                 try {
                    $__Rows = [System.Convert]::ToUInt32("${__Response}");
                }  catch {
                   Get-Message -Type Warning -Message "${Warning}";
                    $__Exception = ${true};
                }

            } while (${__Response} -lt 1 -or (${__Index} -lt ${__Rows})  -or (${__Exception} -ne ${false}));
        }
    }

    End {
        return "$(${__Menu}[(${__Rows} - 1)])";
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
        [Parameter()][System.String] $Message = "Please Enter a Value",
        [Parameter()][Switch] $AsSecureString,
        [Parameter()] $Parameters


    );

    Begin {
        if ((${PSBoundParameters}).ContainsKey('Parameters')) {
            if (((${Parameters}).GetType().ToString()) -ne 'System.Collections.Hashtable') {
                Write-Error -Message "You must supply a 'System.Collections.Hashtable' if you intend to use the Parameters parameter." `
                    -Exception 'System.Exception' `
                    -Category 'InvalidArgument' `
                    -ErrorId "InvalidParameter" `
                    -CategoryReason "The Parameters parameter must be of type System.Collections.Hashtable." `
                    -CategoryTargetName "${Parameters}" `
                    -TargetObject "${Parameters}" `
                    -CategoryTargetType 'System.Collections.Hashtable' `
                    -ErrorAction 'Stop';
            }
        }
        [System.Boolean] $Private:__Secure = ${false};
        if (${AsSecureString}) {
            $__Secure = ${true};
        }

        Write-Host -NoNewline "`n ${ESC}[0;97;44m ${ESC}[1;4;97;44m${Message}${ESC}[0;97;44m ${ESC}[0;0;98;48m$(Get-Emoji -Hexadecimal 1F4B2) ";
    }

    End {
        return Set-Splats -Noun 'Read' -Verbs @('Host') -Parameters @{'AsSecureString' = ${__Secure}};
    }
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
        [Parameter()][System.UInt32] $Padding,
        [Parameter()][System.UInt32] $KeyPadding,
        [Parameter()][System.UInt32] $PadLeft = 0,
        [Parameter()][System.UInt32] $PadRight = 0,
        [Parameter()][System.UInt32] $PadLeftKey = 2,
        [Parameter()][System.UInt32] $PadRightKey = 2,
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
                return ${true};
             } 'System.Collections.Hashtable' {
                return ${true};
            } Default {
                return ${false};
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

    if (${null} -eq (Get-Variable -Name __PadLeft -ErrorAction SilentlyContinue)) {

        if (${Padding} -gt 0) {
            $PadLeft = ${Padding};
            $PadRight = ${Padding};
        }

        if (${KeyPadding} -gt 0) {
            $PadLeftKey = ${KeyPadding};
            $PadRightKey = ${KeyPadding};
        }

        [System.String] $Local:__PadLeft = "{0,${PadLeft}}" -f "$(Merge-Characters -Times ${PadLeft} -Character ${PadChar})";
        [System.String] $Local:__PadRight = "{0,${PadRight}}" -f "$(Merge-Characters -Times ${PadRight} -Character ${PadChar})";
        [System.String] $Local:__PadLeftKey = "{0,${PadLeftKey}}" -f "$(Merge-Characters -Times ${PadLeftKey} -Character ${PadChar})";
        [System.String] $Local:__PadRightKey = "{0,${PadRightKey}}" -f "$(Merge-Characters -Times ${PadRightKey} -Character ${PadChar})";
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

                    Write-Host @__Properties "${__PadLeft}$(${Collection}[${__Index}])${__PadRight}";
                }
            }
        } 'System.Collections.Hashtable' {
            foreach ($Private:__Key in ${Collection}.Keys) {
                Add-Indentation -Indent (${__Color} - 1) -Properties ${__Properties};
                Set-Properties -Properties $__Properties -NoNewline;

                    if (${__Color} -eq 1) {
                        ${__Properties}.NoNewline = ${false};
                    } else {
                        ${__Properties}.NoNewline =  ${true};
                    }

                Write-Host  @__Properties  "${__PadLeft}$($__Key)";

                if (${true} -eq (Test-CollectionType  -TestType ${Collection}[${__Key}])) {
                    if (${Newline}) {
                        Write-Host;
                    }

                    Expand-Everything -Newline ${Newline} -IndentForeground ${IndentForeground} -IndentBackground ${IndentBackground}  -IndentChar ${IndentChar} -Foreground ${Foreground} -Background ${Background} -Separator ${Separator} -Indent ${Indent} -Collection ${Collection}[${__Key}];
                } else {
                    Set-Properties -Properties ${__Properties}  -Counter 1 -NoNewline;
                    Write-Host @__Properties "${__PadLeftKey}${Separator}${__PadRightKey}";
                    Set-Properties -Properties ${__Properties}   -Counter 2;
                    Write-Host  @__Properties "$(${Collection}[${__Key}])${__PadRight}";
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

Function Set-Splats() {
    [CmdletBinding()] param (
        [Parameter()] $Parameters,
        [Parameter()] $Arguments,
        [Parameter(Mandatory)][System.String] $Noun,
        [Parameter()] $Verbs
    );
    
    Begin {
        if ((${Verbs}).GetType().ToString() -ne 'System.Object[]') {
            Write-Error -Message "You must supply an  'System.Object[]' to the Verbs parameter." `
                -Exception 'System.Exception' `
                -Category 'InvalidArgument' `
                -ErrorId "InvalidParameter" `
                -CategoryReason "The Verbs parameter must be of type System.Object[]." `
                -CategoryTargetName "${Verbs}" `
                -TargetObject "${Verbs}" `
                -CategoryTargetType 'System.Object[]' `
                -ErrorAction 'Stop';
        }

        if ((${PSBoundParameters}).ContainsKey('Arguments')) {
            if ((${Arguments}).GetType().ToString() -ne 'System.Object[]') {
                Write-Error -Message "You must supply a 'System.Object[]' type to the Arguments parameter." `
                    -Exception 'System.Exception' `
                    -Category 'InvalidArgument' `
                    -ErrorId "InvalidParameter" `
                    -CategoryReason "The Arguments parameter must be of type System.Object[]." `
                    -CategoryTargetName "${Arguments}" `
                    -TargetObject "${Arguments}" `
                    -CategoryTargetType 'System.Object[]' `
                    -ErrorAction 'Stop';
            }
        }

        if ((${PSBoundParameters}).ContainsKey('Parameters')) {
            if (((${Parameters}).GetType().ToString()) -ne 'System.Collections.Hashtable') {
                Write-Error -Message "You must supply a 'System.Collections.Hashtable' if you intend to use the Parameters parameter." `
                    -Exception 'System.Exception' `
                    -Category 'InvalidArgument' `
                    -ErrorId "InvalidParameter" `
                    -CategoryReason "The Parameters parameter must be of type System.Collections.Hashtable." `
                    -CategoryTargetName "${Parameters}" `
                    -TargetObject "${Parameters}" `
                    -CategoryTargetType 'System.Collections.Hashtable' `
                    -ErrorAction 'Stop';
            }
        }

        [System.Object[]] $Private:__Commands = @();
        [System.String] $Private:__Command = "";
        [System.Boolean] $Private:__Added = $false;
    }
    
     Process {
        foreach ($Private:__Verb in ${Verbs}) {
            $__Added = ${false};

            foreach ($Private:__Property in  (${__Command} = Get-Command -Name "${Noun}-${__Verb}" -ErrorAction SilentlyContinue).Parameters.Keys) {
                if (-not ${__Added}) {
                    $__Commands += @{"${__Command}" = @{}};
                    $__Added = ${true};

                    if (${null} -eq (Get-Variable -Name __Index -ErrorAction SilentlyContinue)) {
                        [System.UInt32] $Private:__Index = 0;
                    } else {
                        ${__Index}++;
                    }
                }

                if ((${PSBoundParameters}).ContainsKey('Parameters')) {
                    foreach ($Private:__Passed_Property in ${Parameters}.Keys) {
                        if (${__Passed_Property} -eq ${__Property}) {
                            (${__Commands}[${__Index}]).${__Command}.${__Property} = $(${Parameters}.${__Passed_Property});
                        }
                    }
                } else {
                    break;
                }
            }
        }
    }

    End {
        for($__Index = 0; ${__Index} -lt ${__Commands}.Count; ${__Index}++) {
            foreach ($Private:__Item in  ${__Commands}[${__Index}].Keys) {
                try {
                    [System.Collections.Hashtable] $Private:__Parameters = ${__Commands}[${__Index}].${__Item};
                     . ${__Item} @__Parameters @Arguments;
                } catch {
                    . ${__Item} @__Parameters;
                }
            }
        }
        return ${null};
    }
}
