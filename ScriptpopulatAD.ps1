# Importation du module Active Directory
Import-Module ActiveDirectory

# Définition des chemins des fichiers CSV
$csvFolder = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main"
$normalUsersCsv = "$csvFolder\UserADT.csv"
$adminUsersCsv = "$csvFolder\User_AdminT.csv"

# Récupérer le Distinguished Name du domaine
$domainDN = (Get-ADDomain).DistinguishedName

# Liste des OUs à vérifier/créer
$ouList = @("NormalUsers", "AdminUsers")

# Création des OUs si elles n'existent pas
foreach ($ou in $ouList) {
    $ouPath = "OU=$ou,$domainDN"
    if (-not (Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $ouPath} -ErrorAction SilentlyContinue)) {
        Write-Host "⚠️ L'OU $ouPath n'existe pas. Création en cours..."
        New-ADOrganizationalUnit -Name $ou -Path $domainDN -ErrorAction Stop
        Write-Host "✅ L'OU $ouPath a été créée avec succès."
    } else {
        Write-Host "✅ L'OU $ouPath existe déjà."
    }
}

# Fonction pour créer un utilisateur à partir d'un fichier CSV
function Create-ADUserFromCSV {
    param (
        [string]$csvPath,
        [string]$ou,
        [switch]$isAdmin
    )

    # Vérifier si le fichier CSV existe
    if (-not (Test-Path $csvPath)) {
        Write-Host "❌ Erreur : Le fichier CSV $csvPath est introuvable !" -ForegroundColor Red
        return
    }

    # Définir le chemin complet de l'OU
    $ouPath = "OU=$ou,$domainDN"

    # Importer les utilisateurs depuis le fichier CSV avec le délimiteur point-virgule
    $users = Import-Csv -Path $csvPath -Delimiter ";"

    # Vérifier que le CSV contient bien des données
    if ($users.Count -eq 0) {
        Write-Host "❌ Erreur : Le fichier CSV $csvPath est vide ou mal formaté !" -ForegroundColor Red
        return
    }

    foreach ($user in $users) {
        # Vérifier que toutes les colonnes nécessaires existent
        if (-not ($user.PSObject.Properties['FirstName'] -and 
                  $user.PSObject.Properties['LastName'] -and 
                  $user.PSObject.Properties['Username'] -and 
                  $user.PSObject.Properties['Password'])) {
            Write-Host "❌ Erreur : Une ligne du fichier CSV est mal formatée !" -ForegroundColor Red
            continue
        }

        $firstName = $user.FirstName
        $lastName = $user.LastName
        $username = $user.Username
        $password = $user.Password
        $fullName = "$firstName $lastName"

        # Vérifier si l'utilisateur existe déjà
        if (Get-ADUser -Filter {SamAccountName -eq $username} -ErrorAction SilentlyContinue) {
            Write-Host "⚠️ L'utilisateur $username existe déjà dans Active Directory."
        } else {
            # Création de l'utilisateur en Active Directory
            New-ADUser -Name $fullName `
                       -GivenName $firstName `
                       -Surname $lastName `
                       -SamAccountName $username `
                       -UserPrincipalName "$username@$domainDN" `
                       -Path $ouPath `
                       -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
                       -Enabled $true

            Write-Host "✅ Utilisateur $username créé avec succès."

            # Si l'utilisateur est admin, l'ajouter au groupe "Domain Admins"
            if ($isAdmin) {
                Add-ADGroupMember -Identity "Domain Admins" -Members $username
                Write-Host "🔹 Utilisateur $username ajouté aux Domain Admins."
            }
        }
    }
}

# Création des utilisateurs normaux
Create-ADUserFromCSV -csvPath $normalUsersCsv -ou "NormalUsers"

# Création des utilisateurs administrateurs
Create-ADUserFromCSV -csvPath $adminUsersCsv -ou "AdminUsers" -isAdmin

Write-Host "✅ Tous les utilisateurs ont été traités avec succès !" -ForegroundColor Green
