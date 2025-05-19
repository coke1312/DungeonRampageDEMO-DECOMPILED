package Box2D.Collision
{
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2ContactID
   {
      
      public var features:Features = new Features();
      
      b2internal var _key:uint;
      
      public function b2ContactID()
      {
         super();
         this.features.b2internal::_m_id = this;
      }
      
      public function Set(param1:b2ContactID) : void
      {
         this.key = param1.b2internal::_key;
      }
      
      public function Copy() : b2ContactID
      {
         var _loc1_:b2ContactID = new b2ContactID();
         _loc1_.key = this.key;
         return _loc1_;
      }
      
      public function get key() : uint
      {
         return this.b2internal::_key;
      }
      
      public function set key(param1:uint) : void
      {
         this.b2internal::_key = param1;
         this.features.b2internal::_referenceEdge = this.b2internal::_key & 0xFF;
         this.features.b2internal::_incidentEdge = (this.b2internal::_key & 0xFF00) >> 8 & 0xFF;
         this.features.b2internal::_incidentVertex = (this.b2internal::_key & 0xFF0000) >> 16 & 0xFF;
         this.features.b2internal::_flip = (this.b2internal::_key & 0xFF000000) >> 24 & 0xFF;
      }
   }
}

