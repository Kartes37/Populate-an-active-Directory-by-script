# Import the Active Directory module to interact with Active Directory.
Import-Module ActiveDirectory

# Define the paths for the CSV files containing the user information.
$normalUsersCsv = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\UserADT.csv"
$adminUsersCsv = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\User_AdminT.csv"

# Define the domain to be used for the users.
$domain = "doudou.loc"

# Function to create a user in Active Directory from a CSV file.
function Create-ADUserFromCSV {
    param (
        [string]$csvPath,  # Path to the CSV file to import.
        [string]$ou,  # Organizational Unit (OU) where the user will be created in AD.
        [switch]$isAdmin  # Whether the user should be added to the "Domain Admins" group.
    )

    # Import the CSV file containing user information.
    $users = Import-Csv -Path $csvPath -Delimiter ";"

    # Loop through each user in the CSV file.
    foreach ($user in $users) {
        # Retrieve user information from the CSV file.
        $firstName = $user.first_name
        $lastName = $user.last_name
        $username = $user.username
        $password = $user.Password
        $fullName = "$firstName $lastName"  # Full name of the user.

        # Create the user in Active Directory with the extracted information.
        New-ADUser -Name $fullName `
                   -GivenName $firstName `
                   -Surname $lastName `
                   -SamAccountName $username `
                   -UserPrincipalName "$username@$domain" `
                   -Path "OU=$ou,$domain" `
                   -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
                   -Enabled $true

        # If the user should be an admin, add the user to the "Domain Admins" group.
        if ($isAdmin) {
            # Attempt to add the user to the "Domain Admins" group in Active Directory.
            try {
                Add-ADGroupMember -Identity "Domain Admins" -Members $username
                Write-Host "User $username added to Domain Admins group." -ForegroundColor Green
            } catch {
                # If the "Domain Admins" group doesn't exist, display an error message.
                Write-Host "Error: 'Domain Admins' group does not exist." -ForegroundColor Red
            }
        }
    }
}

# Create normal users from the CSV file.
Create-ADUserFromCSV -csvPath $normalUsersCsv -ou "NormalUsers"

# Create admin users from the CSV file.
Create-ADUserFromCSV -csvPath $adminUsersCsv -ou "AdminUsers" -isAdmin

Write-Host "All users have been processed successfully." -ForegroundColor Green
