@echo off

REM =============================================
REM  Add User to Entra Security Group
REM  Usage: add_user_to_group.bat <USER_UPN> <GROUP_NAME>
REM  Example: add_user_to_group.bat john@contoso.com "SG-Developers"
REM =============================================

REM -- Validate Arguments --
IF "%~1"=="" (
    echo ERROR: Missing USER_UPN argument.
    echo Usage: %~nx0 ^<USER_UPN^> ^<GROUP_NAME^>
    echo Example: %~nx0 john@contoso.com "SG-Developers"
    rem pause
    exit /b 1
)

IF "%~2"=="" (
    echo ERROR: Missing GROUP_NAME argument.
    echo Usage: %~nx0 ^<USER_UPN^> ^<GROUP_NAME^>
    echo Example: %~nx0 john@contoso.com "SG-Developers"
    rem pause
    exit /b 1
)

REM -- Set Arguments --
SET USER_UPN=%~1
SET GROUP_NAME=%~2

REM -- Login to Azure --
REM -- assume you already login via az cli --
rem az login

REM -- Get User Object ID --
FOR /F "delims=" %%i IN ('az ad user show --id "%USER_UPN%" --query id --output tsv') DO SET USER_OID=%%i
IF "%USER_OID%"=="" (
    echo ERROR: Could not find user with UPN: %USER_UPN%
    pause
    exit /b 1
)
echo User Object ID: %USER_OID%

REM -- Get Group Object ID --
FOR /F "delims=" %%i IN ('az ad group show --group "%GROUP_NAME%" --query id --output tsv') DO SET GROUP_OID=%%i
IF "%GROUP_OID%"=="" (
    echo ERROR: Could not find group with name: %GROUP_NAME%
    pause
    exit /b 1
)
echo Group Object ID: %GROUP_OID%

REM -- Add User to Group --
az ad group member add --group %GROUP_OID% --member-id %USER_OID%
echo User %USER_UPN% has been added to group: %GROUP_NAME%

REM -- Verify --
echo.
echo ---- Current Members of %GROUP_NAME% ----
az ad group member list --group %GROUP_OID% --query "[].{Name:displayName, UPN:userPrincipalName}" --output table

rem pause