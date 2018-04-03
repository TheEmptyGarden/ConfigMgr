select distinct rSys.ResourceID
	, rSys.name0 as 'MachineName'
	, rSys.Resource_Domain_OR_Workgr0 as 'Domain'
	, rSys.AD_Site_Name0 as 'AD_Site'
	, ou.OU as 'Organizational_Unit'
	, rSys.operating_system_name_and0 as 'OperatingSystem'
	, rSys.operatingsystem0 as 'OperatingSystemName'
	, rSys.operatingsystemservicepac0 as 'OperatingSystemServicePack'
	, rSys.Build01 as 'OperatingSystem_Version'
	, case
			when rSys.Build01 like '%10240%'
				then '1507'
			when rSys.Build01 like '%10586%'
				then '1511'
			when rSys.Build01 like '%14393%'
				then '1607'
			when rSys.build01 like '%15063%'
				then '1703'
			when rSys.build01 like '%16299%'
				then '1709'
			when rSys.build01 like '6.%' or rSys.build01 like '5.%'
				then NULL
			when rSys.Build01 is NULL and rSys.Operating_System_Name_and0 like 'Microsoft Windows NT Workstation 10.0%'
				then 'UNKNOWN'
			else rSys.build01
		end as 'Windows_10_Release_Number'
	, OS.OSArchitecture0 as 'OperatingSystem_Architecture'
	, CompSys.Manufacturer0 as 'System_Manufacturer'
	, CompSys.Model0 as 'System_Model_Number'
	, BIOS.SerialNumber0 as 'Serial_Number'
	, BIOS.BIOSVersion0 as 'Full_BIOS_Version'
	, BIOS.SMBIOSBIOSVersion0 as 'SMBIOS_Version'
	, BIOS.ReleaseDate0 as 'BIOS_Release_Date'
	, Mem.Capacity0 as 'Total_Memory(MB)'
	, Processor.name0 as 'Processor'
	, LogicalDisk.Size0 as 'Disk_Space(GB)'
	, LogicalDisk.FreeSpace0 as 'Free_Disk_Space(GB)'
	, case when rSys.User_Name0 like '%\%' then substring(rSys.User_Name0,charindex('\',rSys.User_Name0)+ 1,charindex('\',rSys.User_Name0))
		else rSys.User_Name0 end AS 'LastLoggedOnUser'
	, case when TopUser.TopConsoleUser0 like '%\%' then substring(TopUser.TopConsoleUser0,charindex('\',TopUser.TopConsoleUser0) + 1,CharIndex('\',TopUser.TopConsoleUser0) + (LEN(TopUser.TopConsoleUser0)))
			else TopUser.TopConsoleUser0 end as 'TopUser'
	, PrimaryUser.UniqueUserName as 'MainUser'
	, case when rSys.client0 = 1 then '1'
			else '0' end as 'SCCM_Client'
	, rSys.Client_Version0 as 'SCCM_Client_Version'
	, HINV.LastHardwareScan as 'SCCM_LastHWscan'
	, SINV.LastSoftwareScan as 'SCCM_LastSWscan'
	, Dateadd(hour,(datediff(hour,getutcdate(),getdate())),UpdateScan.lastscantime) as 'Last_WSUSscan'
	, SUPScan.StateName as 'WSUSscan_Result'
	, SUPScan.ErrorStatusID as 'WSUS_ErrorID'
	, SUPScan.ErrorCode as 'WSUS_Error_Code'
	, SUPScan.HexErrorCode as 'WSUS_Hex_Error_Code'
from CM_TP1.dbo.v_R_System rSys
left join CM_TP1.dbo.vWorkstationStatus HINV
	on rSys.ResourceID = HINV.ResourceID
left join CM_TP1.dbo.vSoftwareInventoryStatus SINV
	on rSys.ResourceID = SINV.ResourceID
left join CM_TP1.dbo.v_UpdateScanStatus UpdateScan
	on rSys.ResourceID = UpdateScan.ResourceID
left join CM_TP1.dbo.v_GS_COMPUTER_SYSTEM CompSys
	on rSys.resourceid = CompSys.ResourceID
left join CM_TP1.dbo.v_GS_OPERATING_SYSTEM OS
	on rSys.ResourceID = OS.ResourceID
left join CM_TP1.dbo.v_GS_PC_BIOS BIOS
	on rSys.ResourceID = BIOS.ResourceID
left join CM_TP1.dbo.v_GS_PHYSICAL_MEMORY Mem
	on rSys.ResourceID = Mem.ResourceID
left join CM_TP1.dbo.v_GS_PROCESSOR Processor
	on rSys.ResourceID = Processor.ResourceID
left join
	(
	Select ResourceID
		, Size0
		, FreeSpace0
	from CM_TP1.dbo.v_GS_LOGICAL_DISK 
	where DeviceID0 = 'C:'
	) LogicalDisk
	on rSys.ResourceID = LogicalDisk.ResourceID
left join CM_TP1.dbo.v_UserMachineRelationship PrimaryUser
	on rSys.ResourceID = PrimaryUser.MachineResourceID
left join
	(
	select uss.ResourceID
		, SN.StateName
		, uss.LastStatusMessageID&0x0000FFFF as 'ErrorStatusID'
		,	isnull(uss.LastErrorCode,0) as 'ErrorCode'
		,	CM_TP1.dbo.fnConvertBinaryToHexString(convert(VARBINARY(8), isnull(uss.LastErrorCode,0))) as 'HexErrorCode'
	from CM_TP1.dbo.v_UpdateScanStatus uss
	join CM_TP1.dbo.v_R_System rsys 
		on rsys.ResourceID = uss.ResourceID 
			and isnull(rsys.Obsolete0,0)<>1
	join CM_TP1.dbo.v_SoftwareUpdateSource sus 
		on uss.UpdateSource_ID = sus.UpdateSource_ID 
	join CM_TP1.dbo.v_RA_System_SMSAssignedSites sass 
		on uss.ResourceID = sass.ResourceID
	join CM_TP1.dbo.v_StateNames sn 
		on sn.TopicType = 501 
			and sn.StateID = (
				case when (isnull(uss.LastScanState, 0)=0 and Left(isnull(rsys.Client_Version0, '4.0'), 1)<'4') 
				then 7 else isnull(uss.LastScanState, 0) 
				end)
	where 1= 1
	) SUPScan
	on rSys.ResourceID = SUPScan.ResourceID  
left JOIN CM_TP1.dbo.v_GS_SYSTEM_CONSOLE_USAGE_MAXGROUP TopUser
	on rSys.ResourceID = TopUser.resourceID
left join
	(
	select ResourceID
		, max(system_ou_name0) as 'OU'
	from CM_TP1.dbo.v_RA_System_SystemOUName
	group by ResourceID
	) OU
	on rSys.ResourceID = ou.ResourceID
		
where 1 = 1
	and rSys.Decommissioned0 <> 1
	and PrimaryUser.RelationActive = 1

GO
