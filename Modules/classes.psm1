Import-Module -Force "${PSScriptRoot}\functions.psm1";

class Hive {
    hidden [System.Collections.Hashtable] $__Hives;
    hidden [System.String] $__Location;

    Hive () {}

    Hive ([System.String] $_Location) {
        $this.TestLocation($_Location);
    }

    Hive ([System.Collections.Hashtable] $_Hives) {
        $this.__Hives = $_Hives;
    }

    Hive ([System.String] $_Location, [System.Collections.Hashtable] $_Hives) {
        $this.__TestLocation($_Location);
        $this.__Hives = $_Hives;
    }

    [Hive] SetLocation([System.String] $Location) {
        $this.TestLocation($Location);
        return $this;
    }

    [Hive] SetHives([System.Collections.Hashtable] $_Hives) {
        $this.ClearHives();
        $this.__Hives = $_Hives;
        return $this;
    }

    [Hive] AddHives([System.Collections.Hashtable] $_Hives) {
        $this.__Hives.Add($_Hives);
        return $this;
    }

    [Hive] ExecuteHives() {
        foreach ($_Hive in $this.__Hives.Keys) {
            if ($null -eq (Get-ItemProperty -LiteralPath $this.__Location -Name $_Hive -ErrorAction SilentlyContinue)) {
                Write-Host -ForegroundColor White -BackgroundColor DarkRed " You do not have a Leaf called '" $_Hive "' in the '" $this.__Location "' container. `n";
               
                [System.String] $__PropertyType = Show-Menu -Choices @{
                    'String' = 'A text value.'
                    'Binary' = 'A binary value.'
                    'DWord' = 'A 32-bit numeric value.'
                    'QWord' = 'A 64-bit numeric value.'
                    'MultiString' = 'An array of text values.'
                    'ExpandString' = 'A text value that contains environment variables that are expanded when the value is retrieved.'
                    'Cancel' = 'To decide or announce that (a planned or scheduled event) will not take place.'
                };

                if ($__PropertyType -eq "Cancel") {
                    continue;
                }

                New-ItemProperty -LiteralPath $this.__Location -Name $_Hive -Value $this.__Hives[$_Hive] -Confirm -PropertyType $__PropertyType;
                continue;
            }

            if ((Get-ItemPropertyValue -LiteralPath $this.__Location -Name $_Hive) -ne $this.__Hives[$_Hive]) {
                Set-ItemProperty -Path $this.__Location -Name $_Hive -Value $this.__Hives[$_Hive] -Confirm;
            }
        }

        return $this;
    }

    [Hive] ClearHives() {
        if (($this.__Hives.Count) -gt 0) {
            $this.__Hives.Clear();
        }

        return $this;
    }

    [Hive] GetPendingHives() {
        foreach($_Hive in $this.__Hives.Keys) {
            Write-Host -ForegroundColor White -BackgroundColor DarkMagenta " " $_Hive "  =  " $this.__Hives[$_Hive] " ";
        }

        return $this;
    }

    [Hive] GetHives() {
        foreach ($_Hive in (Get-Item -LiteralPath $this.__Location | Select-Object -ExpandProperty Property)) {
            Write-Host -ForegroundColor White -BackgroundColor DarkCyan " " $_Hive "  =  "  (Get-ItemPropertyValue -LiteralPath $this.__Location -Name $_Hive) " ";
        }

        return $this;
    }

    [Hive] GetLocation() {
        Write-Host -ForegroundColor White -BackgroundColor Blue " " $this.__Location " ";
        return $this;
    }

    hidden [void] TestLocation([System.String] $_Location) {
        if ((Test-Path -PathType Container -Path $_Location)) {
            $this.__Location = $_Location;
        } else {
            Write-Error -Message "Invalid registry container '$_Location' because it does not exist." `
                        -ErrorId 'PathNotFound,Microsoft.PowerShell.Commands.GetItemPropertyCommand' `
                        -Exception 'System.Management.Automation.ItemNotFoundException' `
                        -Category 'ObjectNotFound' `
                        -CategoryReason 'ItemNotFoundException' `
                        -CategoryTargetName $_Location `
                        -TargetObject  $_Location `
                        -CategoryTargetType 'String' `
                        -ErrorAction 'Stop';
        }
    }

    [Void] Done() {}
}
