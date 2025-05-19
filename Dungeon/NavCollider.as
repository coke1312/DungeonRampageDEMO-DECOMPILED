package Dungeon
{
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2World;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import flash.geom.Vector3D;
   
   public class NavCollider
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mParentObject:FloorObject;
      
      protected var mWorldSpaceOffset:Vector3D;
      
      protected var mB2Body:b2Body;
      
      protected var mB2World:b2World;
      
      public function NavCollider(param1:DBFacade, param2:FloorObject, param3:Vector3D, param4:b2World)
      {
         super();
         mDBFacade = param1;
         mParentObject = param2;
         mWorldSpaceOffset = param3;
         mB2World = param4;
         mB2Body = buildBody();
         if(param2 == null)
         {
            mB2Body.SetUserData(null);
         }
         else
         {
            mB2Body.SetUserData(param2.id);
         }
      }
      
      public static function buildNavColliderFromJson(param1:DBFacade, param2:Object, param3:FloorObject, param4:Vector3D, param5:Number, param6:Vector3D, param7:b2World, param8:b2FilterData = null) : NavCollider
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:String = param2.type;
         if(_loc11_ == "circle")
         {
            return new CircleNavCollider(param1,param3,param4,param2.radius * param6.x,param7,param8);
         }
         if(_loc11_ == "rectangle")
         {
            _loc9_ = param2.halfWidth * param6.x;
            _loc10_ = param2.halfHeight * param6.y;
            return new RectangleNavCollider(param1,param3,param4,param5,param7,_loc9_,_loc10_,param8);
         }
         Logger.error("Could not figure out collision type of json to build a b2Shape:" + param2.toString());
         return null;
      }
      
      public static function convertToB2Vec2(param1:Vector3D) : b2Vec2
      {
         return new b2Vec2(param1.x / 50,param1.y / 50);
      }
      
      public static function convertToVector3D(param1:b2Vec2) : Vector3D
      {
         return new Vector3D(param1.x * 50,param1.y * 50);
      }
      
      public function destroy() : void
      {
         mB2World.DestroyBody(mB2Body);
         mB2Body = null;
         mB2World = null;
         mParentObject = null;
         mDBFacade = null;
      }
      
      public function set active(param1:Boolean) : void
      {
         mB2Body.SetActive(param1);
      }
      
      public function get active() : Boolean
      {
         return mB2Body.IsActive();
      }
      
      protected function buildBody() : b2Body
      {
         Logger.error("Override build definition in sub classes.");
         return null;
      }
      
      public function get worldCenter() : Vector3D
      {
         return convertToVector3D(mB2Body.GetWorldCenter());
      }
      
      public function set position(param1:Vector3D) : void
      {
         var _loc2_:Vector3D = new Vector3D(param1.x + mWorldSpaceOffset.x,param1.y + mWorldSpaceOffset.y);
         mB2Body.SetPosition(convertToB2Vec2(_loc2_));
      }
      
      public function get position() : Vector3D
      {
         var _loc1_:Vector3D = convertToVector3D(mB2Body.GetPosition());
         return _loc1_.subtract(mWorldSpaceOffset);
      }
      
      public function set velocity(param1:Vector3D) : void
      {
         mB2Body.SetAwake(true);
         mB2Body.SetLinearVelocity(convertToB2Vec2(param1));
      }
      
      public function get offset() : Vector3D
      {
         return mWorldSpaceOffset;
      }
      
      public function set type(param1:uint) : void
      {
         mB2Body.SetType(b2Body.b2_dynamicBody);
      }
      
      public function get collisionRadius() : Number
      {
         if(this as CircleNavCollider)
         {
            return (this as CircleNavCollider).radius;
         }
         return -1;
      }
      
      public function getBody() : b2Body
      {
         return mB2Body;
      }
      
      public function getShape() : b2Shape
      {
         var _loc1_:b2Fixture = mB2Body.GetFixtureList();
         return _loc1_.GetShape();
      }
   }
}

