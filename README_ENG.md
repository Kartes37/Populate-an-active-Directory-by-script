Here is my summary of the process I followed to create a script, using the tools of the 21st century, to populate an Active Directory with a PowerShell script.
This script is fed with two .CSV files that contain the list of users I chose to add to the Active Directory.

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
