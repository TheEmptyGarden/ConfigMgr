# Connect to Azure
$Cred = Get-Credential -UserName "Matthew@EmptyGarden.info" -Message "Enter Password for Matthew@EMptyGarden.info"
$EmptyGardenAzureRM = Connect-AzureRmAccount -Credential $Cred
$EmptyGardenAzureSubscriptionID = (Get-AzureRmSubscription -SubscriptionName EmptyGardenMSDN).ID

# Variables
  $Location = "East US"
  $ResourceGroupName = "EmptyGarden-RG"
  $StorageAccountDiagName = "emptygardendiagstorage"
  $StorageAccountDiagSKU = "Standard_LRS"
  $StorageAccountVHDSKU = "Premium_LRS"
  $SubnetName = "EmptyGarden-Subnet"
  $SubnetAddressSpace = "10.10.10.0/24"
  $VirtualNetworkName = "EmptyGarden-VNet"
  $NetworkSecurityGroupConfigRDP = "EmptyGardenRDP"
  $NetworkSecurityGroupConfigHTTP = "EmptyGardenHTTP"
  $NetworkSecurityGroupConfigHTTPS = "EmptyGardenHTTPS"
  $RDPPort = "3389"
  $WinRMHTTPPort = "5985"
  $WinRMHTTPSPort = "5986"
  $EmptyGardenDNS = "10.10.10.10"
  $NetworkSecurityGroupName = "EmptyGardenNSG"
  $KeyVaultName = "EmptyGardenKeyVault"
  $DomainName = "EmptyGarden.info"
  $EmptyGardenRootCA = "EmptyGardenRootCA"


#VM Image Variables
  $VMImagePublisherServer = "MicrosoftWindowsServer"  
  $VMImagePublisherWorkstation = "MicrosoftWindowsDesktop"

  $VMImageOfferServer = "WindowsServer"
  $VMImageOfferServerSemiAnnual = "WindowsServerSemiAnnual"
  $VMImageOfferWorkstation = "Windows-10"

  $VMImageOfferSKUServer = "2016-Datacenter"
  $VMImageOfferSKUServerSemiAnnual = "Datacenter-Core-1803-with-Containers-smalldisk"
  $VMImageOfferSKUWorsktation = "rs5-pro"

#VM Image Size Variables
  $VMSizeServerSmall = "Standard_B1ms"
  $VMSizeServerLarge = "Standard_B2s"
  $VMSizeWorkstationSmall = "Standard_B1ms"

#VM Global variables
  $EmptyGardenAdminUser = Get-Credential -UserName "EmptyGardenAdmin" -Message "Enter password for EmptyGardenAdmin account"
  $VMTimeZone = "Central Standard Time"

#TEE-DC-AZ variables
  $TEEDCAZPublicAddressName = "TEE-DC-AZ-PublicIP"
  $TEEDCAZNICName = "TEE-DC-AZ-Nic"
  $TEEDCAZIPName = "TEE-DC-AZ-IP"
  $TEEDCAZIP = "10.10.10.10"
  $TEEDCAZName = "TEE-DC-AZ"
  $TEEDCAZDisk = "TEEDCAZOSDisk"
  $TEEDCAZDiskSize = "128"

#VM Auto Shutdown Variables
$ScheduledShutdownPropertiesTEEDCAZ = @{}
$ScheduledShutdownPropertiesTEEDCAZ.Add('status', 'Enabled')
$ScheduledShutdownPropertiesTEEDCAZ.Add('taskType', 'ComputeVmShutdownTask')
$ScheduledShutdownPropertiesTEEDCAZ.Add('dailyRecurrence', @{'time'= 1800})
$ScheduledShutdownPropertiesTEEDCAZ.Add('timeZoneId', "Central Standard Time")
$ScheduledShutdownPropertiesTEEDCAZ.Add('notificationSettings', @{status='Disabled'; timeInMinutes=15})

#TEE-SQL-AZ variables
  $TEESQLAZPublicAddressName = "TEE-SQL-AZ-PublicIP"
  $TEESQLAZNICName = "TEE-SQL-AZ-Nic"
  $TEESQLAZIPName = "TEE-SQL-AZ-IP"
  $TEESQLAZIP = "10.10.10.20"
  $TEESQLAZName = "TEE-SQL-AZ"
  $TEESQLAZDisk = "TEESQLAZOSDisk"
  $TEESQLAZDiskSize = "128"

