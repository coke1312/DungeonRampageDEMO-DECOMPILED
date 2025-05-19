package Projectile
{
   import Actor.ActorGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class FlightComponent
   {
      
      protected var mProjectile:ProjectileGameObject;
      
      protected var mParentActorId:uint;
      
      protected var mDBFacade:DBFacade;
      
      protected var mDungeonFloor:DistributedDungeonFloor;
      
      protected var mHeadingVector:Vector3D;
      
      protected var mSteeringUpdated:Boolean;
      
      protected var mSteeringVector:Vector3D;
      
      protected var mFriendly:Boolean;
      
      protected var mApplySteeringVector:Function;
      
      protected var mStartTime:uint;
      
      public function FlightComponent(param1:Vector3D, param2:Vector3D, param3:ProjectileGameObject, param4:uint, param5:DBFacade, param6:DistributedDungeonFloor, param7:Boolean, param8:Function = null)
      {
         super();
         mProjectile = param3;
         mHeadingVector = param2;
         mParentActorId = param4;
         mDBFacade = param5;
         mDungeonFloor = param6;
         mApplySteeringVector = param8;
         mFriendly = param7;
         mSteeringUpdated = false;
         mStartTime = mDBFacade.gameClock.gameTime;
      }
      
      public function update() : void
      {
         if(mProjectile.gmProjectile.Lifetime > 0 && mDBFacade.gameClock.gameTime - mStartTime > mProjectile.gmProjectile.Lifetime)
         {
            mProjectile.destroy();
            return;
         }
      }
      
      public function informOfHit(param1:ActorGameObject) : void
      {
      }
      
      public function get steeringVector() : Vector3D
      {
         return mSteeringVector;
      }
      
      public function get steeringUpdated() : Boolean
      {
         return mSteeringUpdated;
      }
      
      public function destroy() : void
      {
         mProjectile = null;
         mDBFacade = null;
         mDungeonFloor = null;
         mApplySteeringVector = null;
      }
      
      protected function getSteeringVector(param1:Vector3D, param2:Number) : Vector3D
      {
         var _loc3_:Vector3D = param1.subtract(mProjectile.position);
         var _loc5_:Number = _loc3_.normalize();
         _loc3_.scaleBy(mProjectile.gmProjectile.ProjSpeedF);
         var _loc4_:Vector3D = _loc3_.subtract(mProjectile.velocity);
         _loc4_.scaleBy(param2);
         return _loc4_;
      }
      
      public function isTargetableTeam(param1:uint) : Boolean
      {
         return mFriendly ? param1 == mProjectile.team : param1 != mProjectile.team;
      }
   }
}

