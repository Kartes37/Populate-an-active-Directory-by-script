# Populate-an-active-Directory-by-script

##populate by scrip an active directory

##This script can be used and dont take credit for its creation or use. But i dont take the blame if something goes wrong with your utilisation

1. Préparation des fichiers CSV

    Création des fichiers CSV : Tu as préparé deux fichiers CSV contenant les informations des utilisateurs à importer dans Active Directory.

        UserADT.csv : Utilisateurs normaux

        User_AdminT.csv : Utilisateurs administrateurs Ces fichiers contiennent les colonnes suivantes : username, first_name, last_name, email, password.

2. Configuration des Unités d'Organisation (OU)

    Tu as créé deux unités d'organisation (OU) dans Active Directory :

        NormalUsers pour les utilisateurs classiques.

        AdminUsers pour les administrateurs.

    Les OU ont été créées manuellement à l'aide de PowerShell si elles n'existaient pas déjà. Ce processus a assuré que les utilisateurs soient correctement organisés dans Active Directory.

3. Création du Script PowerShell

    Importation du module Active Directory : Le module ActiveDirectory a été importé pour permettre l'interaction avec Active Directory.

    Définition des chemins des fichiers CSV : Les chemins absolus des fichiers CSV ont été définis pour s'assurer que le script puisse localiser les fichiers.

    Fonction Create-ADUserFromCSV : Une fonction PowerShell a été créée pour :

        Lire les données des fichiers CSV.

        Créer les utilisateurs dans les OU appropriées (NormalUsers ou AdminUsers).

        Configurer le mot de passe et d'autres propriétés comme SamAccountName et UserPrincipalName.

        Ajouter les utilisateurs administrateurs au groupe "Domain Admins" si nécessaire.

4. Exécution du Script

    Le script a été exécuté pour :

        Créer les utilisateurs dans Active Directory à partir des fichiers CSV.

        Vérifier si un utilisateur existait déjà, et le cas échéant, ne pas le recréer (éviter les doublons).

        Ajouter les utilisateurs administrateurs au groupe "Domain Admins" si le fichier CSV indiquait qu'ils étaient administrateurs.

        Afficher des messages de retour indiquant le succès ou l'échec de la création des utilisateurs.

5. Gestion des Erreurs

    Gestion des erreurs pour les utilisateurs déjà existants : Le script a pris en compte le cas où un utilisateur existe déjà dans Active Directory et a évité de le recréer.

    Erreurs de groupe "Domain Admins" non trouvé : Si le groupe "Domain Admins" n'existait pas dans Active Directory, le script affichait un message d'erreur pour indiquer qu'il n'a pas pu ajouter l'utilisateur au groupe.

6. Finalisation

    Après avoir exécuté le script, tous les utilisateurs ont été créés avec succès dans leurs OU respectives, et les administrateurs ont été ajoutés au groupe "Domain Admins".

    La vérification des erreurs a permis de gérer les problèmes de doublons ou de groupes manquants.
