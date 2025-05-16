# Get all AKS clusters in the current subscription and save to CSV
aks_clusters=$(az aks list --query "[].{resourceUid:resourceUid, ResourceGroup:resourceGroup, ResourceName:name, Location:location, Version:kubernetesVersion, Sku:sku.tier, ResourceId:id}")

echo '"SubscriptionId","ResourceUid","ResourceGroup","ResourceName","Location","Version","Sku","ResourceId"' > aksClusters.csv
echo "$aks_clusters" | jq -r '.[] | [(.ResourceId | split("/"))[2], .resourceUid, .ResourceGroup, .ResourceName, .Location, .Version, .Sku, .ResourceId] | @csv' >> aksClusters.csv

# Get all Node pools in all AKS clusters in the current subscription and save to CSV
echo '"ClusterName","NodePoolName","OsType","OsSKU","Mode","AvailabilityZones","NoOfAvailabilityZone","CurrentOrchestratorVersion"' > aksNodePools.csv

for rg in $(az aks list --query "[].resourceGroup" -o tsv); do
  for cluster in $(az aks list --resource-group "$rg" --query "[].name" -o tsv); do
    node_pools=$(az aks nodepool list --resource-group "$rg" --cluster-name "$cluster" --query "[].{ ClusterName:'$cluster', NodePoolName:name, OsType:osType, OsSKU:osSku, Mode:mode, AvailabilityZones:join(',',(availabilityZones || ['NA'])), NoOfAvailabilityZone:length((availabilityZones || ['NA'])), CurrentOrchestratorVersion:currentOrchestratorVersion}")
    echo "$node_pools" | jq -r '.[] | [.ClusterName, .NodePoolName, .OsType, .OsSKU, .Mode, .AvailabilityZones, .NoOfAvailabilityZone, .CurrentOrchestratorVersion] | @csv' >> aksNodePools.csv
  done
done
