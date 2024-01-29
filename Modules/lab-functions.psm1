Import-Module -Force "${PSScriptRoot}\functions.psm1";

Function Update-OrganizationalUnit() {
    [CmdletBinding()] param (
        [Parameter()][ValidateSet('New', 'Set', 'Remove', 'Get')] $Action = 'Get',
        [Parameter()][Switch] $GetRoot,
        [Parameter()][System.String] $OuPath
    );

    Begin {
        [System.Object[]] $Private:__Root = ((Get-ADOrganizationalUnit -Filter * | Select-Object -Property DistinguishedName | Where-Object -Property DistinguishedName -Like "*Domain Controllers*").DistinguishedName.Split(','));
        [System.String] $Private:__Distinguished_Name_Root = "";

        for ($Private:__Index = 1; ${__Index} -lt ${__Root}.Count; ${__Index}++) {
            $__Distinguished_Name_Root += ",$(${__Root}[${__Index}])";
        }

        Remove-Variable -Name __Root;

        Use-WindowsFeature -Features @('AD-Domain-Services');
        Add-Modules -Modules @('ActiveDirectory');

        if ((${PSBoundParameters}).ContainsKey('OuPath')) {
            [System.String] $Private:__OuMatch = Get-ADOrganizationalUnit -Filter "Name -Like `"*${OuPath}*`"" | Select-Object -ExpandProperty 'DistinguishedName' -ErrorAction SilentlyContinue;
        }
        
        if (${GetRoot}) {
            if ((${PSBoundParameters}).ContainsKey('OuPath') -and "" -ne "${__OuMatch}") {
                return "${__OuMatch}";
            } else {
                return "$(${__Distinguished_Name_Root}.Substring(1))";
            }
        } elseif (${Action} -eq 'GetOuRoot') {
            
        }else {
            [System.String] $Private:__Command = Get-Command -Name "${Action}-ADOrganizationalUnit";

        }
    }
}

