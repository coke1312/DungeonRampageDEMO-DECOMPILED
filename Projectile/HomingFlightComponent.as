package Projectile
{
   import Actor.ActorGameObject;
   import Box2D.Collision.b2AABB;
   import Box2D.Dynamics.b2Fixture;
   import DistributedObjects.DistributedDungeonFloor;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class HomingFlightComponent extends FlightComponent
   {
      
      private var mCurrentTargetId:uint;
      
      private var mBestScore:Number;
      
      private var mLastHitActor:ActorGameObject;
      
      public function HomingFlightComponent(param1:Vector3D, param2:Vector3D, param3:ProjectileGameObject, param4:uint, param5:DBFacade, param6:DistributedDungeonFloor, param7:Boolean, param8:Function = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
         findTarget();
      }
      
      private function findTarget() : void
      {
         mBestScore = -99999;
         var _loc2_:Vector3D = new Vector3D(mDBFacade.camera.visibleRectangle.left,mDBFacade.camera.visibleRectangle.top);
         var _loc1_:Vector3D = new Vector3D(mDBFacade.camera.visibleRectangle.right,mDBFacade.camera.visibleRectangle.bottom);
         var _loc3_:b2AABB = new b2AABB();
         _loc3_.lowerBound = NavCollider.convertToB2Vec2(_loc2_);
         _loc3_.upperBound = NavCollider.convertToB2Vec2(_loc1_);
         mProjectile.distributedDungeonFloor.box2DWorld.QueryAABB(targetSelectCallback,_loc3_);
      }
      
      override public function informOfHit(param1:ActorGameObject) : void
      {
         mLastHitActor = param1;
         findTarget();
      }
      
      public function targetSelectCallback(param1:b2Fixture) : Boolean
      {
         var _loc2_:ActorGameObject = mDungeonFloor.getActor(mParentActorId);
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:uint = param1.GetBody().GetUserData() as uint;
         var _loc4_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(_loc3_) as ActorGameObject;
         if(_loc4_ != null && (_loc4_.isProp && !mProjectile.gmAttack.AffectsProps))
         {
            return false;
         }
         if(_loc4_ == null || !_loc4_.isAttackable || _loc4_ == mLastHitActor)
         {
            return true;
         }
         if(isTargetableTeam(_loc4_.team) && isBetterTargetThanCurrent(_loc4_))
         {
            mCurrentTargetId = _loc4_.id;
            mBestScore = calculateTargetScore(_loc4_,_loc2_);
         }
         return true;
      }
      
      private function isBetterTargetThanCurrent(param1:ActorGameObject) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:ActorGameObject = mDungeonFloor.getActor(mParentActorId);
         var _loc2_:ActorGameObject = mDungeonFloor.getActor(mCurrentTargetId);
         if(_loc2_ == null || _loc2_.hitPoints == 0)
         {
            return true;
         }
         if(param1.hitPoints == 0)
         {
            return false;
         }
         if(_loc2_.team == 1 && param1.team != 1)
         {
            return true;
         }
         if(_loc2_.team != 1 && param1.team != 1 || _loc2_.team == 1 && param1.team == 1)
         {
            _loc3_ = calculateTargetScore(param1,_loc4_);
            if(_loc3_ > mBestScore)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      private function calculateTargetScore(param1:ActorGameObject, param2:ActorGameObject) : Number
      {
         if(param2 == null)
         {
            return 0;
         }
         var _loc5_:Number = 20 / Vector3D.distance(param1.worldCenter,param2.worldCenter);
         var _loc6_:Vector3D = param1.worldCenter.subtract(param2.worldCenter);
         _loc6_.normalize();
         var _loc3_:Number = _loc6_.dotProduct(param2.getHeadingAsVector());
         return _loc5_ * mProjectile.gmProjectile.HomingDistWeight + _loc3_ * mProjectile.gmProjectile.HomingAngleWeight;
      }
      
      override public function update() : void
      {
         var _loc1_:ActorGameObject = mDungeonFloor.getActor(mCurrentTargetId);
         if(_loc1_ == null || _loc1_.hitPoints == 0)
         {
            findTarget();
            return;
         }
         var _loc5_:Vector3D = _loc1_.worldCenter;
         var _loc2_:Vector3D = _loc5_.subtract(mProjectile.position);
         var _loc3_:Number = _loc2_.normalize();
         var _loc4_:Number = 1 - 20 / _loc3_;
         _loc4_ = 1 - _loc4_ * _loc4_;
         mSteeringVector = getSteeringVector(_loc5_,Math.min(1,_loc4_ * mProjectile.gmProjectile.SteeringRate));
         mApplySteeringVector(mSteeringVector);
         if(mProjectile.gmProjectile.RotationSpeedF == 0)
         {
            mProjectile.rotation = Math.atan2(mProjectile.velocity.y,mProjectile.velocity.x) * 180 / 3.141592653589793;
         }
      }
   }
}

