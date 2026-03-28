```powershell
[System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.AccountManagement")  
$principalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, '<domain>')  
$principalContext.ValidateCredentials('<user>', '<password>')