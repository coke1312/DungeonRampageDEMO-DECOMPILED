package Dungeon
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import flash.geom.Vector3D;
   
   public class RectangleNavCollider extends NavCollider
   {
      
      protected var mHalfWidth:Number;
      
      protected var mHalfHeight:Number;
      
      protected var mFilter:b2FilterData;
      
      public function RectangleNavCollider(param1:DBFacade, param2:FloorObject, param3:Vector3D, param4:Number, param5:b2World, param6:Number, param7:Number, param8:b2FilterData = null)
      {
         mHalfWidth = param6 / 50;
         mHalfHeight = param7 / 50;
         mFilter = param8;
         super(param1,param2,param3,param5);
         this.angle = param4;
      }
      
      public function set angle(param1:Number) : void
      {
         mB2Body.SetAngle(param1);
      }
      
      public function get angle() : Number
      {
         return mB2Body.GetAngle();
      }
      
      override protected function buildBody() : b2Body
      {
         var _loc1_:b2BodyDef = new b2BodyDef();
         var _loc3_:b2FixtureDef = new b2FixtureDef();
         var _loc2_:b2PolygonShape = new b2PolygonShape();
         _loc2_.SetAsBox(mHalfWidth,mHalfHeight);
         _loc3_.shape = _loc2_;
         if(mFilter != null)
         {
            _loc3_.filter = mFilter;
         }
         var _loc4_:b2Body = mB2World.CreateBody(_loc1_);
         _loc4_.CreateFixture(_loc3_);
         return _loc4_;
      }
   }
}

