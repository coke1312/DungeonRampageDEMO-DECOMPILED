package Projectile
{
   import Actor.ActorGameObject;
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Fixture;
   import Combat.CombatGameObject;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import DistributedObjects.NPCGameObject;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   import org.as3commons.collections.Set;
   
   public class ChainProjectileGameObject extends ProjectileGameObject
   {
      
      private static const DEFAULT_CHAIN_CHECK_DISTANCE:Number = 300;
      
      private static const DEFAULT_NUM_BRANCHES:uint = 1;
      
      private var mMaxBranches:uint = 3;
      
      private var mNumBranches:uint = 0;
      
      private var mMaxChain:uint = 2;
      
      private var mNumChains:uint = 0;
      
      private var mEnvironmentTargets:Vector.<NPCGameObject>;
      
      private var mEnemyTargets:Vector.<NPCGameObject>;
      
      private var mIgnoreList:Set;
      
      private var mChainCheckDistance:Number = 0;
      
      private var mActorJustHit:ActorGameObject;
      
      public function ChainProjectileGameObject(param1:DBFacade, param2:uint, param3:uint, param4:uint, param5:WeaponGameObject, param6:DistributedDungeonFloor, param7:Vector3D, param8:Vector3D, param9:Vector3D, param10:Number = 0, param11:uint = 0, param12:Set = null, param13:Object = null, param14:Function = null, param15:Boolean = true, param16:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param13,param14,param15,param16,param11);
         mNumChains = param11;
         if(param12 == null)
         {
            mIgnoreList = new Set();
         }
         else
         {
            mIgnoreList = param12;
         }
         var _loc17_:uint = param5 != null ? param5.chains() : 0;
         mMaxChain = mGMProjectile.NumChains + _loc17_;
         mMaxBranches = mGMProjectile.NumBranches > 0 ? mGMProjectile.NumBranches : 1;
         mChainCheckDistance = mGMProjectile.ChainDist > 0 ? mGMProjectile.ChainDist : 300;
      }
      
      override protected function hitActor(param1:ActorGameObject) : Boolean
      {
         var _loc2_:b2Transform = null;
         mActorJustHit = param1;
         if(mIgnoreList.has(param1.id))
         {
            return false;
         }
         if(super.hitActor(param1))
         {
            if(mNumChains < mMaxChain)
            {
               mIgnoreList.add(param1.id);
               _loc2_ = new b2Transform();
               _loc2_.position = NavCollider.convertToB2Vec2(this.position);
               mEnvironmentTargets = new Vector.<NPCGameObject>();
               mEnemyTargets = new Vector.<NPCGameObject>();
               this.mDistributedDungeonFloor.box2DWorld.QueryShape(collisionCallback,new b2CircleShape(mChainCheckDistance / 50),_loc2_);
               processTargets();
            }
         }
         if(mCollisionComponent.markedForDeletion())
         {
            this.destroy();
         }
         return true;
      }
      
      private function collisionCallback(param1:b2Fixture) : Boolean
      {
         var _loc3_:ActorGameObject = mDistributedDungeonFloor.getActor(mParentActorId);
         if(_loc3_ == null)
         {
            return false;
         }
         var _loc2_:uint = param1.GetBody().GetUserData() as uint;
         var _loc4_:NPCGameObject = mDBFacade.gameObjectManager.getReferenceFromId(_loc2_) as NPCGameObject;
         if(_loc4_ && mActorJustHit.id != _loc4_.id && _loc4_.isAttackable && (!mIgnoreList.has(_loc4_.id) || mGMProjectile.CyclicChains))
         {
            if(mFlightComponent.isTargetableTeam(_loc4_.team))
            {
               if(!CombatGameObject.didAttackGoThroughWall(mDBFacade,mB2Body.GetPosition(),_loc4_,NavCollider.convertToB2Vec2(_loc4_.worldCenter),mDistributedDungeonFloor))
               {
                  if(_loc4_.team == 1)
                  {
                     mEnvironmentTargets.push(_loc4_);
                  }
                  else
                  {
                     mEnemyTargets.push(_loc4_);
                  }
               }
            }
         }
         if(mNumBranches >= mMaxBranches)
         {
            return false;
         }
         return true;
      }
      
      private function processTargets() : void
      {
         mEnemyTargets.sort(sortByDistance);
         processNewChains(mEnemyTargets);
         mEnvironmentTargets.sort(sortByDistance);
         processNewChains(mEnvironmentTargets);
      }
      
      private function sortByDistance(param1:NPCGameObject, param2:NPCGameObject) : Number
      {
         var _loc3_:b2Vec2 = new b2Vec2();
         _loc3_.x = mActorJustHit.worldCenterAsb2Vec2.x;
         _loc3_.y = mActorJustHit.worldCenterAsb2Vec2.y;
         _loc3_.Subtract(param1.worldCenterAsb2Vec2);
         var _loc4_:b2Vec2 = new b2Vec2();
         _loc4_.x = mActorJustHit.worldCenterAsb2Vec2.x;
         _loc4_.y = mActorJustHit.worldCenterAsb2Vec2.y;
         _loc4_.Subtract(param2.worldCenterAsb2Vec2);
         return _loc3_.LengthSquared() - _loc4_.LengthSquared();
      }
      
      private function processNewChains(param1:Vector.<NPCGameObject>) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(mNumBranches >= mMaxBranches)
            {
               return;
            }
            shootNewChain(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function shootNewChain(param1:NPCGameObject) : void
      {
         mNumBranches++;
         var _loc2_:Vector3D = param1.view.position.subtract(this.position);
         _loc2_.normalize();
         new ChainProjectileGameObject(mDBFacade,mParentActorId,mParentActorTeam,mAttackType,mWeaponGameObject,this.mDistributedDungeonFloor,mActorJustHit.position,_loc2_,new Vector3D(0,0),mRange,mNumChains + 1,mIgnoreList,mEffectObject,mCombatResultCallback,false);
      }
   }
}

