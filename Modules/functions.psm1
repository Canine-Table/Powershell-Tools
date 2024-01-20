function Show-Menu() {

    [CmdletBinding()] param (
        [Parameter()][System.Collections.Hashtable] $Choices,
        [Parameter()][System.String] $ErrorMessage = "please try again.`n",
        [Parameter()][System.String] $PromptString = "Enter a digit between"
    );

    Begin {
        if ($Choices -isnot [System.Collections.Hashtable]) {
            Write-Error -Message "You must supply a hash map the options parameter to use this function." `
                                -Exception 'System.Exception' `
                                -Category 'InvalidArgument' `
                                -ErrorId "InvalidParameter" `
                                -CategoryReason "The Choices parameter must be a hashtable object." `
                                -CategoryTargetName "$Choices" `
                                -TargetObject $Choices `
                                -CategoryTargetType 'System.Collections.Hashtable' `
                                -ErrorAction 'Stop';
        }

        [System.Array]  $Private:__Menu = New-Object -TypeName System.Collections.Generic.List[System.String];
        [System.UInt32] $Private:__Index = New-Object -TypeName System.UInt32;
        [System.Boolean] $Private:__Exception = New-Object -TypeName System.Boolean;
    }

    Process {
        foreach ($Private:__Key in $Choices.Keys) {
                $__Menu += @{$__Key = $Choices[$__Key]};
        }
    }

    End {
        do {
                $__Exception = $false;
                
                if ($null -ne (Get-Variable -Name __Response -ErrorAction SilentlyContinue)) {
                    Write-Host -ForegroundColor  White -BackgroundColor DarkRed " '$__Response' is not a one of the options, $ErrorMessage`n";
                } else {
                    [System.String] $Private:__Response;
                }

                for ($__Index = 0; $__Index -lt $Choices.Count; $__Index++) {
                    Write-Host " " ($__Index + 1) ") " $__Menu[$__Index].Keys[0] ": " $__Menu[$__Index].Values[0];
                }

                Write-Host -ForegroundColor White -BackgroundColor DarkBlue -NoNewline "`n $PromptString [1-${__Index}]: ";
                $__Response = Read-Host;
                Write-Host;

            try {
                $__Response = [System.Convert]::ToUInt32("$__Response");
            }  catch {
                $__Exception = $true;
            }

        } while ($__Response -lt 1 -or $__Response -gt $__Index -or $__Exception -ne $false);

        return $__Menu[$__Response - 1].Keys[0];
    }
}