#TEE-SQL-AZ VM Auto Shutdown Variables
  $ScheduledShutdownPropertiesTEESQLAZ = @{}
  $ScheduledShutdownPropertiesTEESQLAZ.Add('status', 'Enabled')
  $ScheduledShutdownPropertiesTEESQLAZ.Add('taskType', 'ComputeVmShutdownTask')
  $ScheduledShutdownPropertiesTEESQLAZ.Add('dailyRecurrence', @{'time'= 1800})
  $ScheduledShutdownPropertiesTEESQLAZ.Add('timeZoneId', "Central Standard Time")
  $ScheduledShutdownPropertiesTEESQLAZ.Add('notificationSettings', @{status='Disabled'; timeInMinutes=15})

  #TEE-CM-AZ variables
  $TEECMAZPublicAddressName = "TEE-CM-AZ-PublicIP"
  $TEECMAZNICName = "TEE-CM-AZ-Nic"
  $TEECMAZIPName = "TEE-CM-AZ-IP"
  $TEECMAZIP = "10.10.10.30"
  $TEECMAZName = "TEE-CM-AZ"
  $TEECMAZDisk = "TEECMAZOSDisk"
  $TEECMAZDiskSize = "128"

#TEE-CM-AZ VM Auto Shutdown Variables
  $ScheduledShutdownPropertiesTEECMAZ = @{}
  $ScheduledShutdownPropertiesTEECMAZ.Add('status', 'Enabled')
  $ScheduledShutdownPropertiesTEECMAZ.Add('taskType', 'ComputeVmShutdownTask')
  $ScheduledShutdownPropertiesTEECMAZ.Add('dailyRecurrence', @{'time'= 1800})
  $ScheduledShutdownPropertiesTEECMAZ.Add('timeZoneId', "Central Standard Time")
  $ScheduledShutdownPropertiesTEECMAZ.Add('notificationSettings', @{status='Disabled'; timeInMinutes=15})


<#

# Modules required
  #Install-Module AzureRM -force

# Get VM options - Run this code to find the names of the variables in the "VM Image Variables" section
Get-AzureRmVMImagePublisher -Location $location | Select-Object PublisherName | Where-Object PublisherName -Like 'Microsoft*' 
  # Returns MicrosoftWindowsServer and MicrosoftWindowsDesktop along with others

Get-AzureRmVMImageOffer -Location $Location -PublisherName $VMImagePublisherServer
  # Returns WindowsServer and WindowsServerSemiAnnual along with others

Get-AzureRmVMImageOffer -Location $Location -PublisherName $VMImagePublisherWorkstation
  # Returns Windows-10 along with others

Get-AzureRmVMImageSku -Location $Location -PublisherName $VMImagePublisherServer -Offer $VMImageOfferServer
  # Returns 2016-Datacenter along with others

Get-AzureRmVMImageSku -Location $Location -PublisherName $VMImagePublisherServer -Offer $VMImageOfferServerSemiAnnual
  # Returns Datacenter-Core-1803-with-Containers-smalldisk along with others

Get-AzureRmVMImageSku -Location $Location -PublisherName $VMImagePublisherWorkstation -Offer $VMImageOfferWorkstation
  # Returns rs5-pro  along with others

Get-AzureRmVMImage -Location $Location -PublisherName $VMImagePublisherServer -Offer $VMImageOfferServer -Skus $VMImageOfferSKUServer
  # Returns version options

Get-AzureRmVMImage -Location $Location -PublisherName $VMImagePublisherServer -Offer $VMImageOfferServerSemiAnnual -Skus $VMImageOfferSKUServerSemiAnnual
  # Returns version options

Get-AzureRmVMImage -Location $Location -PublisherName $VMImagePublisherWorkstation -Offer $VMImageOfferWorkstation -Skus $VMImageOfferSKUWorsktation
  # Returns version options

# Get VM Size options - Run this code to find the names of the variables in the "VM Image Size" variable section
Get-AzureRmVMSize -Location $Location | Sort-Object MemoryInMB

