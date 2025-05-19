package Collision
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2FixtureDef;
   import DistributedObjects.Floor;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class LocalHeroProximitySensor implements IContactResolver
   {
      
      private var mDBFacade:DBFacade;
      
      private var mFloor:Floor;
      
      private var mBody:b2Body;
      
      private var mCollisionCallback:Function;
      
      private var mTriggerOnce:Boolean;
      
      private var mHasCollidedFirstTime:Boolean;
      
      public function LocalHeroProximitySensor(param1:DBFacade, param2:Floor, param3:uint, param4:uint, param5:uint, param6:Boolean, param7:Function)
      {
         super();
         mFloor = param2;
         mDBFacade = param1;
         mTriggerOnce = param6;
         mCollisionCallback = param7;
         mHasCollidedFirstTime = false;
         var _loc8_:b2FilterData = new b2FilterData();
         _loc8_.categoryBits = 2;
         var _loc9_:b2CircleShape = new b2CircleShape(param5 / 50);
         var _loc11_:b2FixtureDef = new b2FixtureDef();
         _loc11_.isSensor = true;
         _loc11_.shape = _loc9_;
         _loc11_.userData = this;
         _loc11_.filter = _loc8_;
         var _loc10_:b2BodyDef = new b2BodyDef();
         _loc10_.allowSleep = false;
         mBody = param2.box2DWorld.CreateBody(_loc10_);
         mBody.CreateFixture(_loc11_);
         mBody.SetPosition(NavCollider.convertToB2Vec2(new Vector3D(param3,param4)));
      }
      
      public function enterContact(param1:uint) : void
      {
         if(mTriggerOnce)
         {
            if(!mHasCollidedFirstTime)
            {
               mCollisionCallback();
            }
         }
         else
         {
            mCollisionCallback();
         }
         mHasCollidedFirstTime = true;
      }
      
      public function exitContact(param1:uint) : void
      {
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

