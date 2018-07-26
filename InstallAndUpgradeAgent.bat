@echo off

::Please change these variables. 
::Note that the agent_installation_dir agent_conf_dir MUST be a full path. 
SET msi_file_path=dotNetAgentSetup64-4.4.3.2209.msi
SET log_path="C:\logs\InstallAppDynamicsLogs.log"
SET config_file_path="C:\MOORS_template.xml"
SET agent_installation_dir="C:\AppDynamics"
SET agent_conf_dir="C:\AppDynamics\DotNetAgent"

::Check if agent exists 
echo Checking if AppDynamics Agent Exist 
SET cmd="wmic product get name| find /I "AppDynamics .NET Agent" "
FOR /F "tokens=*" %%i IN (' %cmd% ') DO (SET agent=%%i)
echo %agent%|find "AppDynamics .NET Agent" >nul
::this returs 1 if agent is not found and 0 if found 
IF errorlevel 0 (

    echo found agent
    :: It is ideal to take a backup of the existing config at this point, but XXXa usecase doen't require it
    echo uninstalling any existing AppDynamics Agent

    wmic product where name="AppDynamics .NET Agent" call uninstall

)else ( echo agent is not install )

echo installing  the new agent...

msiexec /i %msi_file_path% /q /norestart /lv log_path AD_SetupFile=%config_file_path% INSTALLDIR=%agent_installation_dir% DOTNETAGENTFOLDER=%agent_conf_dir%

echo starting the Agent Service...

net start AppDynamics.Agent.Coordinator

echo Completed!