#>

# Create the lab

# Create Resource Group
$ResourceGroup = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

#Create DIAG storage account
$StorageAccountDiag = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroup.ResourceGroupName -Name $StorageAccountDiagName -Location $Location -SkuName $StorageAccountDiagSKU

# Create Subnet
$Subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressSpace

# Create a virtual network
$VirtualNetwork = New-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroup.ResourceGroupName -Location $Location -Name $VirtualNetworkName -AddressPrefix $SubnetAddressSpace -Subnet $Subnet

# Create inbound network security group rule
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name $NetworkSecurityGroupConfigRDP  -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix *  -DestinationPortRange $RDPPort -Access Allow
$nsgRuleHTTP = New-AzureRmNetworkSecurityRuleConfig -Name $NetworkSecurityGroupConfigHTTP  -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix *  -DestinationPortRange $WinRMHTTPPort -Access Allow
$nsgRuleHTTPS = New-AzureRmNetworkSecurityRuleConfig -Name $NetworkSecurityGroupConfigHTTPS  -Protocol Tcp -Direction Inbound -Priority 102 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix *  -DestinationPortRange $WinRMHTTPSPort -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -Name $NetworkSecurityGroupName -SecurityRules $nsgRuleRDP, $nsgRuleHTTP, $nsgRuleHTTPS

# Associate with subnet
Set-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VirtualNetwork -NetworkSecurityGroup $NSG -AddressPrefix $SubnetAddressSpace
$VirtualNetwork | Set-AzureRmVirtualNetwork

# Create a key vault
$KeyVault = New-AzureRmKeyVault -Name $KeyVaultName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $Location

# Create secret for EmtpyGardenAdmin
$Secret = ConvertTo-SecureString -String $EmptyGardenAdminUser.Password -AsPlainText -Force
$KeyVaultEmptyGardenAdminSecret = Set-AzureKeyVaultSecret -VaultName $KeyVault.VaultName -Name $EmptyGardenAdminUser.UserName -SecretValue $Secret

# Create TEE-DC-AZ

  # Create a public address
  $PublicAddress = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -Name $TEEDCAZPublicAddressName -DomainNameLabel ($TEEDCAZName.tolower())  -AllocationMethod Static -IdleTimeoutInMinutes 4

  #Get the public FQDN
  $TEEDCAZFQDN = $PublicAddress.DnsSettings.Fqdn

  # Create a virtual network card and associate with public IP address and NSG
  $IPConfig = New-AzureRmNetworkInterfaceIpConfig -Name $TEEDCAZIPName -PrivateIpAddressVersion IPv4 -PrivateIpAddress $TEEDCAZIP -SubnetId $VirtualNetwork.subnets.id -PublicIpAddressId $PublicAddress.Id
  $nic = New-AzureRmNetworkInterface -Name $TEEDCAZNICName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -IpConfiguration $IPConfig -DnsServer $EmptyGardenDNS

  # Create a virtual machine configuration
  $VirtualMachineConfig = New-AzureRmVMConfig -VMName $TEEDCAZName -VMSize $VMSizeServerSmall

  # Set the Admin Account
  $AdminUserName = $KeyVaultEmptyGardenAdminSecret.Name
  $AdminPassword = ConvertTo-SecureString $KeyVaultEmptyGardenAdminSecret.SecretValueText -AsPlainText -Force
  $Cred =  New-Object System.Management.Automation.PSCredential ($AdminUserName, $AdminPassword)

  # Set the OS type
  $VirtualMachineOS = Set-AzureRmVMOperatingSystem -VM $VirtualMachineConfig -Windows -ComputerName $TEEDCAZName -Credential $Cred  -WinRMHttp -ProvisionVMAgent -EnableAutoUpdate -TimeZone $VMTimeZone

  # Set the OS
  $VirtualMachineSourceImage = Set-AzureRmVMSourceImage -VM  $VirtualMachineConfig -PublisherName $VMImagePublisherServer -Offer $VMImageOfferServerSemiAnnual -Skus $VMImageOfferSKUServerSemiAnnual -Version latest

  #Set the VM NIC
  $VirtaulMachineNIC = Add-AzureRmVMNetworkInterface -VM $VirtualMachineConfig -Id $nic.Id

  #Set the VM Boot diagnostics
  $VirtualMachineBootDiag = Set-AzureRmVMBootDiagnostics -Enable -ResourceGroupName $ResourceGroup.ResourceGroupName -VM $VirtualMachineConfig -StorageAccountName $StorageAccountDiag.StorageAccountName

  #Set the disk size and type
  $VirtaulMachineDisk = Set-AzureRmVMOSDisk -Name ($TEEDCAZDisk.tolower() + '.vhd') -vm $VirtualMachineConfig -StorageAccountType $StorageAccountVHDSKU -DiskSizeInGB $TEEDCAZDiskSize -Caching ReadWrite -Windows -CreateOption fromimage

  # Create TEE-DC-AZ
  $TEEDCAZAzureVM = New-AzureRmVM -ResourceGroupName $ResourceGroup.ResourceGroupName -Location $location -VM $VirtualMachineConfig

  #Set the auto shutdown schedule
  $TEEDCAZVM = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $TEEDCAZName
  $ScheduledShutdownPropertiesTEEDCAZ.Add('targetResourceId', $TEEDCAZVM.Id)
  $ScheduledShutdownResourceId = "/subscriptions/$EmptyGardenAzureSubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/schedules/shutdown-computevm-$TEEDCAZName"
  New-AzureRmResource -Location eastus -ResourceId $ScheduledShutdownResourceId  -Properties $ScheduledShutdownPropertiesTEEDCAZ  -Force

