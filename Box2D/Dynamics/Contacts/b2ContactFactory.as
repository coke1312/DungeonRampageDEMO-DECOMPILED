package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   
   use namespace b2internal;
   
   public class b2ContactFactory
   {
      
      private var m_registers:Vector.<Vector.<b2ContactRegister>>;
      
      private var m_allocator:*;
      
      public function b2ContactFactory(param1:*)
      {
         super();
         this.m_allocator = param1;
         this.b2internal::InitializeRegisters();
      }
      
      b2internal function AddType(param1:Function, param2:Function, param3:int, param4:int) : void
      {
         this.m_registers[param3][param4].createFcn = param1;
         this.m_registers[param3][param4].destroyFcn = param2;
         this.m_registers[param3][param4].primary = true;
         if(param3 != param4)
         {
            this.m_registers[param4][param3].createFcn = param1;
            this.m_registers[param4][param3].destroyFcn = param2;
            this.m_registers[param4][param3].primary = false;
         }
      }
      
      b2internal function InitializeRegisters() : void
      {
         var _loc2_:int = 0;
         this.m_registers = new Vector.<Vector.<b2ContactRegister>>(b2Shape.b2internal::e_shapeTypeCount);
         var _loc1_:int = 0;
         while(_loc1_ < b2Shape.b2internal::e_shapeTypeCount)
         {
            this.m_registers[_loc1_] = new Vector.<b2ContactRegister>(b2Shape.b2internal::e_shapeTypeCount);
            _loc2_ = 0;
            while(_loc2_ < b2Shape.b2internal::e_shapeTypeCount)
            {
               this.m_registers[_loc1_][_loc2_] = new b2ContactRegister();
               _loc2_++;
            }
            _loc1_++;
         }
         this.b2internal::AddType(b2CircleContact.Create,b2CircleContact.Destroy,b2Shape.b2internal::e_circleShape,b2Shape.b2internal::e_circleShape);
         this.b2internal::AddType(b2PolyAndCircleContact.Create,b2PolyAndCircleContact.Destroy,b2Shape.b2internal::e_polygonShape,b2Shape.b2internal::e_circleShape);
         this.b2internal::AddType(b2PolygonContact.Create,b2PolygonContact.Destroy,b2Shape.b2internal::e_polygonShape,b2Shape.b2internal::e_polygonShape);
         this.b2internal::AddType(b2EdgeAndCircleContact.Create,b2EdgeAndCircleContact.Destroy,b2Shape.b2internal::e_edgeShape,b2Shape.b2internal::e_circleShape);
         this.b2internal::AddType(b2PolyAndEdgeContact.Create,b2PolyAndEdgeContact.Destroy,b2Shape.b2internal::e_polygonShape,b2Shape.b2internal::e_edgeShape);
      }
      
      public function Create(param1:b2Fixture, param2:b2Fixture) : b2Contact
      {
         var _loc6_:b2Contact = null;
         var _loc3_:int = param1.GetType();
         var _loc4_:int = param2.GetType();
         var _loc5_:b2ContactRegister = this.m_registers[_loc3_][_loc4_];
         if(_loc5_.pool)
         {
            _loc6_ = _loc5_.pool;
            _loc5_.pool = _loc6_.b2internal::m_next;
            --_loc5_.poolCount;
            _loc6_.b2internal::Reset(param1,param2);
            return _loc6_;
         }
         var _loc7_:Function = _loc5_.createFcn;
         if(_loc7_ != null)
         {
            if(_loc5_.primary)
            {
               _loc6_ = _loc7_(this.m_allocator);
               _loc6_.b2internal::Reset(param1,param2);
               return _loc6_;
            }
            _loc6_ = _loc7_(this.m_allocator);
            _loc6_.b2internal::Reset(param2,param1);
            return _loc6_;
         }
         return null;
      }
      
      public function Destroy(param1:b2Contact) : void
      {
         if(param1.b2internal::m_manifold.m_pointCount > 0)
         {
            param1.b2internal::m_fixtureA.b2internal::m_body.SetAwake(true);
            param1.b2internal::m_fixtureB.b2internal::m_body.SetAwake(true);
         }
         var _loc2_:int = param1.b2internal::m_fixtureA.GetType();
         var _loc3_:int = param1.b2internal::m_fixtureB.GetType();
         var _loc4_:b2ContactRegister = this.m_registers[_loc2_][_loc3_];
         ++_loc4_.poolCount;
         param1.b2internal::m_next = _loc4_.pool;
         _loc4_.pool = param1;
         var _loc5_:Function = _loc4_.destroyFcn;
         _loc5_(param1,this.m_allocator);
      }
   }
}

