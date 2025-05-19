package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2Joint
   {
      
      b2internal static const e_unknownJoint:int = 0;
      
      b2internal static const e_revoluteJoint:int = 1;
      
      b2internal static const e_prismaticJoint:int = 2;
      
      b2internal static const e_distanceJoint:int = 3;
      
      b2internal static const e_pulleyJoint:int = 4;
      
      b2internal static const e_mouseJoint:int = 5;
      
      b2internal static const e_gearJoint:int = 6;
      
      b2internal static const e_lineJoint:int = 7;
      
      b2internal static const e_weldJoint:int = 8;
      
      b2internal static const e_frictionJoint:int = 9;
      
      b2internal static const e_inactiveLimit:int = 0;
      
      b2internal static const e_atLowerLimit:int = 1;
      
      b2internal static const e_atUpperLimit:int = 2;
      
      b2internal static const e_equalLimits:int = 3;
      
      b2internal var m_type:int;
      
      b2internal var m_prev:b2Joint;
      
      b2internal var m_next:b2Joint;
      
      b2internal var m_edgeA:b2JointEdge = new b2JointEdge();
      
      b2internal var m_edgeB:b2JointEdge = new b2JointEdge();
      
      b2internal var m_bodyA:b2Body;
      
      b2internal var m_bodyB:b2Body;
      
      b2internal var m_islandFlag:Boolean;
      
      b2internal var m_collideConnected:Boolean;
      
      private var m_userData:*;
      
      b2internal var m_localCenterA:b2Vec2 = new b2Vec2();
      
      b2internal var m_localCenterB:b2Vec2 = new b2Vec2();
      
      b2internal var m_invMassA:Number;
      
      b2internal var m_invMassB:Number;
      
      b2internal var m_invIA:Number;
      
      b2internal var m_invIB:Number;
      
      public function b2Joint(param1:b2JointDef)
      {
         super();
         b2Settings.b2Assert(param1.bodyA != param1.bodyB);
         this.b2internal::m_type = param1.type;
         this.b2internal::m_prev = null;
         this.b2internal::m_next = null;
         this.b2internal::m_bodyA = param1.bodyA;
         this.b2internal::m_bodyB = param1.bodyB;
         this.b2internal::m_collideConnected = param1.collideConnected;
         this.b2internal::m_islandFlag = false;
         this.m_userData = param1.userData;
      }
      
      b2internal static function Create(param1:b2JointDef, param2:*) : b2Joint
      {
         var _loc3_:b2Joint = null;
         switch(param1.type)
         {
            case b2internal::e_distanceJoint:
               _loc3_ = new b2DistanceJoint(param1 as b2DistanceJointDef);
               break;
            case b2internal::e_mouseJoint:
               _loc3_ = new b2MouseJoint(param1 as b2MouseJointDef);
               break;
            case b2internal::e_prismaticJoint:
               _loc3_ = new b2PrismaticJoint(param1 as b2PrismaticJointDef);
               break;
            case b2internal::e_revoluteJoint:
               _loc3_ = new b2RevoluteJoint(param1 as b2RevoluteJointDef);
               break;
            case b2internal::e_pulleyJoint:
               _loc3_ = new b2PulleyJoint(param1 as b2PulleyJointDef);
               break;
            case b2internal::e_gearJoint:
               _loc3_ = new b2GearJoint(param1 as b2GearJointDef);
               break;
            case b2internal::e_lineJoint:
               _loc3_ = new b2LineJoint(param1 as b2LineJointDef);
               break;
            case b2internal::e_weldJoint:
               _loc3_ = new b2WeldJoint(param1 as b2WeldJointDef);
               break;
            case b2internal::e_frictionJoint:
               _loc3_ = new b2FrictionJoint(param1 as b2FrictionJointDef);
         }
         return _loc3_;
      }
      
      b2internal static function Destroy(param1:b2Joint, param2:*) : void
      {
      }
      
      public function GetType() : int
      {
         return this.b2internal::m_type;
      }
      
      public function GetAnchorA() : b2Vec2
      {
         return null;
      }
      
      public function GetAnchorB() : b2Vec2
      {
         return null;
      }
      
      public function GetReactionForce(param1:Number) : b2Vec2
      {
         return null;
      }
      
      public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetBodyA() : b2Body
      {
         return this.b2internal::m_bodyA;
      }
      
      public function GetBodyB() : b2Body
      {
         return this.b2internal::m_bodyB;
      }
      
      public function GetNext() : b2Joint
      {
         return this.b2internal::m_next;
      }
      
      public function GetUserData() : *
      {
         return this.m_userData;
      }
      
      public function SetUserData(param1:*) : void
      {
         this.m_userData = param1;
      }
      
      public function IsActive() : Boolean
      {
         return this.b2internal::m_bodyA.IsActive() && this.b2internal::m_bodyB.IsActive();
      }
      
      b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
      }
      
      b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
      }
      
      b2internal function FinalizeVelocityConstraints() : void
      {
      }
      
      b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         return false;
      }
   }
}