# Create TEE-SQL-AZ

  # Create a public address
  $PublicAddress = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -Name $TEESQLAZPublicAddressName -DomainNameLabel ($TEESQLAZName.tolower())  -AllocationMethod Static -IdleTimeoutInMinutes 4
  #Get the public FQDN
  $TEESQLAZFQDN = $PublicAddress.DnsSettings.Fqdn

  # Create a virtual network card and associate with public IP address and NSG
  $IPConfig = New-AzureRmNetworkInterfaceIpConfig -Name $TEESQLAZIPName -PrivateIpAddressVersion IPv4 -PrivateIpAddress $TEESQLAZIP -SubnetId $VirtualNetwork.subnets.id -PublicIpAddressId $PublicAddress.Id
  $nic = New-AzureRmNetworkInterface -Name $TEESQLAZNICName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -IpConfiguration $IPConfig -DnsServer $EmptyGardenDNS

  # Create a virtual machine configuration
  $VirtualMachineConfig = New-AzureRmVMConfig -VMName $TEESQLAZName -VMSize $VMSizeServerLarge

  # Set the Admin Account
  $AdminUserName = $KeyVaultEmptyGardenAdminSecret.Name
  $AdminPassword = ConvertTo-SecureString $KeyVaultEmptyGardenAdminSecret.SecretValueText -AsPlainText -Force
  $Cred =  New-Object System.Management.Automation.PSCredential ($AdminUserName, $AdminPassword)

  #Set the OS Type
  $VirtualMachineOS = Set-AzureRmVMOperatingSystem -VM $VirtualMachineConfig -Windows -ComputerName $TEESQLAZName -Credential $Cred  -WinRMHttp -ProvisionVMAgent -EnableAutoUpdate -TimeZone $VMTimeZone #-WinRMHttps  -WinRMCertificateUrl $WinRMCertUrl
  
  #Set the OS
  $VirtualMachineSourceImage = Set-AzureRmVMSourceImage -VM  $VirtualMachineConfig -PublisherName $VMImagePublisherServer -Offer $VMImageOfferServerSemiAnnual -Skus $VMImageOfferSKUServerSemiAnnual -Version latest

  #Set the VM NIC
  $VirtaulMachineNIC = Add-AzureRmVMNetworkInterface -VM $VirtualMachineConfig -Id $nic.Id

  #Set the VM Boot diagnostics
  $VirtualMachineBootDiag = Set-AzureRmVMBootDiagnostics -Enable -ResourceGroupName $ResourceGroup.ResourceGroupName -VM $VirtualMachineConfig -StorageAccountName $StorageAccountDiag.StorageAccountName

  #Set the disk size and type
  $VirtaulMachineDisk = Set-AzureRmVMOSDisk -Name ($TEESQLAZDisk.tolower() + '.vhd') -vm $VirtualMachineConfig -StorageAccountType $StorageAccountVHDSKU -DiskSizeInGB $TEESQLAZDiskSize -Caching ReadWrite -Windows -CreateOption fromimage

  # Create TEE-SQL-AZ virtual machine
  New-AzureRmVM -ResourceGroupName $ResourceGroup.ResourceGroupName -Location $location -VM $VirtualMachineConfig

  #Set the auto shutdown schedule
  $TEESQLAZVM = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $TEESQLAZName
  $ScheduledShutdownPropertiesTEESQLAZ.Add('targetResourceId', $TEESQLAZVM.Id)
  $ScheduledShutdownResourceId = "/subscriptions/$EmptyGardenAzureSubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/schedules//shutdown-computevm-$TEESQLAZName"
  New-AzureRmResource -Location eastus -ResourceId $ScheduledShutdownResourceId  -Properties $ScheduledShutdownPropertiesTEESQLAZ  -Force

