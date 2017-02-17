<#
.SYNOPSIS
  Sets the active Azure PowerShell context
.DESCRIPTION
  Sets the active powershell context for running scripts in the environment

.NOTES
  Version:        1.0
  Author:         Aaron Saikovski
  Creation Date:  30th November 2016
  Purpose/Change: Initial script development
#>

#Requires -RunAsAdministrator
Import-Module Azure -ErrorAction SilentlyContinue
Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

#region SWITCH_SUBSCRIPTION
#switch subscription 
function SwitchSubscription {
	[CmdletBinding()]
	param(
	  [Parameter(Mandatory=$True)]
	  [ValidateSet("AzurePass")] 
	  [string] $sub
	)
	
	#active subscription
	$activesub = $null
	
	#select the active subscription
	switch($sub)
	{
		"AzurePass"
		{
			#Azure Pass Subscription	
			$activesub = Get-AzureRmSubscription -SubscriptionId '<SUBID>' -TenantId '<TENANTID>' 
		}
		
	}
	
	#Set the active subscription
	$activesub | Set-AzureRmContext | Out-Null
	Get-AzureRmContext
}
#endregion SWITCH_SUBSCRIPTION

#region LOGIN

#Login
function Login{
	[CmdletBinding()]
	param(
	  [Parameter(Mandatory=$True)]
	  [ValidateSet("AzurePass")] 
	  [string] $profile
	)


	#active profile
	$activeprofile = $null	

	#select the active profile
	switch($profile)
	{
		"AzurePass"
		{
			#DEV Subscription	
			$activeprofile="\Documents\AzureDemo_Profile.profile"
		}
		
	}

	#set the profile path
	$profilePath = "C:\Users\" + [Environment]::UserName + $activeprofile

	#Login
	if (Test-Path $profilePath)
	{
		#Write-Output "Loading saved profile..."
		Select-AzureRmProfile -Path $profilePath | Out-Null
	}
	else {
		#Write-Output "Logging in..."
		Login-AzureRmAccount
		Save-AzureRmProfile -Path $profilePath | Out-Null
	}
}
#endregion LOGIN

#region MAIN
function Main()
{
	#Main	
	Clear-Host
	
	#Prompt user for a choice 
	$caption = 'Azure Subscriptions'
	$message = "Please choose the active subscription"
	$choices = [System.Management.Automation.Host.ChoiceDescription[]]("AzurePass")
	$answer = $host.ui.PromptForChoice($caption,$message,$choices,0)

	#Switch Powershell Azure context based on choice
	switch ($answer)
	{
		0 {
			#"Azure Pass"
			Login -profile "AzurePass"
			SwitchSubscription -sub "AzurePass"		
		}
		
	}

}
#endregion MAIN

#Call main
Main