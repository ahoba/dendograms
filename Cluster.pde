class Cluster
{
  int[] elements;
  
  int[] distances;
  
  Cluster clusters[];
  
  int distance;
  
  // Drawing
  float xm;
  float ym;
  
  public Cluster(int[] elements, int[] distances)
  {
    this.elements = elements;
    this.distances = distances;
  }
  
  public Cluster(int[] elements, int[] distances, Cluster[] clusters, int distance)
  {
    this.elements = elements;
    this.distances = distances;
    
    this.clusters = clusters;
    
    this.distance = distance;
    
    this.xm = (clusters[0].xm + clusters[1].xm) / 2;
    this.ym = max(clusters[0].ym, clusters[1].ym) + distance;
  }
  
  String asString()
  {
    String ret = "{ ";
    
    for (int i = 0; i < elements.length; i++)
    {
      ret += elements[i];
      
      if (i < elements.length - 1)
      {
        ret += ", ";
      }
    }
    
    ret += " }";
    
    return ret;
  }
}
