# Définition des chemins des fichiers CSV
$csvNormalUsers = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\UserADT.csv"
$csvAdminUsers = "C:\Users\Administrateur\Documents\TestScriptAD\Populate-an-active-Directory-by-script-main\User_AdminT.csv"

# Vérification de l'existence des fichiers CSV
if (!(Test-Path $csvNormalUsers) -or !(Test-Path $csvAdminUsers)) {
    Write-Host "❌ Erreur : Un ou plusieurs fichiers CSV sont introuvables !" -ForegroundColor Red
    exit
}

# Création des OUs si elles n'existent pas
$ouNormalUsers = "OU=NormalUsers,DC=doudou,DC=loc"
$ouAdminUsers = "OU=AdminUsers,DC=doudou,DC=loc"

foreach ($ou in @($ouNormalUsers, $ouAdminUsers)) {
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ou'")) {
        New-ADOrganizationalUnit -Name ($ou -split ",")[0].Substring(3) -Path "DC=doudou,DC=loc"
        Write-Host "✅ L'OU $ou a été créée." -ForegroundColor Green
    } else {
        Write-Host "✅ L'OU $ou existe déjà." -ForegroundColor Green
    }
}

# Vérification et création du groupe "Domain Admins"
$groupName = "Domain Admins"
$group = Get-ADGroup -Filter "Name -eq '$groupName'"
if (!$group) {
    New-ADGroup -Name $groupName -GroupScope Global -GroupCategory Security -Path "CN=Users,DC=doudou,DC=loc"
    Write-Host "✅ Le groupe '$groupName' a été créé." -ForegroundColor Green
} else {
    Write-Host "✅ Le groupe '$groupName' existe déjà." -ForegroundColor Green
}

# Fonction pour ajouter des utilisateurs depuis un fichier CSV
function Add-UsersFromCSV {
    param (
        [string]$csvPath,
        [string]$ouPath,
        [bool]$isAdmin
    )
    
    $users = Import-Csv -Path $csvPath -Delimiter ";"
    
    foreach ($user in $users) {
        $username = $user.username
        
        if (Get-ADUser -Filter "SamAccountName -eq '$username'") {
            Write-Host "⚠️ L'utilisateur $username existe déjà, aucune modification effectuée." -ForegroundColor Yellow
        } else {
            $password = ConvertTo-SecureString $user.Password -AsPlainText -Force
            New-ADUser -SamAccountName $username -UserPrincipalName "$username@doudou.loc" `
                        -GivenName $user.first_name -Surname $user.last_name -EmailAddress $user.email `
                        -Name "$($user.first_name) $($user.last_name)" -Path $ouPath -AccountPassword $password `
                        -Enabled $true
            Write-Host "✅ Utilisateur $username créé avec succès !" -ForegroundColor Green
            
            if ($isAdmin) {
                Add-ADGroupMember -Identity $groupName -Members $username
                Write-Host "🔹 Utilisateur $username ajouté au groupe $groupName." -ForegroundColor Cyan
            }
        }
    }
}

# Ajout des utilisateurs
Add-UsersFromCSV -csvPath $csvNormalUsers -ouPath $ouNormalUsers -isAdmin $false
Add-UsersFromCSV -csvPath $csvAdminUsers -ouPath $ouAdminUsers -isAdmin $true

Write-Host "✅ Tous les utilisateurs ont été traités avec succès." -ForegroundColor Green
