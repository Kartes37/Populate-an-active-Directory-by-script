# Importation du module Active Directory pour pouvoir interagir avec Active Directory.
Import-Module ActiveDirectory

# Définition des chemins des fichiers CSV contenant les informations des utilisateurs.
$normalUsersCsv = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\UserADT.csv"
$adminUsersCsv = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\User_AdminT.csv"

# Définition du domaine utilisé pour les utilisateurs.
$domain = "doudou.loc"

# Fonction pour créer un utilisateur dans Active Directory à partir d'un fichier CSV.
function Create-ADUserFromCSV {
    param (
        [string]$csvPath,  # Chemin du fichier CSV à importer.
        [string]$ou,  # Unité organisationnelle (OU) où l'utilisateur sera créé dans AD.
        [switch]$isAdmin  # Si l'utilisateur doit être ajouté au groupe "Domain Admins".
    )

    # Importation du fichier CSV contenant les informations des utilisateurs.
    $users = Import-Csv -Path $csvPath -Delimiter ";"

    # Boucle à travers chaque utilisateur dans le fichier CSV.
    foreach ($user in $users) {
        # Récupération des informations des utilisateurs depuis le fichier CSV.
        $firstName = $user.first_name
        $lastName = $user.last_name
        $username = $user.username
        $password = $user.Password
        $fullName = "$firstName $lastName"  # Nom complet de l'utilisateur.

        # Création de l'utilisateur dans Active Directory avec les informations extraites.
        New-ADUser -Name $fullName `
                   -GivenName $firstName `
                   -Surname $lastName `
                   -SamAccountName $username `
                   -UserPrincipalName "$username@$domain" `
                   -Path "OU=$ou,$domain" `
                   -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
                   -Enabled $true

        # Si l'utilisateur doit être un administrateur, ajout de l'utilisateur au groupe "Domain Admins".
        if ($isAdmin) {
            # Tentative d'ajout de l'utilisateur au groupe "Domain Admins" dans Active Directory.
            try {
                Add-ADGroupMember -Identity "Domain Admins" -Members $username
                Write-Host "User $username added to Domain Admins group." -ForegroundColor Green
            } catch {
                # Si le groupe "Domain Admins" n'existe pas, afficher un message d'erreur.
                Write-Host "Error: 'Domain Admins' group does not exist." -ForegroundColor Red
            }
        }
    }
}

# Création des utilisateurs normaux à partir du fichier CSV.
Create-ADUserFromCSV -csvPath $normalUsersCsv -ou "NormalUsers"

# Création des utilisateurs administrateurs à partir du fichier CSV.
Create-ADUserFromCSV -csvPath $adminUsersCsv -ou "AdminUsers" -isAdmin

Write-Host "All users have been processed successfully." -ForegroundColor Green