# Create TEE-CM-AZ

  # Create a public address
  $PublicAddress = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -Name $TEECMAZPublicAddressName -DomainNameLabel ($TEECMAZName.tolower())  -AllocationMethod Static -IdleTimeoutInMinutes 4
  
  #Get the public FQDN
  $TEECMAZFQDN = $PublicAddress.DnsSettings.Fqdn

  # Create a virtual network card and associate with public IP address and NSG
  $IPConfig = New-AzureRmNetworkInterfaceIpConfig -Name $TEECMAZIPName -PrivateIpAddressVersion IPv4 -PrivateIpAddress $TEECMAZIP -SubnetId $VirtualNetwork.subnets.id -PublicIpAddressId $PublicAddress.Id
  $nic = New-AzureRmNetworkInterface -Name $TEECMAZNICName -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -IpConfiguration $IPConfig -DnsServer $EmptyGardenDNS

  # Create a virtual machine configuration
  $VirtualMachineConfig = New-AzureRmVMConfig -VMName $TEECMAZName -VMSize $VMSizeServerLarge

  # Set the Admin Account
  $AdminUserName = $KeyVaultEmptyGardenAdminSecret.Name
  $AdminPassword = ConvertTo-SecureString $KeyVaultEmptyGardenAdminSecret.SecretValueText -AsPlainText -Force
  $Cred =  New-Object System.Management.Automation.PSCredential ($AdminUserName, $AdminPassword)

  #Set the OS Type
  $VirtualMachineOS = Set-AzureRmVMOperatingSystem -VM $VirtualMachineConfig -Windows -ComputerName $TEECMAZName -Credential $Cred  -WinRMHttp -ProvisionVMAgent -EnableAutoUpdate -TimeZone $VMTimeZone #-WinRMHttps  -WinRMCertificateUrl $WinRMCertUrl

  #Set the OS
  $VirtualMachineSourceImage = Set-AzureRmVMSourceImage -VM  $VirtualMachineConfig -PublisherName $VMImagePublisherServer -Offer $VMImageOfferServer -Skus $VMImageOfferSKUServer -Version latest

  #Set the VM NIC
  $VirtaulMachineNIC = Add-AzureRmVMNetworkInterface -VM $VirtualMachineConfig -Id $nic.Id

  #Set the VM Boot diagnostics  
  $VirtualMachineBootDiag = Set-AzureRmVMBootDiagnostics -Enable -ResourceGroupName $ResourceGroup.ResourceGroupName -VM $VirtualMachineConfig -StorageAccountName $StorageAccountDiag.StorageAccountName

  #Set the disk size and type
  $VirtaulMachineDisk = Set-AzureRmVMOSDisk -Name ($TEECMAZDisk.tolower() + '.vhd') -vm $VirtualMachineConfig -StorageAccountType $StorageAccountVHDSKU -DiskSizeInGB $TEECMAZDiskSize -Caching ReadWrite -Windows -CreateOption fromimage

  # Create TEE-CM-AZ virtual machine
  New-AzureRmVM -ResourceGroupName $ResourceGroup.ResourceGroupName -Location $location -VM $VirtualMachineConfig
  
  #Set the auto shutdown schedule
  $TEECMAZVM = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $TEECMAZName
  $ScheduledShutdownPropertiesTEECMAZ.Add('targetResourceId', $TEECMAZVM.Id)
  $ScheduledShutdownResourceId = "/subscriptions/$EmptyGardenAzureSubscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.DevTestLab/schedules//shutdown-computevm-$TEECMAZName"
  New-AzureRmResource -Location eastus -ResourceId $ScheduledShutdownResourceId  -Properties $ScheduledShutdownPropertiesTEECMAZ  -Force

