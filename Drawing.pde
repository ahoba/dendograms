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
  
  float x = cluster.xm * (width - 2 * X_PADDING) / initialLength + 2 * X_PADDING;
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
