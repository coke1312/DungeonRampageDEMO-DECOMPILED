package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   
   use namespace b2internal;
   
   public class b2WeldJointDef extends b2JointDef
   {
      
      public var localAnchorA:b2Vec2 = new b2Vec2();
      
      public var localAnchorB:b2Vec2 = new b2Vec2();
      
      public var referenceAngle:Number;
      
      public function b2WeldJointDef()
      {
         super();
         type = b2Joint.b2internal::e_weldJoint;
         this.referenceAngle = 0;
      }
      
      public function Initialize(param1:b2Body, param2:b2Body, param3:b2Vec2) : void
      {
         bodyA = param1;
         bodyB = param2;
         this.localAnchorA.SetV(bodyA.GetLocalPoint(param3));
         this.localAnchorB.SetV(bodyB.GetLocalPoint(param3));
         this.referenceAngle = bodyB.GetAngle() - bodyA.GetAngle();
      }
   }
}

