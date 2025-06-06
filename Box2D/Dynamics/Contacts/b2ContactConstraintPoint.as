package Box2D.Dynamics.Contacts
{
   import Box2D.Common.Math.b2Vec2;
   
   public class b2ContactConstraintPoint
   {
      
      public var localPoint:b2Vec2 = new b2Vec2();
      
      public var rA:b2Vec2 = new b2Vec2();
      
      public var rB:b2Vec2 = new b2Vec2();
      
      public var normalImpulse:Number;
      
      public var tangentImpulse:Number;
      
      public var normalMass:Number;
      
      public var tangentMass:Number;
      
      public var equalizedMass:Number;
      
      public var velocityBias:Number;
      
      public function b2ContactConstraintPoint()
      {
         super();
      }
   }
}

