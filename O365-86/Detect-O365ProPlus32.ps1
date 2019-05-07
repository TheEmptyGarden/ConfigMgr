# Name:         Detect-O365ProPlus32
# Description:  Detects O365ProPlus32
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

    #Detect O365ProPlus32
    DetectO365ProPlus32
    
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
    $Script:LoggingPath = 'c:\Windows\Temp\Detect-O365ProPlus32.log'
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

  Function DetectO365ProPlus32
  {
    # Function Started
    LogTraceMessage "*** Function DetectO365ProPlus32 Started ***"
    Write-Verbose "*** Function DetectO365ProPlus32 Started ***"
    
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
        LogTraceMessage "ClickToRunClientVersionToReport = $ClickToRunClientVersionToReport"
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
        $ClickToRunWinWord = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\WinWord.exe"
        LogTraceMessage "ClickToRunWinWord = $ClickToRunWinWord"
        Write-Verbose "ClickToRunWinWord = $ClickToRunWinWord" 
        $ClickToRunMSAccess = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\MSACCESS.EXE"
        LogTraceMessage "ClickToRunMSAccess = $ClickToRunMSAccess"
        Write-Verbose "ClickToRunMSAccess = $ClickToRunMSAccess" 
        $ClickToRunOutlook = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\OUTLOOK.EXE"
        LogTraceMessage "ClickToRunOutlook = $ClickToRunOutlook"
        Write-Verbose "ClickToRunOutlook = $ClickToRunOutlook" 
        $ClickToRunMSPub = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\MSPUB.EXE"
        LogTraceMessage "ClickToRunMSPub = $ClickToRunMSPub"
        Write-Verbose "ClickToRunMSPub = $ClickToRunMSPub" 
        $ClickToRunExcel = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\EXCEL.EXE"
        LogTraceMessage "ClickToRunExcel = $ClickToRunExcel"
        Write-Verbose "ClickToRunExcel = $ClickToRunExcel" 
        $ClickToRunLync = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\lync.exe"
        LogTraceMessage "ClickToRunLync = $ClickToRunLync"
        Write-Verbose "ClickToRunLync = $ClickToRunLync" 
        $ClickToRunOneNote = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\ONENOTE.EXE"
        LogTraceMessage "ClickToRunOneNote = $ClickToRunOneNote"
        Write-Verbose "ClickToRunOneNote = $ClickToRunOneNote" 
        $ClickToRunPowerPoint = Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\root\Office16\POWERPNT.EXE" 
        LogTraceMessage "ClickToRunPowerPoint  = $ClickToRunPowerPoint "
        Write-Verbose "ClickToRunPowerPoint  = $ClickToRunPowerPoint "  
        }
    Elseif ($OSArchitecture -eq '32-bit')
        {
        $ClickToRunWinWord = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\WinWord.exe"
        LogTraceMessage "ClickToRunWinWord = $ClickToRunWinWord"
        Write-Verbose "ClickToRunWinWord = $ClickToRunWinWord" 
        $ClickToRunMSAccess = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\MSACCESS.EXE"
        LogTraceMessage "ClickToRunMSAccess = $ClickToRunMSAccess"
        Write-Verbose "ClickToRunMSAccess = $ClickToRunMSAccess" 
        $ClickToRunOutlook = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\OUTLOOK.EXE"
        LogTraceMessage "ClickToRunOutlook = $ClickToRunOutlook"
        Write-Verbose "ClickToRunOutlook = $ClickToRunOutlook" 
        $ClickToRunMSPub = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\MSPUB.EXE"
        LogTraceMessage "ClickToRunMSPub = $ClickToRunMSPub"
        Write-Verbose "ClickToRunMSPub = $ClickToRunMSPub" 
        $ClickToRunExcel = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\EXCEL.EXE"
        LogTraceMessage "ClickToRunExcel = $ClickToRunExcel"
        Write-Verbose "ClickToRunExcel = $ClickToRunExcel" 
        $ClickToRunLync = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\lync.exe"
        LogTraceMessage "ClickToRunLync = $ClickToRunLync"
        Write-Verbose "ClickToRunLync = $ClickToRunLync" 
        $ClickToRunOneNote = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\ONENOTE.EXE"
        LogTraceMessage "ClickToRunOneNote = $ClickToRunOneNote"
        Write-Verbose "ClickToRunOneNote = $ClickToRunOneNote" 
        $ClickToRunPowerPoint = Test-Path "$env:ProgramFiles\Microsoft Office\root\Office16\POWERPNT.EXE" 
        LogTraceMessage "ClickToRunPowerPoint  = $ClickToRunPowerPoint "
        Write-Verbose "ClickToRunPowerPoint  = $ClickToRunPowerPoint "  
        }
    
    $Script:AppDetect = if ($ClickToRun = $True -and ($ClickToRunVersionToRerport -ge '16.0.10325.20082' -or $ClickToRunClientVersionToReport -ge '16.0.10325.20082') -and $ClickToRunPlatform -eq "x86" -and $ClickToRunProductReleaseIDs -like "*O365ProPlusRetail*" -and $ClickToRunMSAccess -eq $True -and $ClickToRunOutlook -eq $True -and $ClickToRunMSPub -eq $True -and $ClickToRunExcel -eq $True -and $ClickToRunLync -eq $True -and $ClickToRunOneNote -eq $True -and $ClickToRunPowerPoint -eq $True)

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

    LogTraceMessage "DetectO365ProPlus32 is $Script:AppDetect"
    Write-Verbose "DetectO365ProPlus32 is $Script:AppDetect"

    LogTraceMessage "*** FunctionDetectO365ProPlus32 Finished ***"
    Write-Verbose "*** Function DetectO365ProPlus32 Finished ***"
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