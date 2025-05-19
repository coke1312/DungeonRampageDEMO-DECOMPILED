package Box2D.Dynamics
{
   import Box2D.Collision.IBroadPhase;
   import Box2D.Collision.Shapes.b2MassData;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Collision.b2RayCastOutput;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   
   use namespace b2internal;
   
   public class b2Fixture
   {
      
      private var m_massData:b2MassData;
      
      b2internal var m_aabb:b2AABB;
      
      b2internal var m_density:Number;
      
      b2internal var m_next:b2Fixture;
      
      b2internal var m_body:b2Body;
      
      b2internal var m_shape:b2Shape;
      
      b2internal var m_friction:Number;
      
      b2internal var m_restitution:Number;
      
      b2internal var m_proxy:*;
      
      b2internal var m_filter:b2FilterData = new b2FilterData();
      
      b2internal var m_isSensor:Boolean;
      
      b2internal var m_userData:*;
      
      public function b2Fixture()
      {
         super();
         this.b2internal::m_aabb = new b2AABB();
         this.b2internal::m_userData = null;
         this.b2internal::m_body = null;
         this.b2internal::m_next = null;
         this.b2internal::m_shape = null;
         this.b2internal::m_density = 0;
         this.b2internal::m_friction = 0;
         this.b2internal::m_restitution = 0;
      }
      
      public function GetType() : int
      {
         return this.b2internal::m_shape.GetType();
      }
      
      public function GetShape() : b2Shape
      {
         return this.b2internal::m_shape;
      }
      
      public function SetSensor(param1:Boolean) : void
      {
         var _loc3_:b2Contact = null;
         var _loc4_:b2Fixture = null;
         var _loc5_:b2Fixture = null;
         if(this.b2internal::m_isSensor == param1)
         {
            return;
         }
         this.b2internal::m_isSensor = param1;
         if(this.b2internal::m_body == null)
         {
            return;
         }
         var _loc2_:b2ContactEdge = this.b2internal::m_body.GetContactList();
         while(_loc2_)
         {
            _loc3_ = _loc2_.contact;
            _loc4_ = _loc3_.GetFixtureA();
            _loc5_ = _loc3_.GetFixtureB();
            if(_loc4_ == this || _loc5_ == this)
            {
               _loc3_.SetSensor(_loc4_.IsSensor() || _loc5_.IsSensor());
            }
            _loc2_ = _loc2_.next;
         }
      }
      
      public function IsSensor() : Boolean
      {
         return this.b2internal::m_isSensor;
      }
      
      public function SetFilterData(param1:b2FilterData) : void
      {
         var _loc3_:b2Contact = null;
         var _loc4_:b2Fixture = null;
         var _loc5_:b2Fixture = null;
         this.b2internal::m_filter = param1.Copy();
         if(this.b2internal::m_body)
         {
            return;
         }
         var _loc2_:b2ContactEdge = this.b2internal::m_body.GetContactList();
         while(_loc2_)
         {
            _loc3_ = _loc2_.contact;
            _loc4_ = _loc3_.GetFixtureA();
            _loc5_ = _loc3_.GetFixtureB();
            if(_loc4_ == this || _loc5_ == this)
            {
               _loc3_.FlagForFiltering();
            }
            _loc2_ = _loc2_.next;
         }
      }
      
      public function GetFilterData() : b2FilterData
      {
         return this.b2internal::m_filter.Copy();
      }
      
      public function GetBody() : b2Body
      {
         return this.b2internal::m_body;
      }
      
      public function GetNext() : b2Fixture
      {
         return this.b2internal::m_next;
      }
      
      public function GetUserData() : *
      {
         return this.b2internal::m_userData;
      }
      
      public function SetUserData(param1:*) : void
      {
         this.b2internal::m_userData = param1;
      }
      
      public function TestPoint(param1:b2Vec2) : Boolean
      {
         return this.b2internal::m_shape.TestPoint(this.b2internal::m_body.GetTransform(),param1);
      }
      
      public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput) : Boolean
      {
         return this.b2internal::m_shape.RayCast(param1,param2,this.b2internal::m_body.GetTransform());
      }
      
      public function GetMassData(param1:b2MassData = null) : b2MassData
      {
         if(param1 == null)
         {
            param1 = new b2MassData();
         }
         this.b2internal::m_shape.ComputeMass(param1,this.b2internal::m_density);
         return param1;
      }
      
      public function SetDensity(param1:Number) : void
      {
         this.b2internal::m_density = param1;
      }
      
      public function GetDensity() : Number
      {
         return this.b2internal::m_density;
      }
      
      public function GetFriction() : Number
      {
         return this.b2internal::m_friction;
      }
      
      public function SetFriction(param1:Number) : void
      {
         this.b2internal::m_friction = param1;
      }
      
      public function GetRestitution() : Number
      {
         return this.b2internal::m_restitution;
      }
      
      public function SetRestitution(param1:Number) : void
      {
         this.b2internal::m_restitution = param1;
      }
      
      public function GetAABB() : b2AABB
      {
         return this.b2internal::m_aabb;
      }
      
      b2internal function Create(param1:b2Body, param2:b2Transform, param3:b2FixtureDef) : void
      {
         this.b2internal::m_userData = param3.userData;
         this.b2internal::m_friction = param3.friction;
         this.b2internal::m_restitution = param3.restitution;
         this.b2internal::m_body = param1;
         this.b2internal::m_next = null;
         this.b2internal::m_filter = param3.filter.Copy();
         this.b2internal::m_isSensor = param3.isSensor;
         this.b2internal::m_shape = param3.shape.Copy();
         this.b2internal::m_density = param3.density;
      }
      
      b2internal function Destroy() : void
      {
         this.b2internal::m_shape = null;
      }
      
      b2internal function CreateProxy(param1:IBroadPhase, param2:b2Transform) : void
      {
         this.b2internal::m_shape.ComputeAABB(this.b2internal::m_aabb,param2);
         this.b2internal::m_proxy = param1.CreateProxy(this.b2internal::m_aabb,this);
      }
      
      b2internal function DestroyProxy(param1:IBroadPhase) : void
      {
         if(this.b2internal::m_proxy == null)
         {
            return;
         }
         param1.DestroyProxy(this.b2internal::m_proxy);
         this.b2internal::m_proxy = null;
      }
      
      b2internal function Synchronize(param1:IBroadPhase, param2:b2Transform, param3:b2Transform) : void
      {
         if(!this.b2internal::m_proxy)
         {
            return;
         }
         var _loc4_:b2AABB = new b2AABB();
         var _loc5_:b2AABB = new b2AABB();
         this.b2internal::m_shape.ComputeAABB(_loc4_,param2);
         this.b2internal::m_shape.ComputeAABB(_loc5_,param3);
         this.b2internal::m_aabb.Combine(_loc4_,_loc5_);
         var _loc6_:b2Vec2 = b2Math.SubtractVV(param3.position,param2.position);
         param1.MoveProxy(this.b2internal::m_proxy,this.b2internal::m_aabb,_loc6_);
      }
   }
}

