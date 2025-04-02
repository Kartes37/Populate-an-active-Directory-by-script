# Import the Active Directory module
Import-Module ActiveDirectory

# Define the CSV file paths
$normalUsersCsv = "C:\Users\Administrateur\Documents\TestScriptAD\UserADT.csv"
$adminUsersCsv = "C:\Users\Administrateur\Documents\TestScriptAD\User_AdminT.csv"

# Define the domain
$domain = "doudou.loc"

# Function to create a user in Active Directory
function Create-ADUserFromCSV {
    param (
        [string]$csvPath,
        [string]$ou,
        [switch]$isAdmin
    )

    # Import the CSV file
    $users = Import-Csv -Path $csvPath

    foreach ($user in $users) {
        $firstName = $user.FirstName
        $lastName = $user.LastName
        $username = $user.Username
        $password = $user.Password
        $fullName = "$firstName $lastName"

        # Create the user in AD
        New-ADUser -Name $fullName `
                   -GivenName $firstName `
                   -Surname $lastName `
                   -SamAccountName $username `
                   -UserPrincipalName "$username@$domain" `
                   -Path "OU=$ou,$domain" `
                   -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
                   -Enabled $true

        # If the user is an admin, add them to the Domain Admins group
        if ($isAdmin) {
            Add-ADGroupMember -Identity "Domain Admins" -Members $username
        }
    }
}

# Create normal users
Create-ADUserFromCSV -csvPath $normalUsersCsv -ou "NormalUsers"

# Create admin users
Create-ADUserFromCSV -csvPath $adminUsersCsv -ou "AdminUsers" -isAdmin

Write-Host "Users have been created successfully in Active Directory."
