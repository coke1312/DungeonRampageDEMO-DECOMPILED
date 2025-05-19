package Combat
{
   import Actor.ActorGameObject;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Fixture;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Brain.Utils.GeometryUtil;
   import Combat.Attack.CombatCollider;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import DistributedObjects.HeroGameObjectOwner;
   import DistributedObjects.NPCGameObject;
   import Dungeon.Prop;
   import Dungeon.Tile;
   import Dungeon.TileGridIterator;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import GameMasterDictionary.GMAttack;
   import GeneratedCode.Attack;
   import GeneratedCode.CombatResult;
   import flash.geom.Vector3D;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class CombatGameObject extends FloorObject
   {
      
      protected var mCombatCollider:CombatCollider;
      
      protected var mActorOwner:ActorGameObject;
      
      protected var mCombatResults:Vector.<CombatResult>;
      
      protected var mAttackType:uint;
      
      protected var mWeapon:WeaponGameObject;
      
      protected var mTimelineFrame:uint;
      
      protected var mShowColliders:Boolean;
      
      protected var mCombatResultCallback:Function;
      
      public var mCurrentHitMap:Map;
      
      public var mLifeTime:uint;
      
      public var mHitDelayPerObject:uint;
      
      public function CombatGameObject(param1:DBFacade, param2:ActorGameObject, param3:uint, param4:WeaponGameObject, param5:DistributedDungeonFloor, param6:CombatCollider, param7:uint = 1, param8:uint = 0, param9:Function = null, param10:uint = 0)
      {
         super(param1,param10);
         mActorOwner = param2;
         mCombatResults = new Vector.<CombatResult>();
         mDistributedDungeonFloor = param5;
         mAttackType = param3;
         mWeapon = param4;
         mCombatCollider = param6;
         mShowColliders = mDBFacade.showCollisions || mDBFacade.dbConfigManager.getConfigBoolean("show_colliders",false);
         this.layer = 20;
         mCurrentHitMap = new Map();
         mLifeTime = param7;
         mHitDelayPerObject = param8;
         mCombatResultCallback = param9;
      }
      
      public static function blockCheck(param1:Vector3D, param2:Number, param3:Vector3D, param4:Vector3D) : Boolean
      {
         return false;
      }
      
      public static function didAttackGoThroughWall(param1:DBFacade, param2:b2Vec2, param3:ActorGameObject, param4:b2Vec2, param5:DistributedDungeonFloor, param6:Boolean = false) : Boolean
      {
         var dbFacade:DBFacade = param1;
         var attackerPos:b2Vec2 = param2;
         var targetActor:ActorGameObject = param3;
         var attackeePos:b2Vec2 = param4;
         var dungeonFloor:DistributedDungeonFloor = param5;
         var showColliders:Boolean = param6;
         var attackThroughWall:Boolean = false;
         var distanceOfRayIntersection:Number = 999;
         var wallCheck:Function = function(param1:b2Fixture, param2:b2Vec2, param3:b2Vec2, param4:Number):Number
         {
            var _loc6_:uint = param1.GetBody().GetUserData() as uint;
            var _loc5_:GameObject = dbFacade.gameObjectManager.getReferenceFromId(_loc6_);
            if(_loc5_ == null || _loc5_ is Prop)
            {
               if(param4 < distanceOfRayIntersection)
               {
                  attackThroughWall = true;
                  distanceOfRayIntersection = param4;
               }
            }
            else if(_loc5_.id == targetActor.id)
            {
               if(param4 < distanceOfRayIntersection)
               {
                  attackThroughWall = false;
                  distanceOfRayIntersection = param4;
               }
            }
            return 1;
         };
         if(showColliders)
         {
            dungeonFloor.debugVisualizer.reportRayCast(attackerPos,attackeePos);
         }
         dungeonFloor.box2DWorld.RayCast(wallCheck,attackerPos,attackeePos);
         return attackThroughWall;
      }
      
      public static function determineIfHitBasedOnTeam(param1:uint, param2:uint, param3:String) : Boolean
      {
         switch(param3)
         {
            case "FRIENDLY":
               return param1 == param2;
            case "HOSTILE":
               return param1 != param2;
            default:
               Logger.warn("No case for attackTeamType: " + param3);
               return false;
         }
      }
      
      public function get combatResult() : Vector.<CombatResult>
      {
         return mCombatResults;
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
         mFloorView.position = param1;
         mCombatCollider.position = param1;
      }
      
      public function doCollisions(param1:uint = 0) : void
      {
         checkCollisions(collisionCallback,param1);
      }
      
      protected function checkCollisions(param1:Function, param2:uint = 0) : void
      {
         mTimelineFrame = param2;
         mDistributedDungeonFloor.box2DWorld.QueryShape(param1,mCombatCollider.shape,mCombatCollider.transform);
      }
      
      protected function collisionCallback(param1:b2Fixture) : Boolean
      {
         var _loc5_:HeroGameObjectOwner = null;
         var _loc2_:uint = param1.GetBody().GetUserData() as uint;
         var _loc3_:ActorGameObject = mDBFacade.gameObjectManager.getReferenceFromId(_loc2_) as ActorGameObject;
         if(!_loc3_)
         {
            return true;
         }
         if(!_loc3_.isAttackable)
         {
            return true;
         }
         var _loc4_:GMAttack = mDBFacade.gameMaster.attackById.itemFor(mAttackType);
         if(_loc4_ == null)
         {
            Logger.error("No GMAttack found for attack type: " + mAttackType);
            return true;
         }
         if(!determineIfHitBasedOnTeam(mActorOwner.team,_loc3_.team,_loc4_.Team))
         {
            return true;
         }
         if(_loc4_.LineOfSightReq && didAttackGoThroughWall(mDBFacade,mActorOwner.worldCenterAsb2Vec2,_loc3_,param1.GetBody().GetPosition(),mDistributedDungeonFloor,mShowColliders))
         {
            return true;
         }
         if(_loc4_.AffectsOthers && mActorOwner.id != _loc3_.id || _loc4_.AffectsSelf && mActorOwner.id == _loc3_.id)
         {
            if(!_loc4_.AffectsProps && _loc3_.isProp)
            {
               return true;
            }
            if(passesRecurringHitCheck(_loc2_))
            {
               hitActor(_loc3_);
               registerHitActor(_loc2_);
               if(_loc4_.AttackOnHit != null)
               {
                  if(mActorOwner.isOwner)
                  {
                     _loc5_ = mActorOwner as HeroGameObjectOwner;
                     _loc5_.doAttackOnHit(_loc4_.AttackOnHit,this.mWeapon);
                  }
               }
            }
            return true;
         }
         return true;
      }
      
      private function registerHitActor(param1:uint) : void
      {
         if(!mCurrentHitMap.hasKey(param1))
         {
            mCurrentHitMap.add(param1,mHitDelayPerObject);
         }
         else
         {
            mCurrentHitMap.replaceFor(param1,mHitDelayPerObject);
         }
      }
      
      private function passesRecurringHitCheck(param1:uint) : Boolean
      {
         if(mCurrentHitMap.hasKey(param1) && mCurrentHitMap.itemFor(param1) > 0)
         {
            return false;
         }
         return true;
      }
      
      private function hitActor(param1:ActorGameObject) : void
      {
         var _loc6_:GMAttack = mDBFacade.gameMaster.attackById.itemFor(mAttackType);
         if(_loc6_ == null)
         {
            Logger.error("No GMAttack found for attack type: " + mAttackType);
            return;
         }
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:int = 0;
         if(mWeapon != null)
         {
            _loc4_ = mWeapon.power;
            _loc5_ = mWeapon.type;
            _loc2_ = mWeapon.slot;
         }
         var _loc7_:CombatResult = new CombatResult();
         _loc7_.attacker = mActorOwner.id;
         _loc7_.attackee = param1.id;
         _loc7_.when = mTimelineFrame;
         _loc7_.generation = 0;
         var _loc3_:Attack = new Attack();
         _loc3_.attackType = mAttackType;
         _loc3_.weaponSlot = _loc2_;
         _loc3_.isConsumableWeapon = mWeapon && mWeapon.isConsumable() ? 1 : 0;
         if(param1.isBlocking && !_loc6_.Unblockable)
         {
            if(blockCheck(param1.getHeadingAsVector(),param1.maximumDotForBlocking,param1.worldCenter,mActorOwner.worldCenter))
            {
               _loc7_.blocked = 1;
            }
         }
         else
         {
            _loc7_.blocked = 0;
         }
         if(_loc7_.blocked == 0)
         {
            if(param1.hasAbility(1))
            {
               _loc7_.suffer = 0;
            }
            else
            {
               _loc7_.suffer = Math.random() <= _loc6_.StunChance ? 1 : 0;
            }
            if(_loc7_.suffer == 1)
            {
               if(_loc6_.Knockback != 0)
               {
                  _loc7_.knockback = 1;
               }
            }
         }
         _loc7_.attack = _loc3_;
         if(mCombatResultCallback != null)
         {
            mCombatResultCallback(_loc7_);
         }
      }
      
      private function getNPCs() : Vector.<NPCGameObject>
      {
         var _loc4_:Tile = null;
         var _loc5_:IIterator = null;
         var _loc1_:NPCGameObject = null;
         var _loc3_:Vector.<NPCGameObject> = new Vector.<NPCGameObject>();
         var _loc2_:TileGridIterator = mDistributedDungeonFloor.tileGrid.iterator(true);
         while(_loc2_.hasNext())
         {
            _loc4_ = _loc2_.next();
            _loc5_ = _loc4_.NPCGameObjects.iterator();
            while(_loc5_.hasNext())
            {
               _loc1_ = _loc5_.next();
               _loc3_.push(_loc1_);
            }
         }
         return _loc3_;
      }
      
      override public function destroy() : void
      {
         mActorOwner = null;
         if(mCombatCollider)
         {
            mCombatCollider.destroy();
            mCombatCollider = null;
         }
         mCombatResults = null;
         super.destroy();
      }
      
      private function updateRecurringHits() : void
      {
         var _loc1_:IMapIterator = mCurrentHitMap.iterator() as IMapIterator;
         while(_loc1_.next())
         {
            mCurrentHitMap.replaceFor(_loc1_.key,mCurrentHitMap.itemFor(_loc1_.key) - 1);
         }
      }
      
      public function perFrameUpCall(param1:uint) : void
      {
         updateRecurringHits();
         doCollisions(param1);
         mLifeTime--;
      }
      
      public function isAlive() : Boolean
      {
         return mLifeTime > 0;
      }
   }
}

