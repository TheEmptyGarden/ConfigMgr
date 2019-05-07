# Name:         Detect-O365Visio64
# Description:  Detects O365Visio64
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

    #Detect O365Visio64
    DetectO365Visio64
    
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
    $Script:LoggingPath = 'c:\Windows\Temp\Detect-O365Visio64.log'
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

  Function DetectO365Visio64
    {
    # Function Started
    LogTraceMessage "*** Function DetectO365Visio64 Started ***"
    Write-Verbose "*** Function DetectO365Visio64 Started ***"
    
    $OSArchitecture = (get-wmiobject win32_operatingsystem).OSArchitecture
    LogTraceMessage "OSArchitecture = $OSArchitecture"
    Write-Verbose "OSArchitecture = $OSArchitecture"  
    
    $ClickToRun = Test-Path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration'
    LogTraceMessage "Click to Run = $ClickToRun"
    Write-Verbose "Click to Run = $ClickToRun"

    If ($ClickToRun -eq $True)
      {
        $ClickToRunVersionToRerport = (Get-ItemProperty -path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration').VersionToReport
        LogTraceMessage "ClickToRunVersionToRerport = $ClickToRunVersionToRerport"
        Write-Verbose "ClickToRunVersionToRerport = $ClickToRunVersionToRerport"
        $ClickToRunClientVersionToReport = (Get-ItemProperty -path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration').ClientVersionToReport
        LogTraceMessage "ClickToRunClientVersionToReport = $ClickToRunClientVersionToRepor
        t"
        Write-Verbose "ClickToRunClientVersionToReport = $ClickToRunClientVersionToReport"
        $ClickToRunPlatform = (Get-ItemProperty -path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration').Platform
        LogTraceMessage "ClickToRunPlatform = $ClickToRunPlatform"
        Write-Verbose "ClickToRunPlatform = $ClickToRunPlatform"
        $ClickToRunProductReleaseIDs = (Get-ItemProperty -path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration').ProductReleaseIds
        LogTraceMessage "ClickToRunProductReleaseIDs = $ClickToRunProductReleaseIDs"
        Write-Verbose "ClickToRunProductReleaseIDs = $ClickToRunProductReleaseIDs"    
      }
      
 
    If ($OSArchitecture -eq '64-bit')
        {
        $ClickToRunVisio = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\Visio.exe"
        LogTraceMessage "ClickToRunVisio = $ClickToRunVisio"
        Write-Verbose "ClickToRunVisio = $ClickToRunVisio" 
        }

    
    $Script:AppDetect = if ($ClickToRun = $True -and ($ClickToRunVersionToRerport -ge '16.0.10325.20082' -or $ClickToRunClientVersionToReport -ge '16.0.10325.20082') -and $ClickToRunPlatform -eq "x64" -and $ClickToRunProductReleaseIDs -like "*Visio*" -and $ClickToRunVisio -eq $True)

    {
      $True
    }

    if($Script:AppDetect) 
      {
        $true
      }
    else
      {
        $null
      }

    LogTraceMessage "DetectO365Visio64 is $Script:AppDetect"
    Write-Verbose "DetectO365Visio64 is $Script:AppDetect"

    LogTraceMessage "*** FunctionDetectO365Visio64 Finished ***"
    Write-Verbose "*** Function DetectO365Visio64 Finished ***"
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