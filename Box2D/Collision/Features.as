package Box2D.Collision
{
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class Features
   {
      
      b2internal var _referenceEdge:int;
      
      b2internal var _incidentEdge:int;
      
      b2internal var _incidentVertex:int;
      
      b2internal var _flip:int;
      
      b2internal var _m_id:b2ContactID;
      
      public function Features()
      {
         super();
      }
      
      public function get referenceEdge() : int
      {
         return this.b2internal::_referenceEdge;
      }
      
      public function set referenceEdge(param1:int) : void
      {
         this.b2internal::_referenceEdge = param1;
         this.b2internal::_m_id.b2internal::_key = this.b2internal::_m_id.b2internal::_key & 0xFFFFFF00 | this.b2internal::_referenceEdge & 0xFF;
      }
      
      public function get incidentEdge() : int
      {
         return this.b2internal::_incidentEdge;
      }
      
      public function set incidentEdge(param1:int) : void
      {
         this.b2internal::_incidentEdge = param1;
         this.b2internal::_m_id.b2internal::_key = this.b2internal::_m_id.b2internal::_key & 0xFFFF00FF | this.b2internal::_incidentEdge << 8 & 0xFF00;
      }
      
      public function get incidentVertex() : int
      {
         return this.b2internal::_incidentVertex;
      }
      
      public function set incidentVertex(param1:int) : void
      {
         this.b2internal::_incidentVertex = param1;
         this.b2internal::_m_id.b2internal::_key = this.b2internal::_m_id.b2internal::_key & 0xFF00FFFF | this.b2internal::_incidentVertex << 16 & 0xFF0000;
      }
      
      public function get flip() : int
      {
         return this.b2internal::_flip;
      }
      
      public function set flip(param1:int) : void
      {
         this.b2internal::_flip = param1;
         this.b2internal::_m_id.b2internal::_key = this.b2internal::_m_id.b2internal::_key & 0xFFFFFF | this.b2internal::_flip << 24 & 0xFF000000;
      }
   }
}

