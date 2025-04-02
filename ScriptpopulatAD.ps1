Import-Module ActiveDirectory

# Définition des chemins des fichiers CSV
$csvNormalUsers = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\UserADT.csv"
$csvAdminUsers = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\User_AdminT.csv"

# Création des OUs si elles n'existent pas
$ouNormalUsers = "OU=NormalUsers,DC=doudou,DC=loc"
$ouAdminUsers = "OU=AdminUsers,DC=doudou,DC=loc"

if (-not (Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $ouNormalUsers} -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "NormalUsers" -Path "DC=doudou,DC=loc" -ProtectedFromAccidentalDeletion $false
    Write-Host "✅ L'OU $ouNormalUsers a été créée."
} else {
    Write-Host "✅ L'OU $ouNormalUsers existe déjà."
}

if (-not (Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $ouAdminUsers} -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "AdminUsers" -Path "DC=doudou,DC=loc" -ProtectedFromAccidentalDeletion $false
    Write-Host "✅ L'OU $ouAdminUsers a été créée."
} else {
    Write-Host "✅ L'OU $ouAdminUsers existe déjà."
}

# Vérification de l'existence du groupe "Domain Admins"
$domainAdminsGroup = Get-ADGroup -Filter {Name -eq "Domain Admins"} -ErrorAction SilentlyContinue
if (-not $domainAdminsGroup) {
    Write-Host "❌ Erreur : Le groupe 'Domain Admins' n'existe pas dans Active Directory."
}

# Fonction pour créer les utilisateurs
function New-ADUserFromCSV {
    param (
        [string]$csvFile,
        [string]$ouPath,
        [bool]$isAdmin
    )
    
    if (!(Test-Path $csvFile)) {
        Write-Host "❌ Erreur : Le fichier CSV $csvFile est introuvable !"
        return
    }
    
    $users = Import-Csv -Path $csvFile -Delimiter ";"
    
    foreach ($user in $users) {
        $username = $user.username
        $firstName = $user.first_name
        $lastName = $user.last_name
        $email = $user.email
        $password = $user.Password
        
        # Vérifier si l'utilisateur existe déjà
        if (Get-ADUser -Filter {SamAccountName -eq $username} -ErrorAction SilentlyContinue) {
            Write-Host "⚠️ L'utilisateur $username existe déjà, aucune modification effectuée."
            continue
        }
        
        # Création de l'utilisateur
        New-ADUser -SamAccountName $username `
                    -UserPrincipalName "$username@doudou.loc" `
                    -GivenName $firstName `
                    -Surname $lastName `
                    -Name "$firstName $lastName" `
                    -EmailAddress $email `
                    -Path $ouPath `
                    -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
                    -Enabled $true `
                    -PasswordNeverExpires $true
        
        Write-Host "✅ Utilisateur $username créé avec succès !"
        
        # Ajouter l'utilisateur au groupe Domain Admins s'il est admin
        if ($isAdmin -and $domainAdminsGroup) {
            Add-ADGroupMember -Identity "Domain Admins" -Members $username
            Write-Host "🔹 Utilisateur $username ajouté au groupe Domain Admins."
        }
    }
}

# Création des utilisateurs depuis les fichiers CSV
New-ADUserFromCSV -csvFile $csvNormalUsers -ouPath $ouNormalUsers -isAdmin $false
New-ADUserFromCSV -csvFile $csvAdminUsers -ouPath $ouAdminUsers -isAdmin $true

Write-Host "✅ Tous les utilisateurs ont été traités avec succès."

