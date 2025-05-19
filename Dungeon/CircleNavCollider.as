package Dungeon
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import flash.geom.Vector3D;
   
   public class CircleNavCollider extends NavCollider
   {
      
      protected var mRadius:Number;
      
      protected var mFilter:b2FilterData;
      
      public function CircleNavCollider(param1:DBFacade, param2:FloorObject, param3:Vector3D, param4:Number, param5:b2World, param6:b2FilterData = null)
      {
         mRadius = param4 / 50;
         mFilter = param6;
         super(param1,param2,param3,param5);
      }
      
      override protected function buildBody() : b2Body
      {
         var _loc1_:b2BodyDef = new b2BodyDef();
         var _loc3_:b2FixtureDef = new b2FixtureDef();
         var _loc2_:b2CircleShape = new b2CircleShape(mRadius);
         _loc3_.shape = _loc2_;
         if(mFilter != null)
         {
            _loc3_.filter = mFilter;
         }
         var _loc4_:b2Body = mB2World.CreateBody(_loc1_);
         _loc4_.CreateFixture(_loc3_);
         return _loc4_;
      }
      
      public function get radius() : Number
      {
         return mRadius;
      }
   }
}

