package Collision
{
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2FixtureDef;
   import Brain.Logger.Logger;
   import DBGlobals.DBGlobal;
   import DistributedObjects.Floor;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class HeroOwnerSensor implements IContactResolver
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mFloor:Floor;
      
      private var mBody:b2Body;
      
      public function HeroOwnerSensor(param1:DBFacade, param2:Floor, param3:b2Shape, param4:uint)
      {
         super();
         mFloor = param2;
         mDBFacade = param1;
         var _loc5_:b2FilterData = new b2FilterData();
         _loc5_.groupIndex = -1;
         _loc5_.maskBits = DBGlobal.b2dMaskForTeam(param4);
         var _loc7_:b2FixtureDef = new b2FixtureDef();
         _loc7_.isSensor = true;
         _loc7_.shape = param3;
         _loc7_.userData = this;
         _loc7_.filter = _loc5_;
         var _loc6_:b2BodyDef = new b2BodyDef();
         _loc6_.allowSleep = false;
         mBody = param2.box2DWorld.CreateBody(_loc6_);
         mBody.CreateFixture(_loc7_);
      }
      
      public function set position(param1:Vector3D) : void
      {
         mBody.SetPosition(NavCollider.convertToB2Vec2(param1));
      }
      
      public function enterContact(param1:uint) : void
      {
         Logger.warn("enterContact was called on base class HeroOwnerSensor.  Sub classes should override this call.");
      }
      
      public function exitContact(param1:uint) : void
      {
         Logger.warn("exitContact was called on base class HeroOwnerSensor.  Sub classes should override this call.");
      }
      
      public function destroy() : void
      {
         mFloor.box2DWorld.DestroyBody(mBody);
         mBody = null;
         mFloor = null;
         mDBFacade = null;
      }
   }
}

