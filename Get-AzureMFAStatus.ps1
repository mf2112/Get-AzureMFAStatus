<#
.Synopsis
   Get Azure MFA status
.DESCRIPTION
   Get Azure MFA status for a user or group of users
.EXAMPLE
   Get-AzureMFAStatus <useremail@address.addr>
.INPUTS
   Get-MsolUser -All | Where-Object {$_.title -ne $null} | Select-Object userprincipalname | Get-AzureMFAStatus
   'user1email@address.com','user2email@address.com' | Get-AzureMFAStatus
.OUTPUTS
   UserName	Email	MFAStatus	Method0	Default0	Method1	Default1
.NOTES
   General notes
.FUNCTIONALITY
   General function to get user's MFA status and configured methods and which is set to default.
   Accepts pipeline input or runs with parameters.
#>
# Define Get-AzureMFAStatus function
function Get-AzureMFAStatus
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
              If ($_ -match "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$") {
                $True
              }
              else {
                Write-Output "$_ is not a correctly formatted email address"
              }
            })]
        [String[]]$UserPrincipalName
    )

    Begin
    {
    }
    Process
    {
    ForEach ($upn in $UserPrincipalName) {
    $user = Get-MsolUser -UserPrincipalName $upn
        # If MFA has been enabled or enforced, collect the methods and which is default
        if ($user.StrongAuthenticationRequirements.State) {
        $mfaStatus = $user.StrongAuthenticationRequirements.State
        $usermethod0 = $user.StrongAuthenticationMethods[0].MethodType
        $userdefault0 = $user.StrongAuthenticationMethods[0].IsDefault
        $usermethod1 = $user.StrongAuthenticationMethods[1].MethodType
        $userdefault1 = $user.StrongAuthenticationMethods[1].IsDefault
        }
        # If MFA has not been enabled yet, set results
        else {
        $mfaStatus = "Disabled"
        $usermethod0 = "None"
        $userdefault0 = "None"
        $usermethod1 = "None"
        $userdefault1 = "None"
        }

    # Set up result object with all collected or set properties   
    $Result = New-Object PSObject -property @{ 
    UserName = $user.DisplayName
    Email = $user.UserPrincipalName
    MFAStatus = $mfaStatus
    Method0 = $usermethod0
    Default0 = $userdefault0
    Method1 = $usermethod1
    Default1 = $userdefault1
    }
    Write-Output $Result
    }
    }
    End
    {
    }
}
