param (
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId
)

# Login to Azure
#Connect-AzAccount

# Set the subscription
Set-AzContext -SubscriptionId $SubscriptionId

# Get the subscription details
$subscription = Get-AzContext

# Get all AKS clusters in the subscription
$allAksClusters = Get-AzAksCluster

# Initialize an array to hold the results
$allClusters = @()
$allNodePools = @()

if ($allAksClusters) {
    $allAksClusters | ForEach-Object {
        $clusterName = $_.Name
        $allClusters += [PSCustomObject]@{
            SubscriptionId   = $subscription.Subscription.Id
            SubscriptionName = $subscription.Subscription.Name
            ResourceGroup    = $_.ResourceGroupName
            ResourceName     = $_.Name
            Location         = $_.Location
            Version          = $_.CurrentKubernetesVersion
            Sku              = $_.Sku.Tier
            ResourceId       = $_.Id
        }

        # Get the node pools for each AKS cluster
        $nodePools = $_.AgentPoolProfiles
        foreach ($nodePool in $nodePools) {
            $allNodePools += [PSCustomObject]@{
                ClusterName      = $clusterName
                NodePoolName     = $nodePool.Name
                OsType           = $nodePool.OsType
                OsSKU            = $nodePool.OsSKU
                Mode             = $nodePool.Mode
                AvailabilityZones= $nodePool.AvailabilityZones -join ','
                NoOfAvailabilityZone = $nodePool.AvailabilityZones.Count
                CurrentOrchestratorVersion = $nodePool.CurrentOrchestratorVersion
            }
        }
    }
} else {
    Write-Host "No AKS cluster found in subscription $SubscriptionId."
}

# Export the results to a CSV file
$allClusters | Export-Csv -Path "./aksClusters.csv" 
$allNodePools | Export-Csv -Path "./aksNodePools.csv"
