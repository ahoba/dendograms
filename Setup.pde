class ProblemContext
{
  Linkage linkage;
  
  ArrayList<Cluster> currentClusters;
  
  int[][] originalDistances;
  
  int[][] copheneticMatrix;
}

void loadInput(ProblemContext context)
{
  String[] input = loadStrings("input.txt");
  
  if (input != null)
  {
    if (input[0].equals("Single"))
    {
      context.linkage = Linkage.Single;
      
      System.out.println("Linkage Mode: Single");
    }
    else if (input[0].equals("Complete"))
    {
      context.linkage = Linkage.Complete;
      
      System.out.println("Linkage Mode: Complete");
    }
    else
    {
      System.out.println("Unable to determine linkage mode, proceeding with default (Single).");
    }
    
    context.originalDistances = new int[input.length - 1][input.length - 1];
    
    for (int i = 1; i < input.length; i++)
    {
      String[] numbers = input[i].split(" ");
      
      for (int j = 0; j < numbers.length; j++)
      {
        context.originalDistances[i - 1][j] = Integer.parseInt(numbers[j]);
      }
    }
    
    // TO DO: Validate inputs
  }
  
  initialLength = context.originalDistances.length;
}

void setupInitialCondition(ProblemContext context)
{
  context.currentClusters = new ArrayList<Cluster>();
  
  for (int i = 0; i < context.originalDistances.length; i++)
  {
    int[] distances = new int[i + 1];
    
    for (int j = 0; j <= i; j++)
    {
      distances[j] = context.originalDistances[i][j];
    }
    
    Cluster cluster = new Cluster(new int[] { i }, distances); 
    
    cluster.xm = i;
    cluster.ym = 0;
    cluster.distance = 0;
    
    context.currentClusters.add(cluster);
  }
  
  context.copheneticMatrix = new int[context.originalDistances.length][context.originalDistances.length];
}
