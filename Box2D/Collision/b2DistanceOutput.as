package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   
   public class b2DistanceOutput
   {
      
      public var pointA:b2Vec2 = new b2Vec2();
      
      public var pointB:b2Vec2 = new b2Vec2();
      
      public var distance:Number;
      
      public var iterations:int;
      
      public function b2DistanceOutput()
      {
         super();
      }
   }
}

