package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2Collision;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   
   use namespace b2internal;
   
   public class b2PolyAndCircleContact extends b2Contact
   {
      
      public function b2PolyAndCircleContact()
      {
         super();
      }
      
      public static function Create(param1:*) : b2Contact
      {
         return new b2PolyAndCircleContact();
      }
      
      public static function Destroy(param1:b2Contact, param2:*) : void
      {
      }
      
      public function Reset(param1:b2Fixture, param2:b2Fixture) : void
      {
         super.b2internal::Reset(param1,param2);
         b2Settings.b2Assert(param1.GetType() == b2Shape.b2internal::e_polygonShape);
         b2Settings.b2Assert(param2.GetType() == b2Shape.b2internal::e_circleShape);
      }
      
      override b2internal function Evaluate() : void
      {
         var _loc1_:b2Body = b2internal::m_fixtureA.b2internal::m_body;
         var _loc2_:b2Body = b2internal::m_fixtureB.b2internal::m_body;
         b2Collision.CollidePolygonAndCircle(b2internal::m_manifold,b2internal::m_fixtureA.GetShape() as b2PolygonShape,_loc1_.b2internal::m_xf,b2internal::m_fixtureB.GetShape() as b2CircleShape,_loc2_.b2internal::m_xf);
      }
   }
}

