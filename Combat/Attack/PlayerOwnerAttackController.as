package Combat.Attack
{
   import Actor.Buffs.BuffHandler;
   import Actor.Player.HeroView;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Combat.Weapon.ChargeWeaponController;
   import Combat.Weapon.ConsumableWeaponController;
   import Combat.Weapon.ConsumableWeaponGameObject;
   import Combat.Weapon.RepeaterWeaponController;
   import Combat.Weapon.ScalingWeaponController;
   import Combat.Weapon.ShieldWeaponController;
   import Combat.Weapon.WeaponController;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.HeroGameObjectOwner;
   import Events.GameObjectEvent;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import GameMasterDictionary.GMStackable;
   
   public class PlayerOwnerAttackController
   {
      
      public static const DUNGEON_BUSTER_WEAPON_INDEX:uint = 3;
      
      private var CHARGE_UP:String = "CHARGE_UP";
      
      private var SCALING:String = "SCALING";
      
      private var REPEATER:String = "REPEATER";
      
      private var SHIELD:String = "BLOCKING";
      
      protected var mDistributedPlayerOwner:HeroGameObjectOwner;
      
      protected var mDBFacade:DBFacade;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mEventComponent:EventComponent;
      
      protected var mPotentialWeaponInputQueue:Array;
      
      protected var mQueueNextAttackWindow:Number;
      
      protected var mNextWeaponCommand:PotentialWeaponInputQueueStruct;
      
      private var mDungeonBusterGMAttack:GMAttack;
      
      private var mDungeonBusterAttackTimeline:AttackTimeline;
      
      protected var mIsDungeonBusterUsed:Boolean;
      
      private var mWeaponControllers:Vector.<WeaponController>;
      
      private var mConsumableControllers:Vector.<ConsumableWeaponController>;
      
      public function PlayerOwnerAttackController(param1:HeroGameObjectOwner, param2:HeroView, param3:DBFacade)
      {
         super();
         mDistributedPlayerOwner = param1;
         mDBFacade = param3;
         mPotentialWeaponInputQueue = [];
         mLogicalWorkComponent = new LogicalWorkComponent(param3);
         mEventComponent = new EventComponent(mDBFacade);
         mEventComponent.addListener(GameObjectEvent.uniqueEvent(BuffHandler.BERSERK_MODE_START,mDistributedPlayerOwner.id),berserkModeStart);
         mEventComponent.addListener(GameObjectEvent.uniqueEvent(BuffHandler.BERSERK_MODE_DONE,mDistributedPlayerOwner.id),berserkModeEnd);
         mIsDungeonBusterUsed = false;
         buildWeaponControllers();
         buildConsumableControllers();
         buildDungeonBuster();
         mQueueNextAttackWindow = mDBFacade.dbConfigManager.getConfigNumber("QUEUE_NEXT_ATTACK_WINDOW",0.4);
      }
      
      private function buildWeaponControllers() : void
      {
         var _loc3_:WeaponController = null;
         mWeaponControllers = new Vector.<WeaponController>();
         var _loc2_:uint = 0;
         for each(var _loc1_ in mDistributedPlayerOwner.weapons)
         {
            if(_loc1_)
            {
               _loc3_ = determineWeaponController(_loc1_);
            }
            else
            {
               _loc3_ = null;
            }
            mWeaponControllers.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function buildConsumableControllers() : void
      {
         var _loc1_:ConsumableWeaponController = null;
         mConsumableControllers = new Vector.<ConsumableWeaponController>();
         var _loc2_:uint = 0;
         for each(var _loc3_ in mDistributedPlayerOwner.consumables)
         {
            if(_loc3_)
            {
               _loc1_ = new ConsumableWeaponController(mDBFacade,_loc3_,mDistributedPlayerOwner);
            }
            else
            {
               _loc1_ = null;
            }
            mConsumableControllers.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function determineWeaponController(param1:WeaponGameObject) : WeaponController
      {
         var _loc2_:WeaponController = null;
         switch(param1.weaponData.WeaponController)
         {
            case CHARGE_UP:
               _loc2_ = new ChargeWeaponController(mDBFacade,param1,mDistributedPlayerOwner);
               break;
            case SCALING:
               _loc2_ = new ScalingWeaponController(mDBFacade,param1,mDistributedPlayerOwner);
               break;
            case REPEATER:
               _loc2_ = new RepeaterWeaponController(mDBFacade,param1,mDistributedPlayerOwner);
               break;
            case SHIELD:
               _loc2_ = new ShieldWeaponController(mDBFacade,param1,mDistributedPlayerOwner);
               break;
            default:
               Logger.warn("Unable to determine weapon controller for GMWeaponItem.WeaponController: " + param1.weaponData.WeaponController + ".  Using ChargeWeaponController as default.");
               _loc2_ = new ChargeWeaponController(mDBFacade,param1,mDistributedPlayerOwner);
         }
         return _loc2_;
      }
      
      private function buildDungeonBuster() : void
      {
         var _loc1_:String = mDistributedPlayerOwner.gMHero.DBuster1;
         mDungeonBusterGMAttack = mDBFacade.gameMaster.attackByConstant.itemFor(_loc1_);
         mDungeonBusterAttackTimeline = mDBFacade.timelineFactory.createAttackTimeline(mDungeonBusterGMAttack.AttackTimeline,null,mDistributedPlayerOwner,mDistributedPlayerOwner.distributedDungeonFloor);
         mDistributedPlayerOwner.maxBusterPoints = mDungeonBusterGMAttack.CrowdCost;
      }
      
      public function get weaponControllers() : Vector.<WeaponController>
      {
         return mWeaponControllers;
      }
      
      public function scrollWeapons(param1:Boolean) : void
      {
         if(currentWeaponController.currentTimeline == null)
         {
            if(param1)
            {
               equipNextWeapon();
            }
            else
            {
               equipPreviousWeapon();
            }
         }
      }
      
      private function equipNextWeapon() : void
      {
         var _loc2_:int = this.mDistributedPlayerOwner.currentWeaponIndex;
         var _loc1_:int = _loc2_ + 1;
         while(_loc2_ != _loc1_)
         {
            if(_loc1_ >= mWeaponControllers.length)
            {
               _loc1_ = 0;
            }
            if(mWeaponControllers[_loc1_] != null)
            {
               mDistributedPlayerOwner.currentWeaponIndex = _loc1_;
               return;
            }
            _loc1_++;
         }
      }
      
      private function equipPreviousWeapon() : void
      {
         var _loc2_:int = this.mDistributedPlayerOwner.currentWeaponIndex;
         var _loc1_:int = _loc2_ - 1;
         while(_loc2_ != _loc1_)
         {
            if(_loc1_ < 0)
            {
               _loc1_ = mWeaponControllers.length - 1;
            }
            if(mWeaponControllers[_loc1_] != null)
            {
               mDistributedPlayerOwner.currentWeaponIndex = _loc1_;
               return;
            }
            _loc1_--;
         }
      }
      
      public function playDungeonBusterAttack() : void
      {
         if(mDistributedPlayerOwner.stateMachine.currentStateName == "ActorDefaultState" && mDistributedPlayerOwner.canInitiateAnAttack)
         {
            if(mDungeonBusterAttackTimeline == null)
            {
               buildDungeonBuster();
            }
            mNextWeaponCommand = null;
            mDistributedPlayerOwner.attack(mDungeonBusterGMAttack.Id,null,mDungeonBusterGMAttack.AttackSpdF,mDungeonBusterAttackTimeline);
            mDBFacade.hud.hideBustSign();
         }
      }
      
      public function canPlayDungeonBusterAttack() : Boolean
      {
         if(mDistributedPlayerOwner.dungeonBusterPoints >= mDistributedPlayerOwner.maxBusterPoints)
         {
            return true;
         }
         return false;
      }
      
      public function addToPotentialWeaponInputQueue(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         if(mDungeonBusterAttackTimeline && mDungeonBusterAttackTimeline.isPlaying)
         {
            return;
         }
         if(param1 == 3 && canPlayDungeonBusterAttack())
         {
            mPotentialWeaponInputQueue.unshift();
            mPotentialWeaponInputQueue[0] = new PotentialWeaponInputQueueStruct(mWeaponControllers[param1],param1,param2,param3);
         }
         else
         {
            mPotentialWeaponInputQueue.push(new PotentialWeaponInputQueueStruct(mWeaponControllers[param1],param1,param2,param3));
         }
      }
      
      public function weaponCommandQueueUpCall() : void
      {
         var _loc2_:PotentialWeaponInputQueueStruct = null;
         var _loc1_:Boolean = false;
         while(mPotentialWeaponInputQueue.length > 0)
         {
            _loc2_ = mPotentialWeaponInputQueue[0];
            _loc1_ = false;
            if(_loc2_.weaponIndex == 3 && canPlayDungeonBusterAttack())
            {
               mNextWeaponCommand = new PotentialWeaponInputQueueStruct(_loc2_.weaponController,_loc2_.weaponIndex,_loc2_.down,_loc2_.autoAim);
               _loc1_ = true;
               break;
            }
            if(_loc2_.down)
            {
               _loc1_ = canQueueWeaponDown(_loc2_);
            }
            else
            {
               _loc1_ = canQueueWeaponUp(_loc2_);
            }
            if(_loc1_)
            {
               mNextWeaponCommand = _loc2_;
            }
            mPotentialWeaponInputQueue.shift();
         }
         tryAttack();
         mPotentialWeaponInputQueue.length = 0;
      }
      
      protected function canQueueWeaponDown(param1:PotentialWeaponInputQueueStruct) : Boolean
      {
         if(mNextWeaponCommand || currentWeaponController.weaponDownActive || param1.weaponController != null && param1.weaponController.IsInCooldown)
         {
            return false;
         }
         return true;
      }
      
      protected function canQueueWeaponUp(param1:PotentialWeaponInputQueueStruct) : Boolean
      {
         if(mNextWeaponCommand != null && mNextWeaponCommand.down && mNextWeaponCommand.weaponController == param1.weaponController)
         {
            mNextWeaponCommand = null;
         }
         else if(mNextWeaponCommand != null)
         {
            return false;
         }
         if(param1.weaponController != null && param1.weaponController.IsInCooldown)
         {
            return false;
         }
         if(currentWeaponController.currentTimeline == null)
         {
            return true;
         }
         return currentWeaponController.canQueue(param1,mQueueNextAttackWindow);
      }
      
      protected function get currentWeaponController() : WeaponController
      {
         return mWeaponControllers[mDistributedPlayerOwner.currentWeaponIndex];
      }
      
      protected function tryAttack() : void
      {
         var _loc1_:ScriptTimeline = null;
         if(mNextWeaponCommand == null)
         {
            return;
         }
         if(mDungeonBusterAttackTimeline && mDungeonBusterAttackTimeline.isPlaying)
         {
            mNextWeaponCommand = null;
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:WeaponController = mNextWeaponCommand.weaponController;
         if(mDistributedPlayerOwner.stateMachine.currentStateName == "ActorDefaultState" && mDistributedPlayerOwner.canInitiateAnAttack)
         {
            if(mNextWeaponCommand.weaponIndex == 3)
            {
               if(mDistributedPlayerOwner.dungeonBusterPoints >= mDistributedPlayerOwner.maxBusterPoints)
               {
                  playDungeonBusterAttack();
               }
               mNextWeaponCommand = null;
               return;
            }
            _loc1_ = currentWeaponController.currentTimeline;
            if(mNextWeaponCommand.down)
            {
               if(_loc1_ == null)
               {
                  _loc2_ = true;
               }
            }
            else if(_loc1_ == null)
            {
               _loc2_ = true;
            }
            else if(currentWeaponController.isRepeater() && currentWeaponController.weaponDownActive || currentWeaponController.canCombo())
            {
               _loc2_ = true;
            }
            else
            {
               _loc2_ = false;
            }
         }
         else
         {
            mNextWeaponCommand = null;
         }
         if(_loc1_ == null)
         {
            resetCombosOnAllBut();
         }
         if(_loc2_)
         {
            if(mNextWeaponCommand.down)
            {
               onWeaponDown(mNextWeaponCommand.weaponIndex,mNextWeaponCommand.autoAim);
            }
            else
            {
               onWeaponUp(mNextWeaponCommand.weaponIndex,mNextWeaponCommand.autoAim);
            }
            mNextWeaponCommand = null;
         }
      }
      
      public function isCharging() : Boolean
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < mWeaponControllers.length)
         {
            if(mWeaponControllers[_loc1_] && mWeaponControllers[_loc1_].weaponDownActive)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function onWeaponDown(param1:uint, param2:Boolean) : void
      {
         var _loc3_:WeaponController = mDistributedPlayerOwner.weaponControllers[param1];
         if(_loc3_)
         {
            mDistributedPlayerOwner.currentWeaponIndex = param1;
            _loc3_.onWeaponDown(param2);
         }
      }
      
      public function onWeaponUp(param1:uint, param2:Boolean) : void
      {
         var _loc3_:WeaponController = mDistributedPlayerOwner.weaponControllers[param1];
         if(_loc3_)
         {
            mDistributedPlayerOwner.heading = mDistributedPlayerOwner.inputHeading;
            _loc3_.onWeaponUp(param2);
            mDistributedPlayerOwner.currentWeaponIndex = param1;
         }
      }
      
      public function resetCombosOnAllBut(param1:uint = 4294967295) : void
      {
         var _loc2_:* = 0;
         var _loc3_:WeaponController = null;
         _loc2_ = 0;
         while(_loc2_ < mWeaponControllers.length)
         {
            if(_loc2_ != param1)
            {
               _loc3_ = mWeaponControllers[_loc2_];
               if(_loc3_)
               {
                  _loc3_.resetCombos();
               }
            }
            _loc2_++;
         }
      }
      
      public function resetWeapons() : void
      {
         var _loc1_:* = 0;
         var _loc2_:WeaponController = null;
         mPotentialWeaponInputQueue.length = 0;
         _loc1_ = 0;
         while(_loc1_ < mWeaponControllers.length)
         {
            _loc2_ = mWeaponControllers[_loc1_];
            if(_loc2_)
            {
               _loc2_.reset();
            }
            _loc1_++;
         }
      }
      
      public function playPotentialPotionAttack(param1:uint) : void
      {
         var _loc3_:GMStackable = mDBFacade.gameMaster.stackableById.itemFor(param1);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc2_:String = _loc3_.UsageAttack;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc4_:GMAttack = mDBFacade.gameMaster.attackByConstant.itemFor(_loc2_);
         if(_loc4_ == null)
         {
            return;
         }
         var _loc6_:AttackTimeline = mDBFacade.timelineFactory.createAttackTimeline(_loc4_.AttackTimeline,mDistributedPlayerOwner.currentWeapon,mDistributedPlayerOwner,mDistributedPlayerOwner.distributedDungeonFloor);
         var _loc7_:Number = mDistributedPlayerOwner.currentWeapon.getAttackTimeline(_loc4_.Id).totalFrames;
         var _loc5_:Number = _loc4_.AttackSpdF;
         if(_loc5_ > 0)
         {
            mDistributedPlayerOwner.attack(_loc4_.Id,null,_loc4_.AttackSpdF,_loc6_);
         }
      }
      
      private function berserkModeStart(param1:GameObjectEvent) : void
      {
         var _loc2_:ChargeWeaponController = null;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < mWeaponControllers.length)
         {
            _loc2_ = mWeaponControllers[_loc3_] as ChargeWeaponController;
            if(_loc2_)
            {
               _loc2_.berserkModeStart();
            }
            _loc3_++;
         }
      }
      
      private function berserkModeEnd(param1:GameObjectEvent) : void
      {
         var _loc2_:ChargeWeaponController = null;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < mWeaponControllers.length)
         {
            _loc2_ = mWeaponControllers[_loc3_] as ChargeWeaponController;
            if(_loc2_)
            {
               _loc2_.berserkModeEnd();
            }
            _loc3_++;
         }
      }
      
      public function tryToDoConsumableAttack(param1:uint) : void
      {
         if(mConsumableControllers[param1] != null && !mConsumableControllers[param1].IsInCooldown)
         {
            mConsumableControllers[param1].consume();
         }
      }
      
      public function stopAttacking() : void
      {
         mNextWeaponCommand = null;
         mPotentialWeaponInputQueue.length = 0;
      }
      
      public function clearInput() : void
      {
         stopAttacking();
         for each(var _loc1_ in weaponControllers)
         {
            if(_loc1_)
            {
               _loc1_.reset();
            }
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < mWeaponControllers.length)
         {
            if(mWeaponControllers[_loc1_] != null)
            {
               mWeaponControllers[_loc1_].destroy();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < mConsumableControllers.length)
         {
            if(mConsumableControllers[_loc1_] != null)
            {
               mConsumableControllers[_loc1_].destroy();
            }
            _loc1_++;
         }
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mEventComponent.destroy();
         mEventComponent = null;
      }
   }
}

