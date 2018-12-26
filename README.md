# Get-AzureMFAStatus
This function will accept a list of current O365 users emails, then pull their Azure MFA setting and the methods if it is Enabled or Enforced.

It write normal output to the pipeline

Get-AzureMFAStatus <useremail@address.addr>

Get-MsolUser -All | Where-Object {$_.title -ne $null} | Select-Object userprincipalname | Get-AzureMFAStatus

'user1email@address.com','user2email@address.com' | Get-AzureMFAStatus
