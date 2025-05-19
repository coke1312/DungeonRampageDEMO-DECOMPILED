package Box2D.Dynamics
{
   import Box2D.Collision.IBroadPhase;
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Collision.b2DynamicTreeBroadPhase;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.Contacts.b2ContactFactory;
   
   use namespace b2internal;
   
   public class b2ContactManager
   {
      
      private static const s_evalCP:b2ContactPoint = new b2ContactPoint();
      
      b2internal var m_world:b2World;
      
      b2internal var m_broadPhase:IBroadPhase;
      
      b2internal var m_contactList:b2Contact;
      
      b2internal var m_contactCount:int;
      
      b2internal var m_contactFilter:b2ContactFilter;
      
      b2internal var m_contactListener:b2ContactListener;
      
      b2internal var m_contactFactory:b2ContactFactory;
      
      b2internal var m_allocator:*;
      
      public function b2ContactManager()
      {
         super();
         this.b2internal::m_world = null;
         this.b2internal::m_contactCount = 0;
         this.b2internal::m_contactFilter = b2ContactFilter.b2internal::b2_defaultFilter;
         this.b2internal::m_contactListener = b2ContactListener.b2internal::b2_defaultListener;
         this.b2internal::m_contactFactory = new b2ContactFactory(this.b2internal::m_allocator);
         this.b2internal::m_broadPhase = new b2DynamicTreeBroadPhase();
      }
      
      public function AddPair(param1:*, param2:*) : void
      {
         var _loc9_:b2Fixture = null;
         var _loc10_:b2Fixture = null;
         var _loc3_:b2Fixture = param1 as b2Fixture;
         var _loc4_:b2Fixture = param2 as b2Fixture;
         var _loc5_:b2Body = _loc3_.GetBody();
         var _loc6_:b2Body = _loc4_.GetBody();
         if(_loc5_ == _loc6_)
         {
            return;
         }
         var _loc7_:b2ContactEdge = _loc6_.GetContactList();
         while(_loc7_)
         {
            if(_loc7_.other == _loc5_)
            {
               _loc9_ = _loc7_.contact.GetFixtureA();
               _loc10_ = _loc7_.contact.GetFixtureB();
               if(_loc9_ == _loc3_ && _loc10_ == _loc4_)
               {
                  return;
               }
               if(_loc9_ == _loc4_ && _loc10_ == _loc3_)
               {
                  return;
               }
            }
            _loc7_ = _loc7_.next;
         }
         if(_loc6_.b2internal::ShouldCollide(_loc5_) == false)
         {
            return;
         }
         if(this.b2internal::m_contactFilter.ShouldCollide(_loc3_,_loc4_) == false)
         {
            return;
         }
         var _loc8_:b2Contact = this.b2internal::m_contactFactory.Create(_loc3_,_loc4_);
         _loc3_ = _loc8_.GetFixtureA();
         _loc4_ = _loc8_.GetFixtureB();
         _loc5_ = _loc3_.b2internal::m_body;
         _loc6_ = _loc4_.b2internal::m_body;
         _loc8_.b2internal::m_prev = null;
         _loc8_.b2internal::m_next = this.b2internal::m_world.b2internal::m_contactList;
         if(this.b2internal::m_world.b2internal::m_contactList != null)
         {
            this.b2internal::m_world.b2internal::m_contactList.b2internal::m_prev = _loc8_;
         }
         this.b2internal::m_world.b2internal::m_contactList = _loc8_;
         _loc8_.b2internal::m_nodeA.contact = _loc8_;
         _loc8_.b2internal::m_nodeA.other = _loc6_;
         _loc8_.b2internal::m_nodeA.prev = null;
         _loc8_.b2internal::m_nodeA.next = _loc5_.b2internal::m_contactList;
         if(_loc5_.b2internal::m_contactList != null)
         {
            _loc5_.b2internal::m_contactList.prev = _loc8_.b2internal::m_nodeA;
         }
         _loc5_.b2internal::m_contactList = _loc8_.b2internal::m_nodeA;
         _loc8_.b2internal::m_nodeB.contact = _loc8_;
         _loc8_.b2internal::m_nodeB.other = _loc5_;
         _loc8_.b2internal::m_nodeB.prev = null;
         _loc8_.b2internal::m_nodeB.next = _loc6_.b2internal::m_contactList;
         if(_loc6_.b2internal::m_contactList != null)
         {
            _loc6_.b2internal::m_contactList.prev = _loc8_.b2internal::m_nodeB;
         }
         _loc6_.b2internal::m_contactList = _loc8_.b2internal::m_nodeB;
         ++this.b2internal::m_world.b2internal::m_contactCount;
      }
      
      public function FindNewContacts() : void
      {
         this.b2internal::m_broadPhase.UpdatePairs(this.AddPair);
      }
      
      public function Destroy(param1:b2Contact) : void
      {
         var _loc2_:b2Fixture = param1.GetFixtureA();
         var _loc3_:b2Fixture = param1.GetFixtureB();
         var _loc4_:b2Body = _loc2_.GetBody();
         var _loc5_:b2Body = _loc3_.GetBody();
         if(param1.IsTouching())
         {
            this.b2internal::m_contactListener.EndContact(param1);
         }
         if(param1.b2internal::m_prev)
         {
            param1.b2internal::m_prev.b2internal::m_next = param1.b2internal::m_next;
         }
         if(param1.b2internal::m_next)
         {
            param1.b2internal::m_next.b2internal::m_prev = param1.b2internal::m_prev;
         }
         if(param1 == this.b2internal::m_world.b2internal::m_contactList)
         {
            this.b2internal::m_world.b2internal::m_contactList = param1.b2internal::m_next;
         }
         if(param1.b2internal::m_nodeA.prev)
         {
            param1.b2internal::m_nodeA.prev.next = param1.b2internal::m_nodeA.next;
         }
         if(param1.b2internal::m_nodeA.next)
         {
            param1.b2internal::m_nodeA.next.prev = param1.b2internal::m_nodeA.prev;
         }
         if(param1.b2internal::m_nodeA == _loc4_.b2internal::m_contactList)
         {
            _loc4_.b2internal::m_contactList = param1.b2internal::m_nodeA.next;
         }
         if(param1.b2internal::m_nodeB.prev)
         {
            param1.b2internal::m_nodeB.prev.next = param1.b2internal::m_nodeB.next;
         }
         if(param1.b2internal::m_nodeB.next)
         {
            param1.b2internal::m_nodeB.next.prev = param1.b2internal::m_nodeB.prev;
         }
         if(param1.b2internal::m_nodeB == _loc5_.b2internal::m_contactList)
         {
            _loc5_.b2internal::m_contactList = param1.b2internal::m_nodeB.next;
         }
         this.b2internal::m_contactFactory.Destroy(param1);
         --this.b2internal::m_contactCount;
      }
      
      public function Collide() : void
      {
         var _loc2_:b2Fixture = null;
         var _loc3_:b2Fixture = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Body = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Boolean = false;
         var _loc9_:b2Contact = null;
         var _loc1_:b2Contact = this.b2internal::m_world.b2internal::m_contactList;
         while(_loc1_)
         {
            _loc2_ = _loc1_.GetFixtureA();
            _loc3_ = _loc1_.GetFixtureB();
            _loc4_ = _loc2_.GetBody();
            _loc5_ = _loc3_.GetBody();
            if(_loc4_.IsAwake() == false && _loc5_.IsAwake() == false)
            {
               _loc1_ = _loc1_.GetNext();
            }
            else
            {
               if(_loc1_.b2internal::m_flags & b2Contact.b2internal::e_filterFlag)
               {
                  if(_loc5_.b2internal::ShouldCollide(_loc4_) == false)
                  {
                     _loc9_ = _loc1_;
                     _loc1_ = _loc9_.GetNext();
                     this.Destroy(_loc9_);
                     continue;
                  }
                  if(this.b2internal::m_contactFilter.ShouldCollide(_loc2_,_loc3_) == false)
                  {
                     _loc9_ = _loc1_;
                     _loc1_ = _loc9_.GetNext();
                     this.Destroy(_loc9_);
                     continue;
                  }
                  _loc1_.b2internal::m_flags &= ~b2Contact.b2internal::e_filterFlag;
               }
               _loc6_ = _loc2_.b2internal::m_proxy;
               _loc7_ = _loc3_.b2internal::m_proxy;
               _loc8_ = this.b2internal::m_broadPhase.TestOverlap(_loc6_,_loc7_);
               if(_loc8_ == false)
               {
                  _loc9_ = _loc1_;
                  _loc1_ = _loc9_.GetNext();
                  this.Destroy(_loc9_);
               }
               else
               {
                  _loc1_.b2internal::Update(this.b2internal::m_contactListener);
                  _loc1_ = _loc1_.GetNext();
               }
            }
         }
      }
   }
}

