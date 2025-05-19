package Projectile
{
   import Actor.ActorGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import flash.geom.Vector3D;
   
   public class BounceBackCollisionComponent extends CollisionComponent
   {
      
      private static const DAMPING_FACTOR:Number = 0.5;
      
      public function BounceBackCollisionComponent(param1:DBFacade, param2:ProjectileGameObject, param3:uint, param4:DistributedDungeonFloor, param5:uint, param6:uint, param7:GMAttack, param8:Function, param9:int, param10:Number)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,false);
      }
      
      override public function hitWall() : void
      {
         var _loc1_:ActorGameObject = mDungeonFloor.getActor(mParentActorId);
         if(_loc1_ == null || _loc1_.isDestroyed)
         {
            mProjectile.destroy();
            return;
         }
         var _loc2_:Vector3D = _loc1_.worldCenter.subtract(mProjectile.position);
         _loc2_.normalize();
         _loc2_.scaleBy(mProjectile.velocity.length * 0.5);
         mProjectile.velocity = _loc2_;
         mUpdatedVelocity = true;
      }
   }
}

