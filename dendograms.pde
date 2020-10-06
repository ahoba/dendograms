import java.util.*;
import java.util.ArrayList;

int X_PADDING = 100;
int Y_PADDING = 50;

int initialLength = 0;

enum Linkage
{
  Single,
  Complete
}

ProblemContext pcontext = new ProblemContext();

void setup()
{
  size(1000, 500);
  
  textAlign(CENTER);
  
  fill(0, 0, 255);
  
  pcontext.linkage = Linkage.Single;
  
  pcontext.originalDistances = new int[][]
  {
    { 0, 2, 6, 10, 9 },
    { 2, 0, 5, 9, 8 },
    { 6, 5, 0, 4, 5 },
    { 10, 9, 4, 0, 3 },
    { 9, 8, 5, 3, 0 }
  };
  
  pcontext.copheneticMatrix = new int[][] { { } };

  loadInput(pcontext);
  
  setupInitialCondition(pcontext);
  
  solve(pcontext);
  
  System.out.println("Finished!");
  System.out.println("Cophenetic matrix:");
  
  printMatrix(pcontext.copheneticMatrix);
}

boolean saved = false;

void draw()
{
  Cluster root = pcontext.currentClusters.get(0);
  
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
    save((pcontext.linkage == Linkage.Single ? "single" : "complete") + ".jpg");
    
    saved = true;
  }
}