# Create EmptyGarden.info Domain
$KeyVaultEmptyGardenAdminSecret = Get-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $EmptyGardenAdminUser.UserName
$AdminUserName = $TEEDCAZName + '\' + $KeyVaultEmptyGardenAdminSecret.Name
$AdminPassword = ConvertTo-SecureString $KeyVaultEmptyGardenAdminSecret.SecretValueText -AsPlainText -Force
$Cred =  New-Object System.Management.Automation.PSCredential ($AdminUserName, $AdminPassword)

$TEEDCAZFQDN = (Get-AzureRmPublicIpAddress -Name $TEEDCAZPublicAddressName -ResourceGroupName $ResourceGroupName).DnsSettings.Fqdn
$TEEDCAZSession = New-PSSession -ComputerName $TEEDCAZFQDN -cred $Cred

Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Install-WindowsFeature AD-Domain-Services -IncludeManagementTools}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Install-ADDSForest -DomainName $Using:DomainName -SafeModeAdministratorPassword $Using:AdminPassword -InstallDns -Force}

# Create PKI
$KeyVaultEmptyGardenAdminSecret = Get-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $EmptyGardenAdminUser.UserName
$AdminUserName = $DomainName + '\' + $KeyVaultEmptyGardenAdminSecret.Name
$AdminPassword = ConvertTo-SecureString $KeyVaultEmptyGardenAdminSecret.SecretValueText -AsPlainText -Force
$Cred =  New-Object System.Management.Automation.PSCredential ($AdminUserName, $AdminPassword)

$TEEDCAZSession = New-PSSession -ComputerName $TEEDCAZFQDN -cred $Cred

Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Add-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Install-WindowsFeature Web-WebServer -IncludeManagementTools}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Add-WindowsFeature ADCS-web-enrollment}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {New-Item -ItemType Directory -Path C:\CertEnroll}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {New-smbshare -name CertEnroll C:\CertEnroll -FullAccess SYSTEM,"$Using:DomainName\Domain Admins" -ChangeAccess "$Using:DomainName\Cert Publishers"}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Install-ADcsCertificationAuthority -CACommonName $Using:EmptyGardenRootCA -CAType EnterpriseRootCA -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -HashAlgorithmName SHA256 -KeyLength 2048 -ValidityPeriod Years -ValidityPeriodUnits 20 -force}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl \n10:ldap:///CN=%7%8,CN=%2,CN=CDP,CN=Public Key Services,CN=Services,%6%10\n2:http://crt.rebeladmin.com/CertEnroll/%3%8%9.crl"}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:ldap:///CN=%7,CN=AIA,CN=Public Key Services,CN=Services,%6%11\n2:http://crt.rebeladmin.com/CertEnroll/%1_%3%4.crt"}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {certutil -setreg ca\ValidityPeriod "Years"}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {certutil -setreg ca\ValidityPeriodUnits 20}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Certutil -setreg CA\CRLPeriodUnits 13}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Certutil -setreg CA\CRLPeriod "Weeks"}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Certutil -setreg CA\CRLDeltaPeriodUnits 0}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Certutil -setreg CA\CRLOverlapPeriodUnits 6}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Certutil -setreg CA\CRLOverlapPeriod "Hours"}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Restart-Service certsvc}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {certutil -crl}
Invoke-Command -Session $TEEDCAZSession -ScriptBlock {Install-ADCSwebenrollment -force}

#Create and deploy cert????? Not sure if this is possible with powershell.  which is stupid.

#Create domain objects (OU's, users, MSA's)

#Install SQL

#Install SCCM

#Create SQL indexing jobs

#Create SCCM / SQL Backup jobs

#Configure SCCM???  Boundaries, 
