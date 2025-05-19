package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Combat.Weapon.WeaponController;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   import GeneratedCode.Attack;
   import GeneratedCode.AttackChoreography;
   import GeneratedCode.CombatResult;
   
   public class OwnerAttackTimeline extends AttackTimeline
   {
      
      protected var mHeroGameObjectOwner:HeroGameObjectOwner;
      
      protected var mCombatResults:Vector.<CombatResult>;
      
      protected var mWeaponController:WeaponController;
      
      public function OwnerAttackTimeline(param1:WeaponGameObject, param2:HeroGameObjectOwner, param3:ActorView, param4:Object, param5:DBFacade, param6:DistributedDungeonFloor)
      {
         mHeroGameObjectOwner = param2;
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function parseAction(param1:Object) : AttackTimelineAction
      {
         var _loc3_:* = null;
         var _loc4_:String = param1.type as String;
         var _loc2_:AttackTimelineAction = null;
         switch(_loc4_)
         {
            case "attemptRevive":
               _loc2_ = AttemptReviveTimeLineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "proposeRevive":
               _loc2_ = ProposeReviveTimeLineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "lockAttack":
               _loc2_ = LockAttackTimeLineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade);
               break;
            case "circleCollider":
               _loc2_ = CircleColliderAttackTimelineAction.buildFromJson(mWeapon,mActorGameObject,mActorView,mDBFacade,mDistributedDungeonFloor,param1,combatResultCallback);
               break;
            case "rectangleCollider":
               _loc2_ = RectangleColliderTimelineAction.buildFromJson(mWeapon,mActorGameObject,mActorView,mDBFacade,mDistributedDungeonFloor,param1,combatResultCallback);
               break;
            case "zoom":
               _loc2_ = CameraZoomTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "timeScale":
               break;
            case "projectile":
               _loc2_ = ProjectileAttackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,mDistributedDungeonFloor,param1,mWeapon,combatResultCallback);
               break;
            case "inputType":
               _loc2_ = InputTypeTimelineAction.buildFromJson(mHeroGameObjectOwner,mActorView,mDBFacade,param1);
               break;
            case "startCooldown":
               for each(_loc3_ in mHeroGameObjectOwner.weaponControllers)
               {
                  if(_loc3_.weapon == mWeapon)
                  {
                     mWeaponController = _loc3_;
                     break;
                  }
               }
               _loc2_ = CoolDownAttackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,mWeaponController,param1);
               break;
            case "queueAttack":
               if(mHeroGameObjectOwner && mHeroGameObjectOwner.weaponControllers)
               {
                  for each(_loc3_ in mHeroGameObjectOwner.weaponControllers)
                  {
                     if(_loc3_.weapon == mWeapon)
                     {
                        mWeaponController = _loc3_;
                        break;
                     }
                  }
                  _loc2_ = QueueAttackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,mWeaponController,param1);
               }
               break;
            default:
               return super.parseAction(param1);
         }
         return _loc2_;
      }
      
      override public function play(param1:Number, param2:ActorGameObject, param3:Function = null, param4:Function = null, param5:Boolean = false) : void
      {
         mCombatResults = new Vector.<CombatResult>();
         super.play(param1,param2,param3,param4,param5);
         if(!mChoreographed)
         {
            buildAndSendAttackObject();
         }
      }
      
      override public function stop() : void
      {
         if(mChoreographed)
         {
            buildAndSendAttackObject();
         }
         super.stop();
      }
      
      protected function buildAndSendAttackObject() : void
      {
         var _loc4_:Number = 0;
         var _loc5_:Boolean = false;
         if(mWeapon != null)
         {
            _loc4_ = this.mWeapon.slot;
            _loc5_ = this.mWeapon.isConsumable();
         }
         var _loc2_:Attack = new Attack();
         _loc2_.attackType = mCurrentAttackType;
         _loc2_.weaponSlot = _loc4_;
         _loc2_.isConsumableWeapon = _loc5_ ? 1 : 0;
         _loc2_.targetActorDoid = mTargetActor != null ? mTargetActor.id : 0;
         var _loc3_:AttackChoreography = new AttackChoreography();
         _loc3_.attack = _loc2_;
         var _loc1_:uint = mLoop ? 1 : 0;
         _loc3_.loop = _loc1_;
         _loc3_.combatResults = mCombatResults;
         _loc3_.playSpeed = this.playSpeed;
         _loc3_.scalingMaxProjectiles = projectileMultiplier;
         mHeroGameObjectOwner.sendChoreography(_loc3_);
      }
      
      protected function combatResultCallback(param1:CombatResult) : void
      {
         var _loc3_:* = undefined;
         param1.scalingMaxPowerMultiplier = mPowerMultiplier;
         if(!mChoreographed)
         {
            _loc3_ = new Vector.<CombatResult>();
            _loc3_.push(param1);
            mHeroGameObjectOwner.proposeCombatResults(_loc3_);
         }
         else
         {
            mCombatResults.push(param1);
         }
         var _loc2_:ActorGameObject = mDistributedDungeonFloor.getActor(param1.attackee);
         if(_loc2_)
         {
            _loc2_.localCombatHit(param1);
         }
      }
      
      override public function destroy() : void
      {
         mCombatResults = null;
         super.destroy();
      }
   }
}

