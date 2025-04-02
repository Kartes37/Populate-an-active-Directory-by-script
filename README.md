#Here is my summary of the process I followed to create a script, using the tools of the 21st century, to populate an Active Directory with a PowerShell script.
This script is fed with two .CSV files that contain the list of users I chose to add to the Active Directory.

#This script can be used without giving me credit for its creation or use. However, I do not take responsibility if something goes wrong with your usage.

1. Preparing the CSV Files

    Creating the CSV Files: You prepared two CSV files containing the user information to be imported into Active Directory.

        UserADT.csv: Normal users

        User_AdminT.csv: Administrator users These files contain the following columns: username, first_name, last_name, email, password.

2. Configuring Organizational Units (OU)

    You created two Organizational Units (OUs) in Active Directory:

        NormalUsers for regular users.

        AdminUsers for administrators.

    The OUs were manually created using PowerShell if they didn’t already exist. This process ensured that the users would be correctly organized within Active Directory.

3. Creating the PowerShell Script

    Importing the Active Directory module: The ActiveDirectory module was imported to interact with Active Directory.

    Defining the CSV file paths: The absolute paths of the CSV files were specified to ensure that the script could locate them.

    Create-ADUserFromCSV Function: A PowerShell function was created to:

        Read data from the CSV files.

        Create users in the appropriate OUs (NormalUsers or AdminUsers).

        Set the password and other properties like SamAccountName and UserPrincipalName.

        Add administrator users to the "Domain Admins" group if necessary.

4. Running the Script

    The script was executed to:

        Create users in Active Directory from the CSV files.

        Check if a user already exists, and if so, avoid recreating them (prevent duplicates).

        Add administrator users to the "Domain Admins" group if the CSV indicated they were administrators.

        Display feedback messages indicating the success or failure of user creation.

5. Error Handling

    Handling errors for already existing users: The script handled the case where a user already exists in Active Directory and avoided recreating them.

    Errors related to the "Domain Admins" group not found: If the "Domain Admins" group didn’t exist in Active Directory, the script displayed an error message indicating that it couldn't add the user to the group.

6. Finalization

    After running the script, all users were successfully created in their respective OUs, and administrators were added to the "Domain Admins" group.

    Error checks helped handle duplicate issues or missing groups.




   French version:

   

   
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
  
