# Name:         Install-O365Project64
# Description:  Installs O365Project64
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

    #RemovePreviousClickToRun
    RemovePreviousClickToRunx86

    #Install O365Project64
    InstallO365Project64

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
    $Script:LoggingPath = 'c:\Windows\Temp\Install-O365Project64.log'
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

Function RemovePreviousClickToRunx86
  {
    LogTraceMessage "*** Function RemovePreviousClickToRunx86 Started ***"
    Write-Verbose "*** Function RemovePreviousClickToRunx86 Started ***"

    if (Test-Path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration')
    {
      LogTraceMessage "Found ClickToRun in registry"
      Write-Verbose "Found ClickToRun in registry"

    If (((Get-ItemProperty -path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration').Platform) -eq "x86")
      {
        LogTraceMessage "Found previous x86 ClickToRun in registry"
        Write-Verbose "Found previous x86 ClickToRun in registry"

        LogTraceMessage "Removing previous x86 ClickToRun"
        Write-Verbose "Removing previous x86 ClickToRun"

        $Script:proc = (Start-Process -FilePath "setup.exe" -ArgumentList "/configure Project365UninstallALL64Configuration.xml" -PassThru)
        LogTraceMessage "Uninstall x86 ClickToRun ID =  $($Script:proc.ID)"
        Write-Verbose "Uninstall x86 ClickToRun ID =  $($Script:proc.ID)" 
    
        $Script:proc.WaitForExit()
        $Script:ExitCode = $Script:proc.ExitCode

        LogTraceMessage "Removed previous x86 ClickToRun"
        Write-Verbose "Removed previous x86 ClickToRun"
      }
    }
    LogTraceMessage "*** Function RemovePreviousClickToRun Ended ***"
    Write-Verbose "*** Function RemovePreviousClickToRun Ended ***"
  }

  Function InstallO365Project64
  {
    # Function Started
    LogTraceMessage "*** Function InstallO365Project64 Started ***"
    Write-Verbose "*** Function InstallO365Project64 Started ***"

    $Script:proc = (Start-Process -FilePath "setup.exe" -ArgumentList "/configure Project365Install64Configuration.xml" -PassThru)
    
    LogTraceMessage "InstallO365Project64 ID =  $($Script:proc.ID)"
    Write-Verbose "InstallO365Project64 ID =  $($Script:proc.ID)" 
    
    $Script:proc.WaitForExit()
    $Script:ExitCode = $Script:proc.ExitCode

    LogTraceMessage "*** Function InstallO365Project64 Ended ***"
    Write-Verbose "*** Function InstallO365Project64 Ended ***"
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