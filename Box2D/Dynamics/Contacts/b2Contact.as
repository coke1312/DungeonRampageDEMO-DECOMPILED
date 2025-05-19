package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   
   use namespace b2internal;
   
   public class b2Contact
   {
      
      b2internal static var e_sensorFlag:uint = 1;
      
      b2internal static var e_continuousFlag:uint = 2;
      
      b2internal static var e_islandFlag:uint = 4;
      
      b2internal static var e_toiFlag:uint = 8;
      
      b2internal static var e_touchingFlag:uint = 16;
      
      b2internal static var e_enabledFlag:uint = 32;
      
      b2internal static var e_filterFlag:uint = 64;
      
      private static var s_input:b2TOIInput = new b2TOIInput();
      
      b2internal var m_flags:uint;
      
      b2internal var m_prev:b2Contact;
      
      b2internal var m_next:b2Contact;
      
      b2internal var m_nodeA:b2ContactEdge = new b2ContactEdge();
      
      b2internal var m_nodeB:b2ContactEdge = new b2ContactEdge();
      
      b2internal var m_fixtureA:b2Fixture;
      
      b2internal var m_fixtureB:b2Fixture;
      
      b2internal var m_manifold:b2Manifold = new b2Manifold();
      
      b2internal var m_oldManifold:b2Manifold = new b2Manifold();
      
      b2internal var m_toi:Number;
      
      public function b2Contact()
      {
         super();
      }
      
      public function GetManifold() : b2Manifold
      {
         return this.b2internal::m_manifold;
      }
      
      public function GetWorldManifold(param1:b2WorldManifold) : void
      {
         var _loc2_:b2Body = this.b2internal::m_fixtureA.GetBody();
         var _loc3_:b2Body = this.b2internal::m_fixtureB.GetBody();
         var _loc4_:b2Shape = this.b2internal::m_fixtureA.GetShape();
         var _loc5_:b2Shape = this.b2internal::m_fixtureB.GetShape();
         param1.Initialize(this.b2internal::m_manifold,_loc2_.GetTransform(),_loc4_.b2internal::m_radius,_loc3_.GetTransform(),_loc5_.b2internal::m_radius);
      }
      
      public function IsTouching() : Boolean
      {
         return (this.b2internal::m_flags & b2internal::e_touchingFlag) == b2internal::e_touchingFlag;
      }
      
      public function IsContinuous() : Boolean
      {
         return (this.b2internal::m_flags & b2internal::e_continuousFlag) == b2internal::e_continuousFlag;
      }
      
      public function SetSensor(param1:Boolean) : void
      {
         if(param1)
         {
            this.b2internal::m_flags |= b2internal::e_sensorFlag;
         }
         else
         {
            this.b2internal::m_flags &= ~b2internal::e_sensorFlag;
         }
      }
      
      public function IsSensor() : Boolean
      {
         return (this.b2internal::m_flags & b2internal::e_sensorFlag) == b2internal::e_sensorFlag;
      }
      
      public function SetEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.b2internal::m_flags |= b2internal::e_enabledFlag;
         }
         else
         {
            this.b2internal::m_flags &= ~b2internal::e_enabledFlag;
         }
      }
      
      public function IsEnabled() : Boolean
      {
         return (this.b2internal::m_flags & b2internal::e_enabledFlag) == b2internal::e_enabledFlag;
      }
      
      public function GetNext() : b2Contact
      {
         return this.b2internal::m_next;
      }
      
      public function GetFixtureA() : b2Fixture
      {
         return this.b2internal::m_fixtureA;
      }
      
      public function GetFixtureB() : b2Fixture
      {
         return this.b2internal::m_fixtureB;
      }
      
      public function FlagForFiltering() : void
      {
         this.b2internal::m_flags |= b2internal::e_filterFlag;
      }
      
      b2internal function Reset(param1:b2Fixture = null, param2:b2Fixture = null) : void
      {
         this.b2internal::m_flags = b2internal::e_enabledFlag;
         if(!param1 || !param2)
         {
            this.b2internal::m_fixtureA = null;
            this.b2internal::m_fixtureB = null;
            return;
         }
         if(param1.IsSensor() || param2.IsSensor())
         {
            this.b2internal::m_flags |= b2internal::e_sensorFlag;
         }
         var _loc3_:b2Body = param1.GetBody();
         var _loc4_:b2Body = param2.GetBody();
         if(_loc3_.GetType() != b2Body.b2_dynamicBody || _loc3_.IsBullet() || _loc4_.GetType() != b2Body.b2_dynamicBody || _loc4_.IsBullet())
         {
            this.b2internal::m_flags |= b2internal::e_continuousFlag;
         }
         this.b2internal::m_fixtureA = param1;
         this.b2internal::m_fixtureB = param2;
         this.b2internal::m_manifold.m_pointCount = 0;
         this.b2internal::m_prev = null;
         this.b2internal::m_next = null;
         this.b2internal::m_nodeA.contact = null;
         this.b2internal::m_nodeA.prev = null;
         this.b2internal::m_nodeA.next = null;
         this.b2internal::m_nodeA.other = null;
         this.b2internal::m_nodeB.contact = null;
         this.b2internal::m_nodeB.prev = null;
         this.b2internal::m_nodeB.next = null;
         this.b2internal::m_nodeB.other = null;
      }
      
      b2internal function Update(param1:b2ContactListener) : void
      {
         var _loc8_:b2Shape = null;
         var _loc9_:b2Shape = null;
         var _loc10_:b2Transform = null;
         var _loc11_:b2Transform = null;
         var _loc12_:int = 0;
         var _loc13_:b2ManifoldPoint = null;
         var _loc14_:b2ContactID = null;
         var _loc15_:int = 0;
         var _loc16_:b2ManifoldPoint = null;
         var _loc2_:b2Manifold = this.b2internal::m_oldManifold;
         this.b2internal::m_oldManifold = this.b2internal::m_manifold;
         this.b2internal::m_manifold = _loc2_;
         this.b2internal::m_flags |= b2internal::e_enabledFlag;
         var _loc3_:* = false;
         var _loc4_:* = (this.b2internal::m_flags & b2internal::e_touchingFlag) == b2internal::e_touchingFlag;
         var _loc5_:b2Body = this.b2internal::m_fixtureA.b2internal::m_body;
         var _loc6_:b2Body = this.b2internal::m_fixtureB.b2internal::m_body;
         var _loc7_:Boolean = this.b2internal::m_fixtureA.b2internal::m_aabb.TestOverlap(this.b2internal::m_fixtureB.b2internal::m_aabb);
         if(this.b2internal::m_flags & b2internal::e_sensorFlag)
         {
            if(_loc7_)
            {
               _loc8_ = this.b2internal::m_fixtureA.GetShape();
               _loc9_ = this.b2internal::m_fixtureB.GetShape();
               _loc10_ = _loc5_.GetTransform();
               _loc11_ = _loc6_.GetTransform();
               _loc3_ = b2Shape.TestOverlap(_loc8_,_loc10_,_loc9_,_loc11_);
            }
            this.b2internal::m_manifold.m_pointCount = 0;
         }
         else
         {
            if(_loc5_.GetType() != b2Body.b2_dynamicBody || _loc5_.IsBullet() || _loc6_.GetType() != b2Body.b2_dynamicBody || _loc6_.IsBullet())
            {
               this.b2internal::m_flags |= b2internal::e_continuousFlag;
            }
            else
            {
               this.b2internal::m_flags &= ~b2internal::e_continuousFlag;
            }
            if(_loc7_)
            {
               this.b2internal::Evaluate();
               _loc3_ = this.b2internal::m_manifold.m_pointCount > 0;
               _loc12_ = 0;
               while(_loc12_ < this.b2internal::m_manifold.m_pointCount)
               {
                  _loc13_ = this.b2internal::m_manifold.m_points[_loc12_];
                  _loc13_.m_normalImpulse = 0;
                  _loc13_.m_tangentImpulse = 0;
                  _loc14_ = _loc13_.m_id;
                  _loc15_ = 0;
                  while(_loc15_ < this.b2internal::m_oldManifold.m_pointCount)
                  {
                     _loc16_ = this.b2internal::m_oldManifold.m_points[_loc15_];
                     if(_loc16_.m_id.key == _loc14_.key)
                     {
                        _loc13_.m_normalImpulse = _loc16_.m_normalImpulse;
                        _loc13_.m_tangentImpulse = _loc16_.m_tangentImpulse;
                        break;
                     }
                     _loc15_++;
                  }
                  _loc12_++;
               }
            }
            else
            {
               this.b2internal::m_manifold.m_pointCount = 0;
            }
            if(_loc3_ != _loc4_)
            {
               _loc5_.SetAwake(true);
               _loc6_.SetAwake(true);
            }
         }
         if(_loc3_)
         {
            this.b2internal::m_flags |= b2internal::e_touchingFlag;
         }
         else
         {
            this.b2internal::m_flags &= ~b2internal::e_touchingFlag;
         }
         if(_loc4_ == false && _loc3_ == true)
         {
            param1.BeginContact(this);
         }
         if(_loc4_ == true && _loc3_ == false)
         {
            param1.EndContact(this);
         }
         if((this.b2internal::m_flags & b2internal::e_sensorFlag) == 0)
         {
            param1.PreSolve(this,this.b2internal::m_oldManifold);
         }
      }
      
      b2internal function Evaluate() : void
      {
      }
      
      b2internal function ComputeTOI(param1:b2Sweep, param2:b2Sweep) : Number
      {
         s_input.proxyA.Set(this.b2internal::m_fixtureA.GetShape());
         s_input.proxyB.Set(this.b2internal::m_fixtureB.GetShape());
         s_input.sweepA = param1;
         s_input.sweepB = param2;
         s_input.tolerance = b2Settings.b2_linearSlop;
         return b2TimeOfImpact.TimeOfImpact(s_input);
      }
   }
}

