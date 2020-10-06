import java.util.*;
import java.util.ArrayList;

int X_PADDING = 100;
int Y_PADDING = 50;

enum Linkage
{
  Single,
  Complete
}

Linkage linkage = Linkage.Single;

int[][] originalDistances = 
{
  { 0, 2, 6, 10, 9 },
  { 2, 0, 5, 9, 8 },
  { 6, 5, 0, 4, 5 },
  { 10, 9, 4, 0, 3 },
  { 9, 8, 5, 3, 0 }
};

int[][] copheneticMatrix;

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

ArrayList<Cluster> currentClusters = new ArrayList<Cluster>();

void LoadInput()
{
  String[] input = loadStrings("input.txt");
  
  if (input != null)
  {
    if (input[0].equals("Single"))
    {
      linkage = Linkage.Single;
      
      System.out.println("Linkage Mode: Single");
    }
    else if (input[0].equals("Complete"))
    {
      linkage = Linkage.Complete;
      
      System.out.println("Linkage Mode: Complete");
    }
    else
    {
      System.out.println("Unable to determine linkage mode, proceeding with default (Simple).");
    }
    
    int[][] matrix = new int[input.length - 1][input.length - 1];
    
    for (int i = 1; i < input.length; i++)
    {
      String[] numbers = input[i].split(" ");
      
      for (int j = 0; j < numbers.length; j++)
      {
        matrix[i - 1][j] = Integer.parseInt(numbers[j]);
      }
    }
    
    originalDistances = matrix;
  }
}

void setup()
{
  size(1000, 500);
  
  textAlign(CENTER);
  
  fill(0, 0, 255);
  
  LoadInput();
  
  copheneticMatrix = new int[originalDistances.length][originalDistances.length];
  
  for (int i = 0; i < originalDistances.length; i++)
  {
    int[] distances = new int[i + 1];
    
    for (int j = 0; j <= i; j++)
    {
      distances[j] = originalDistances[i][j];
    }
    
    Cluster cluster = new Cluster(new int[] { i }, distances); 
    
    cluster.xm = i;
    cluster.ym = 0;
    cluster.distance = 0;
    
    currentClusters.add(cluster);
  }
  
  while(currentClusters.size() > 1)
  {
    System.out.println("Current distances:");
    
    for (int i = 0; i < currentClusters.size(); i++)
    {
      for (int j = 0; j <= i; j++)
      {
        System.out.print(currentClusters.get(i).distances[j] + ", ");
      }
      
      System.out.println();
    }
    
    Cluster cluster0 = currentClusters.get(0);
    Cluster cluster1 = currentClusters.get(1);
    
    int min = currentClusters.get(1).distances[0];
    
    for (int i = 0; i < currentClusters.size(); i++)
    {
      Cluster cluster = currentClusters.get(i);
      
      for (int j = 0; j < i; j++)
      {
        if (cluster.distances[j] < min)
        {
          cluster0 = currentClusters.get(i);
          cluster1 = currentClusters.get(j);
          
          min = cluster.distances[j];
        }
      }
    }
    
    System.out.println(linkage == Linkage.Single ? "Min Distance: " : "Max Distance: " + min);
    System.out.println("New Cluster: " + cluster0.asString() + " + " + cluster1.asString() + ";");
    
    Cluster newCluster = createNewCluster(cluster0, cluster1, min);
    
    // Recalculate distances and update currentClusters
    
    currentClusters.remove(cluster0);
    currentClusters.remove(cluster1);
    
    currentClusters.add(0, newCluster);
    
    for (int i = 1; i < currentClusters.size(); i++)
    {
      Cluster currentCluster = currentClusters.get(i);
      
      currentCluster.distances = new int[i + 1];
      
      for (int j = 0; j <= i; j++)
      {
        currentCluster.distances[j] = getDistance(currentCluster, currentClusters.get(j));
      }
    }
  }
  
  System.out.println("Finished!");
  System.out.println("Cophenetic matrix:");
  
  for (int i = 0; i < copheneticMatrix.length; i++)
  {
    for (int j = 0; j < copheneticMatrix.length; j++)
    {
      System.out.print(copheneticMatrix[i][j] + ", ");
    }
    
    System.out.println();
  }
}

Cluster createNewCluster(Cluster cluster0, Cluster cluster1, int distance)
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

int getDistance(Cluster cluster0, Cluster cluster1)
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

boolean saved = false;

void draw()
{
  Cluster root = currentClusters.get(0);
  
  drawCluster(root, root.distance);
  
  line(X_PADDING , Y_PADDING, X_PADDING, height - Y_PADDING);
  
  for (int i = root.distance; i >= 0; i--)
  {
    float y = Y_PADDING + (float)i / (float)root.distance * (height - 2 * Y_PADDING);
    
    line(X_PADDING, y, X_PADDING + 10, y);
    text(root.distance - i, X_PADDING, y);
  }
  
  if (!saved)
  {
    save((linkage == Linkage.Single ? "single" : "complete") + ".jpg");
    
    saved = true;
  }
}

class Point
{
  float x;
  float y;
  
  public Point(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
}

Point drawCluster(Cluster cluster, int maxDistance)
{
  //System.out.println(cluster.distance);
  
  float x = cluster.xm * (width - 2 * X_PADDING) / originalDistances.length + 2 * X_PADDING;
  float y = Y_PADDING + ((float)maxDistance - (float)cluster.distance) / (float)maxDistance * (height - 2 * Y_PADDING); 
  
  if (cluster.clusters != null)
  {
    Point p1 = drawCluster(cluster.clusters[0], maxDistance);
    Point p2 = drawCluster(cluster.clusters[1], maxDistance);
    
    line(p1.x, p1.y, p1.x, y);
    line(p2.x, p2.y, p2.x, y);
    line(p1.x, y, p2.x, y);
  }
  
  text(cluster.asString(), x, y);
  
  return new Point(x, y);
}
