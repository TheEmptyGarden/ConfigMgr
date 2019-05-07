# Name:         Install-O365ProPlus32
# Description:  Installs O365ProPlus32
# Author:   Matthew Teegarden      

try
{
  Function Main
  {
    # Function Started
    LogTraceMessage "*** Function Main Started ***"
    write-Verbose "*** Function Main Started ***"

    # Set Global Environment Variables (Inputs)
    SetGlobalEnvVariables

    # Import PS Modules
    ImportPsModules

    # Create and add more funcitons

    # Find Project
    FindProject

    # Find Visio
    FindVisio

    #Remove old Office products
    RemoveOffice

    #Remove PreviousClickToRun installations
    RemovePreviousClickToRun

    #Install O365ProPlus32
    InstallO365ProPlus32

    # Install Project 32
    InstallProject32

    #Install Visio 32
    InstallVisio32

    # ConfigMgr HINV
    ConfigMgrHINV
    
    # Function Finished
    LogTraceMessage "*** Function Main Finished ***"
    Write-Verbose "*** Function Main Finished ***"
  }

  Function SetGlobalEnvVariables
  {
    # Function Started
    LogTraceMessage "*** Function SetGlobalEnvVariables Started ***"
    Write-Verbose "*** Function SetGlobalEnvVariables Started ***"
    # Base script variables.  No modification should be necessary
    
    # Set variables with global scope
    $script:TraceState = ''
    LogTraceMessage "Variable TraceState set to $script:TraceState"
    Write-Verbose "Variable TraceState set to $script:TraceState"
    
    $script:ErrorMessage = ''
    LogTraceMessage "Variable ErrorMessage set to $script:ErrorMessage"\
    Write-Verbose "Variable ErrorMessage set to $script:ErrorMessage"

    $script:ErrorState = 0
    LogTraceMessage "Variable ErrorState set to $script:ErrorState"
    Write-Verbose "Variable ErrorState set to $script:ErrorState"

    #Script variables.  Modify as necessary
    $Script:LoggingPath = 'c:\Windows\Temp\Install-O365ProPlus32.log'
    LogTraceMessage "Variable LoggingPath set to $script:LoggingPath"
    Write-Verbose "Variable LoggingPath set to $script:LoggingPath"
    
    # Add variables here
    
    # Function Finished
    LogTraceMessage "*** Function SetGlobalEnvVariables Finished ***"
    Write-Verbose "*** Function SetGlobalEnvVariables Finished ***"
  }
  
  Function ImportPsModules
  {
    # Function Started
    LogTraceMessage "*** Function ImportPsModules Started ***"
    Write-Verbose "*** Function ImportPsModules Started ***"
  
    # Function Finished
    LogTraceMessage "*** Function ImportPsModules Finished ***"
    Write-Verbose "*** Function ImportPsModules Finished ***"
  }
  
  Function LogTraceMessage ($strMessage)
  {
    [array]$script:TraceMessage += (Get-Date).ToString() + ':  ' + $strMessage + '~~' 
  }

Function FindProject
  {
    LogTraceMessage "*** Function Find Project Started ***"
    Write-Verbose "*** Function Find Project Started ***"

    $script:ProjectProgram = "Project"
    
    $script:x64Project = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") |
       Where-Object { $_.GetValue( "DisplayName" ) -like "*$script:ProjectProgram*" } ).Length -gt 0;

    LogTraceMessage "Project x86 is $script:x86Project"
    Write-Verbose "Project x86 is $script:x86Project"

    $script:x86Project = ((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
        Where-Object { $_.GetValue( "DisplayName" ) -like "*$script:ProjectProgram*" } ).Length -gt 0;

    LogTraceMessage "Project x64 is $script:x64Project"
    Write-Verbose "Project x64 is $script:x64Project"

    LogTraceMessage "*** Function Find Project Finished ***"
    Write-Verbose "*** Function Find Project Finished ***"
  }

Function FindVisio
  {
    LogTraceMessage "*** Function Find Visio Started ***"
    Write-Verbose "*** Function Find Visio Started ***"

    $script:VisioProgram = "Visio"
    
    $script:x64Visio = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") |
       Where-Object { $_.GetValue( "DisplayName" ) -like "*$script:VisioProgram*" } ).Length -gt 0;

    LogTraceMessage "Visio x86 is $script:x86Visio"
    Write-Verbose "Visio x86 is $script:x86Visio"

    $script:x86Visio = ((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
        Where-Object { $_.GetValue( "DisplayName" ) -like "* $script:VisioProgram*" } ).Length -gt 0;

    LogTraceMessage "Visio x64 is $script:x64Visio"
    Write-Verbose "Visio x64 is $script:x64Visio"

    LogTraceMessage "*** Function Find Visio Finished ***"
    Write-Verbose "*** Function Find Visio Finished ***"
  }

Function RemoveOffice
  {
    # Function Started
    LogTraceMessage "*** Function RemoveOffice Started ***"
    Write-Verbose "*** Function RemoveOffice Started ***"

    LogTraceMessage "Remove-PreviousOfficeInstalls started"
    Write-Verbose "Remove-PreviousOfficeInstalls started"

    #Invoke-Expression -Command .\Remove-PreviousOfficeInstalls.ps1
    Start-Process -FilePath "Powershell.exe" -ArgumentList ".\Remove-PreviousOfficeInstalls.ps1" -Wait

    LogTraceMessage "Remove-PreviousOfficeInstalls ended"
    Write-Verbose "Remove-PreviousOfficeInstalls ended"

    LogTraceMessage "Look for Office in Uninstall registry started"
    Write-Verbose "Look for Office in Uninstall registry started"

    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{90140000-006D-0409-1000-0000000FF1CE}')
      {
      LogTraceMessage "Found Office in Uninstall registry started"
      Write-Verbose "Found Office in Uninstall registry started"
      if (((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{90140000-006D-0409-1000-0000000FF1CE}').DisplayName) -like "*Office*")
        {
        LogTraceMessage "Removing Office in Uninstall registry started"
        Write-Verbose "Revmoving Office in Uninstall registry started"
        $Script:proc = (Start-Process -FilePath "Setup.exe" -ArgumentList "/configure Office365UninstallALLConfiguration.xml" -PassThru)
        LogTraceMessage "Uninstall Office =  $($Script:proc.ID)"
        Write-Verbose "Uninstall Office =  $($Script:proc.ID)" 
    
        $Script:proc.WaitForExit()
        $Script:ExitCode = $Script:proc.ExitCode
        }
      }

    LogTraceMessage "Look for Office in Uninstall registry ended"
    Write-Verbose "Look for Office in Uninstall registry ended"

    LogTraceMessage "*** Function RemoveOffice Ended ***"
    Write-Verbose "*** Function RemoveOffice Ended ***"
   }

  Function RemovePreviousClickToRun
  {
    LogTraceMessage "*** Function RemovePreviousClickToRun Started ***"
    Write-Verbose "*** Function RemovePreviousClickToRun Started ***"

    if (Test-Path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration')
    {
      LogTraceMessage "Found ClickToRun in registry"
      Write-Verbose "Found ClickToRun in registry"

      If (((Get-ItemProperty -path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration').Platform) -eq "x64")
      {
        LogTraceMessage "Found previous  x64 ClickToRun in registry"
        Write-Verbose "Found previous  x64 ClickToRun in registry"

        LogTraceMessage "Removing previous  x64 ClickToRun"
        Write-Verbose "Removing previous  x64 ClickToRun"

        $Script:proc = (Start-Process -FilePath "setup.exe" -ArgumentList "/configure Office365UninstallALLConfiguration.xml" -PassThru)
        LogTraceMessage "Uninstall  x64 ClickToRun ID =  $($Script:proc.ID)"
        Write-Verbose "Uninstall x64 ClickToRun ID =  $($Script:proc.ID)" 
    
        $Script:proc.WaitForExit()
        $Script:ExitCode = $Script:proc.ExitCode

        LogTraceMessage "Removed previous x64 ClickToRun"
        Write-Verbose "Removed previous x64 ClickToRun"
      }
    }
    LogTraceMessage "*** Function RemovePreviousClickToRun Ended ***"
    Write-Verbose "*** Function RemovePreviousClickToRun Ended ***"
  }

  Function InstallO365ProPlus32
  {
    # Function Started
    LogTraceMessage "*** Function InstallO365ProPlus32 Started ***"
    Write-Verbose "*** Function InstallO365ProPlus32 Started ***"

    $Script:proc = (Start-Process -FilePath "setup.exe" -ArgumentList "/configure Office365Install32Configuration.xml" -PassThru)

    LogTraceMessage "InstallO365ProPlus32 ID =  $($Script:proc.ID)"
    Write-Verbose "InstallO365ProPlus32 ID =  $($Script:proc.ID)" 
    
    $Script:proc.WaitForExit()
    $Script:ExitCode = $Script:proc.ExitCode

    LogTraceMessage "*** Function InstallO365ProPlus32 Ended ***"
    Write-Verbose "*** Function InstallO365ProPlus32 Ended ***"
   }

Function InstallVisio32
  {
  # Function Started
  LogTraceMessage "*** Function InstallO365Visio32 Started ***"
  Write-Verbose "*** Function InstallO365Visio32 Started ***"

  If ($script:x86Visio -eq $True -or $script:x64Visio -eq $True)
    {
    LogTraceMessage "Visio was previously on the machine.  Installing"
    Write-Verbose "Visio was previously on the machine.  Installing"

    $Script:proc = (Start-Process -FilePath "setup.exe" -ArgumentList "/configure Visio365Install32Configuration.xml" -PassThru)

    
    LogTraceMessage "InstallO365Visio32 ID =  $($Script:proc.ID)"
    Write-Verbose "InstallO365Visio32 ID =  $($Script:proc.ID)" 
    
    $Script:proc.WaitForExit()
    $Script:ExitCode = $Script:proc.ExitCode
    }
  }

Function InstallProject32
  {
  # Function Started
  LogTraceMessage "*** Function InstallO365Project32 Started ***"
  Write-Verbose "*** Function InstallO365Project32 Started ***"

  If ($script:x86Project -eq $True -or $script:x64Project -eq $True)
    {
    LogTraceMessage "Project was previously on the machine.  Installing"
    Write-Verbose "Project was previously on the machine.  Installing"

    $Script:proc = (Start-Process -FilePath "setup.exe" -ArgumentList "/configure Project365Install32Configuration.xml" -PassThru)
    
    LogTraceMessage "InstallO365Project32 ID =  $($Script:proc.ID)"
    Write-Verbose "InstallO365Project32 ID =  $($Script:proc.ID)" 
    
    $Script:proc.WaitForExit()
    $Script:ExitCode = $Script:proc.ExitCode

    LogTraceMessage "*** Function InstallO365Project32 Ended ***"
    Write-Verbose "*** Function InstallO365Project32 Ended ***"
    }
  }

  Function ConfigMgrHINV
  {
    # Function Started
    LogTraceMessage "*** Function ConfigMgrHINV Started ***"
    Write-Verbose "*** Function ConfigMgrHINV Started ***"

    $SMSCli = [wmiclass] "\\.\root\ccm:SMS_Client"
    $SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000001}")

    LogTraceMessage "*** Function ConfigMgrHINV Ended ***"
    Write-Verbose "*** Function ConfigMgrHINV Ended ***"
  }
  
  # Script Started
  LogTraceMessage "*** Script Started ***"
  Write-Verbose "*** Script Started ***"
  
  #Main
  Main
}

Catch
{
  # Catch Started
  LogTraceMessage "*** Catch Started ***"
  Write-Verbose "*** Catch Started ***"
  
  # Log error messages
  $script:ErrorMessage = $Error[0].Exception.ToString()
  LogTraceMessage "Variable ErrorMessage set to $script:ErrorMessage"
  Write-Verbose "Variable ErrorMessage set to $script:ErrorMessage"
  
  $script:ErrorState = 3
  LogTraceMessage "Variable ErrorState set to $script:ErrorState"
  Write-Verbose "Variable ErrorState set to $script:ErrorState"
  
  # Catch Finished
  LogTraceMessage "*** Catch Finished ***"
  Write-Verbose "*** Catch Finished ***"
}

Finally
{
  # Finally Started
  LogTraceMessage "*** Finally Started ***"
  Write-Verbose "*** Finally Started ***" 
  
  # Log Error State/Message
  LogTraceMessage "Variable ErrorState = $script:ErrorState"
  Write-Verbose  "Variable ErrorState = $script:ErrorState"
  
  # Finally Finished
  LogTraceMessage "*** Finally Finished ***"
  Write-Verbose "*** Finally Finished ***"
  
  # Script Finished
  LogTraceMessage "*** Script Finished ***"
  Write-Verbose "*** Script finished Finished ***"
  
  # Write to log file
  $script:TraceMessage | Out-File $script:LoggingPath
}