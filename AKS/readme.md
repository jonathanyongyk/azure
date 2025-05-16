# Overview
This script list out all the AKS clusters and node pools in the given Azure subscription.
The script was written to help me discover if a AKS node pool has Availability Zone enabled as part of my Azure resiliency project. But it can be enhanced/adapt to discover other properties of the AKS or other Azure resources.

# Prerequisites
- Azure Powershell
- Azure CLI

## Install Azure Powershell
You can install Azure Powershell using *Install-PSResource -Name Az -Scope <AllUsers/CurrentUser>*


# Authentication
You need to run *Connect-AzAccount* to authenticate to Azure first before running this script. Alternatively, you can also uncomment the *Connect-AzAccount* command in the script to authenticate to Azure.

# Arguments
This script require one argument which is the subscription id. You may pass to the script via *-subscriptionId* argument.

# Output
The script will generate two CSV files in the current directory. The first file is the list of AKS clusters (**aksClusters.csv**) and the second file is the list of node pools in the cluster (**aksNodePools.csv**).
You can then open the files in Excel for further analysis .



# Other options
You can also use the Azure CLI to list out all the AKS clusters in the given Azure subscription. The command is in **getall_aksClusters.sh**.

The third option is to use KQL in Azure Resource Graph Explorer. The KQL is in **getall_aks.kql** and **getall_aksClusterNodePools**.


