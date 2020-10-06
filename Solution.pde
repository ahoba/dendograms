void solve(ProblemContext context)
{
  while(context.currentClusters.size() > 1)
  {
    System.out.println("Current distances:");
    
    for (int i = 0; i < context.currentClusters.size(); i++)
    {
      for (int j = 0; j <= i; j++)
      {
        System.out.print(context.currentClusters.get(i).distances[j] + ", ");
      }
      
      System.out.println();
    }
    
    Cluster cluster0 = context.currentClusters.get(0);
    Cluster cluster1 = context.currentClusters.get(1);
    
    int min = context.currentClusters.get(1).distances[0];
    
    for (int i = 0; i < context.currentClusters.size(); i++)
    {
      Cluster cluster = context.currentClusters.get(i);
      
      for (int j = 0; j < i; j++)
      {
        if (cluster.distances[j] < min)
        {
          cluster0 = context.currentClusters.get(i);
          cluster1 = context.currentClusters.get(j);
          
          min = cluster.distances[j];
        }
      }
    }
    
    System.out.println(context.linkage == Linkage.Single ? "Min Distance: " : "Max Distance: " + min);
    System.out.println("New Cluster: " + cluster0.asString() + " + " + cluster1.asString() + ";");
    
    Cluster newCluster = createNewCluster(cluster0, cluster1, min, context.copheneticMatrix);
    
    // Recalculate distances and update currentClusters
    
    context.currentClusters.remove(cluster0);
    context.currentClusters.remove(cluster1);
    
    context.currentClusters.add(0, newCluster);
    
    for (int i = 1; i < context.currentClusters.size(); i++)
    {
      Cluster currentCluster = context.currentClusters.get(i);
      
      currentCluster.distances = new int[i + 1];
      
      for (int j = 0; j <= i; j++)
      {
        currentCluster.distances[j] = getDistance(currentCluster, context.currentClusters.get(j), context.originalDistances, context.linkage);
      }
    }
  }
}

Cluster createNewCluster(Cluster cluster0, Cluster cluster1, int distance, int[][] copheneticMatrix)
{
    int[] newClusterElements = new int[cluster0.elements.length + cluster1.elements.length];
    
    for (int i = 0; i < cluster0.elements.length; i++)
    {
      newClusterElements[i] = cluster0.elements[i];
      
      for (int j = 0; j < cluster1.elements.length; j++)
      {
        copheneticMatrix[cluster0.elements[i]][cluster1.elements[j]] = distance;
        copheneticMatrix[cluster1.elements[j]][cluster0.elements[i]] = distance;
      }
    }
    
    for (int i = 0; i < cluster1.elements.length; i++)
    {
      newClusterElements[i + cluster0.elements.length] = cluster1.elements[i];
    }
    
    return new Cluster(newClusterElements, new int[] { 0 }, new Cluster[] { cluster0, cluster1 }, distance);
}

int getDistance(Cluster cluster0, Cluster cluster1, int[][] originalDistances, Linkage linkage)
{
  int ret = originalDistances[cluster0.elements[0]][cluster1.elements[0]];
  
  for (int i = 0; i < cluster0.elements.length; i++)
  {
    for (int j = 0; j < cluster1.elements.length; j++)
    {
      int distance = originalDistances[cluster0.elements[i]][cluster1.elements[j]];
      
      ret = linkage == Linkage.Single ? min(ret, distance) : max(ret, distance);
    }
  }
  
  return ret;
}
