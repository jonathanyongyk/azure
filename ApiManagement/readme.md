# Overview
This script list out all the API Management in the given Azure subscription.
The script was written to help me discover if a APIM has Availability Zone enabled as part of my Azure resiliency project. But it can be enhanced/adapt to discover other properties of the APIM or other Azure resources.

# Prerequisites
- Azure Powershell
- Azure CLI



## Install Azure Powershell
You can install Azure Powershell using *Install-PSResource -Name Az -Scope <AllUsers/CurrentUser>*


# Authentication
You need to run *Connect-AzAccount* to authenticate to Azure first before running this script. Alternatively, you can also uncomment the *Connect-AzAccount* command in the script to authenticate to Azure.

# Arguments
This script require two arguments.
The first one is subscription id which is mandatory. You may pass to the script via *-SubscriptionId* argument.
The second optional argument is the path to the output file. You may pass to the script via *-Path* argument.

# Output
The script will output to console if no **-Path** argument is provided. If you provide the **-Path** argument, the script will output to the file specified in the **-Path** argument in CSV format.


# Other options
You can also use the Azure CLI to list out all the API Management in the given Azure subscription. The command is in **getall_apim.sh**.

The third option is to use KQL in Azure Resource Graph Explorer. The KQL is in **getall_apim.kql**.


