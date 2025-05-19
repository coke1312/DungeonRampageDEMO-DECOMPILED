package Actor
{
   import Actor.Buffs.BuffHandler;
   import Actor.StateMachine.ActorMacroStateMachine;
   import Box2D.Dynamics.b2FilterData;
   import Brain.Clock.GameClock;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.PreRenderWorkComponent;
   import Brain.WorkLoop.Task;
   import Combat.Attack.AttackTimeline;
   import Combat.Attack.ScriptTimeline;
   import Combat.Weapon.WeaponGameObject;
   import DBGlobals.DBGlobal;
   import DistributedObjects.DistributedDungeonFloor;
   import Dungeon.Tile;
   import Events.HpEvent;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Floor.FloorView;
   import GameMasterDictionary.GMAttack;
   import GameMasterDictionary.GMSkin;
   import GameMasterDictionary.StatVector;
   import GeneratedCode.AttackChoreography;
   import GeneratedCode.CombatResult;
   import GeneratedCode.WeaponDetails;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class ActorGameObject extends FloorObject
   {
      
      public static const PROP_CHAR_TYPE:String = "PROP";
      
      public static const PET_CHAR_TYPE:String = "PET";
      
      private static const SUFFER_TIMELINE_NAME:String = "GENERIC_STUN";
      
      private static const GENERIC_SUFFER_KNOCKBACK:String = "GENERIC_SUFFER_KNOCKBACK";
      
      private static const TELEPORT:String = "TELEPORT";
      
      public static const ATTEMPT_REVIVE_INSTANT_TIMELINE_NAME:String = "TM_ATTEMPT_REVIVE_INSTANT";
      
      public static const ATTEMPT_REVIVE_LONG_TIMELINE_NAME:String = "TM_ATTEMPT_REVIVE_LONG";
      
      protected static const ATTEMPT_REVIVE_LONG_ATTACK_ID:uint = 910900;
      
      protected static const ATTEMPT_REVIVE_INSTANT_ATTACK_ID:uint = 910901;
      
      protected var mScreenName:String = "";
      
      protected var mHeading:Number = 0;
      
      protected var mActorView:ActorView;
      
      protected var mActorStateMachine:ActorMacroStateMachine;
      
      protected var mMovementController:MovementController;
      
      protected var mMouseEventHandler:MouseEventHandler;
      
      protected var mPreRenderWorkComponent:PreRenderWorkComponent;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mRunIdleMonitorTask:Task;
      
      protected var mHitPoints:uint;
      
      private var mShowHitFloater:Boolean;
      
      protected var objPlayerDist:int;
      
      protected var mState:String;
      
      protected var mActorType:uint;
      
      protected var mActorData:ActorData;
      
      protected var mWeapons:Vector.<WeaponGameObject>;
      
      protected var mWeaponDetails:Vector.<WeaponDetails>;
      
      protected var mStats:StatVector;
      
      protected var mLevel:uint;
      
      public var buffHandler:BuffHandler;
      
      protected var mCurrentWeapon:WeaponGameObject;
      
      protected var mHasOwnership:Boolean;
      
      private var mTeam:int;
      
      protected var mFlip:uint = 0;
      
      private var mSufferTimeline:ScriptTimeline;
      
      private var mSufferKnockBackTimeline:ScriptTimeline;
      
      private var mTeleportInTimeline:ScriptTimeline;
      
      private var mTeleportOutTimeline:ScriptTimeline;
      
      protected var mAFK:Boolean;
      
      private var mIsBlocking:Boolean = false;
      
      private var mMaximumDotForBlock:Number = -1.1;
      
      public var effectivenessShown:Boolean = false;
      
      protected var mAttemptReviveScript:AttackTimeline;
      
      private var mCanBeKnockedBack:Boolean = true;
      
      public function ActorGameObject(param1:DBFacade, param2:uint = 0)
      {
         super(param1,param2);
         mStats = new StatVector();
         mTeam = 0;
         mAFK = false;
         mMovementController = new MovementController(this,mActorView,mDBFacade);
         mMouseEventHandler = new MouseEventHandler(this,mDBFacade);
         mPreRenderWorkComponent = new PreRenderWorkComponent(mDBFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         buildStateMachine();
         mLevel = 0;
         this.layer = 20;
         buffHandler = new BuffHandler(param1,this);
         mShowHitFloater = mDBFacade.dbConfigManager.getConfigBoolean("show_hit_floater",true);
      }
      
      public function get isOwner() : Boolean
      {
         return false;
      }
      
      public function get projectileLaunchOffset() : Vector3D
      {
         return new Vector3D(0,mActorData.gMActor.scaled_ProjEmitOffset);
      }
      
      override public function set tile(param1:Tile) : void
      {
         if(param1 == mTile)
         {
            super.tile = param1;
            return;
         }
         if(mHasOwnership && mTile)
         {
            mTile.removeOwnedFloorObject(this);
         }
         super.tile = param1;
         if(mHasOwnership && mTile)
         {
            mTile.addOwnedFloorObject(this);
         }
      }
      
      public function set hasOwnership(param1:Boolean) : void
      {
         mHasOwnership = param1;
         if(mHasOwnership)
         {
            if(this.tile)
            {
               this.tile.addOwnedFloorObject(this);
            }
         }
         else if(this.tile)
         {
            this.tile.removeOwnedFloorObject(this);
         }
      }
      
      override public function newNetworkChild(param1:GameObject) : void
      {
      }
      
      public function get isNavigable() : Boolean
      {
         return false;
      }
      
      public function get isAttackable() : Boolean
      {
         return true;
      }
      
      override public function init() : void
      {
         var _loc2_:String = null;
         super.init();
         this.createNavCollisions(this.actorData.constant);
         mMouseEventHandler.Init();
         setupWeapons();
         initializeToFirstValidWeapon();
         determineState();
         var _loc3_:String = this.actorData.gMActor.TeleportInTimeline;
         var _loc1_:String = this.actorData.gMActor.TeleportOutTimeline;
         if(_loc3_ && _loc1_)
         {
            mTeleportInTimeline = mDBFacade.timelineFactory.createScriptTimeline(_loc3_,this,mDistributedDungeonFloor);
            mTeleportOutTimeline = mDBFacade.timelineFactory.createScriptTimeline(_loc1_,this,mDistributedDungeonFloor);
         }
         if(!mAttemptReviveScript)
         {
            if(mDBFacade.dbConfigManager.getConfigBoolean("use_long_revive",true))
            {
               _loc2_ = "TM_ATTEMPT_REVIVE_LONG";
            }
            else
            {
               _loc2_ = "TM_ATTEMPT_REVIVE_INSTANT";
            }
            mAttemptReviveScript = mDBFacade.timelineFactory.createAttackTimeline(_loc2_,null,this,mDistributedDungeonFloor);
         }
      }
      
      public function get actorView() : ActorView
      {
         return mActorView;
      }
      
      public function set currentWeapon(param1:WeaponGameObject) : void
      {
         mCurrentWeapon = param1;
         if(mActorView)
         {
            if(param1)
            {
               mActorView.currentWeapon = param1.weaponView;
            }
            else
            {
               Logger.warn("Trying to equip a null weapon game object on actor.");
            }
         }
      }
      
      public function get currentWeapon() : WeaponGameObject
      {
         return mCurrentWeapon;
      }
      
      protected function buildStateMachine() : void
      {
      }
      
      public function set stateMachine(param1:ActorMacroStateMachine) : void
      {
         mActorStateMachine = param1;
      }
      
      public function get stateMachine() : ActorMacroStateMachine
      {
         return mActorStateMachine;
      }
      
      public function get actorData() : ActorData
      {
         return mActorData;
      }
      
      public function get actorNametag() : ActorNametag
      {
         return mActorView.nametag;
      }
      
      override public function set view(param1:FloorView) : void
      {
         mActorView = param1 as ActorView;
         if(mCurrentWeapon)
         {
            mActorView.currentWeapon = mCurrentWeapon.weaponView;
         }
         super.view = param1;
      }
      
      public function set screenName(param1:String) : void
      {
         mScreenName = param1;
         mActorView.screenName = screenName;
      }
      
      public function get AFK() : Boolean
      {
         return mAFK;
      }
      
      public function get screenName() : String
      {
         return mScreenName;
      }
      
      public function Chat(param1:String) : void
      {
         mActorView.setChat(param1);
      }
      
      public function ShowPlayerisTyping(param1:Boolean) : void
      {
         if(mActorView && mActorView.nametag)
         {
            mActorView.nametag.showPlayerIsTypingNotification(param1);
         }
      }
      
      public function get maxHitPoints() : Number
      {
         return mStats.maxHitPoints * this.buffHandler.multiplier.maxHitPoints;
      }
      
      public function get attackCooldownMultiplier() : Number
      {
         return buffHandler.attackCooldownMultiplier;
      }
      
      public function get maxManaPoints() : Number
      {
         return mStats.maxManaPoints * this.buffHandler.multiplier.maxManaPoints;
      }
      
      public function get movementSpeed() : Number
      {
         var _loc2_:Number = mStats.movementSpeed;
         var _loc3_:Number = this.buffHandler.multiplier.movementSpeed;
         return _loc2_ * _loc3_;
      }
      
      public function get heading() : Number
      {
         return mHeading;
      }
      
      public function set heading(param1:Number) : void
      {
         mHeading = param1;
         this.move();
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
         this.move();
      }
      
      protected function move() : void
      {
         mMovementController.move(this.position,this.heading);
      }
      
      public function getHeadingAsVector(param1:Number = 0) : Vector3D
      {
         var _loc4_:Vector3D = new Vector3D();
         var _loc2_:Number = (heading + param1) * 3.141592653589793 / 180;
         var _loc5_:Number = Math.cos(_loc2_);
         var _loc3_:Number = Math.sin(_loc2_);
         return new Vector3D(_loc5_,_loc3_);
      }
      
      public function set movementControllerType(param1:String) : void
      {
         this.mMovementController.movementType = param1;
      }
      
      public function get movementControllerType() : String
      {
         return this.mMovementController.movementType;
      }
      
      public function get canMoveR() : Boolean
      {
         return this.mMovementController.canMoveR;
      }
      
      public function postGenerate() : void
      {
         mActorData = buildActorData();
         refreshStatVector();
         checkIfReadyForInit();
         mActorView.position = position;
      }
      
      protected function buildActorData() : ActorData
      {
         return new ActorData(mDBFacade,this);
      }
      
      public function playEffectAtActor(param1:String, param2:String, param3:Number, param4:String) : void
      {
         distributedDungeonFloor.effectManager.playEffect(DBFacade.buildFullDownloadPath(param1),param2,actorView.position,null,false,param3,0,0,0,0,false,param4);
      }
      
      override public function destroy() : void
      {
         if(mTile && mTile.hasOwnedFloorObject(this))
         {
            mTile.removeOwnedFloorObject(this);
         }
         if(mDistributedDungeonFloor)
         {
            mDistributedDungeonFloor.RemoveNetworkChild(this);
         }
         if(mSufferTimeline)
         {
            mSufferTimeline.destroy();
            mSufferTimeline = null;
         }
         if(mSufferKnockBackTimeline)
         {
            mSufferKnockBackTimeline.destroy();
            mSufferKnockBackTimeline = null;
         }
         if(mTeleportInTimeline)
         {
            mTeleportInTimeline.destroy();
            mTeleportInTimeline = null;
         }
         if(mTeleportOutTimeline)
         {
            mTeleportOutTimeline.destroy();
            mTeleportOutTimeline = null;
         }
         mPosition = null;
         mMovementController.destroy();
         mMovementController = null;
         mMouseEventHandler.destroy();
         mMouseEventHandler = null;
         mPreRenderWorkComponent.destroy();
         mPreRenderWorkComponent = null;
         if(mLogicalWorkComponent)
         {
            mLogicalWorkComponent.destroy();
         }
         mLogicalWorkComponent = null;
         mActorStateMachine = null;
         mStats.destroy();
         mStats = null;
         buffHandler.destroy();
         buffHandler = null;
         mActorView = null;
         if(mActorData)
         {
            mActorData.destroy();
            mActorData = null;
         }
         mCurrentWeapon = null;
         mWeaponDetails = null;
         for each(var _loc1_ in mWeapons)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
         }
         mWeapons = null;
         if(mRunIdleMonitorTask)
         {
            mRunIdleMonitorTask.destroy();
            mRunIdleMonitorTask = null;
         }
         super.destroy();
      }
      
      override public function set distributedDungeonFloor(param1:DistributedDungeonFloor) : void
      {
         super.distributedDungeonFloor = param1;
         checkIfReadyForInit();
      }
      
      private function checkIfReadyForInit() : void
      {
         if(mDistributedDungeonFloor != null && mActorData != null)
         {
            init();
         }
      }
      
      public function attack(param1:uint, param2:ActorGameObject, param3:Number, param4:AttackTimeline, param5:Function = null, param6:Function = null, param7:Boolean = false, param8:Boolean = false) : void
      {
         param4.currentAttackType = param1;
         mActorStateMachine.enterChoreographyState(param3,param2,param4,param5,param6,param7,param8);
      }
      
      public function set hitPoints(param1:uint) : void
      {
         mHitPoints = param1;
         mActorView.setHp(mHitPoints,this.maxHitPoints);
         mFacade.eventManager.dispatchEvent(new HpEvent("HpEvent_HP_UPDATE",id,mHitPoints,this.maxHitPoints));
      }
      
      public function get hitPoints() : uint
      {
         return mHitPoints;
      }
      
      public function get gmSkin() : GMSkin
      {
         return null;
      }
      
      public function ReceiveAttackChoreography(param1:AttackChoreography) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:ActorGameObject = null;
         var _loc2_:WeaponDetails = this.mWeaponDetails[param1.attack.weaponSlot];
         var _loc3_:WeaponGameObject = null;
         if(_loc2_.type != 0)
         {
            _loc3_ = getWeaponForId(_loc2_.type);
            if(_loc3_ == null)
            {
               Logger.error("Weapon type: " + _loc2_.type + " on incoming attackChoreography does not match any weapon type currently equipped on actor.");
               return;
            }
            currentWeapon = _loc3_;
         }
         else
         {
            _loc3_ = currentWeapon;
         }
         var _loc6_:GMAttack = mDBFacade.gameMaster.attackById.itemFor(param1.attack.attackType);
         if(_loc6_ == null)
         {
            Logger.error("Unable to find GMAttack for attacktype: " + param1.attack.attackType);
            return;
         }
         var _loc7_:AttackTimeline = _loc3_.getAttackTimeline(_loc6_.Id);
         if(_loc7_)
         {
            _loc4_ = param1.playSpeed;
            if(param1.attack.targetActorDoid != 0)
            {
               _loc5_ = mDBFacade.gameObjectManager.getReferenceFromId(param1.attack.targetActorDoid) as ActorGameObject;
            }
            mActorStateMachine.enterAttackChoreographyState(_loc4_,_loc5_,_loc7_,param1);
         }
      }
      
      public function ReceiveCombatResult(param1:CombatResult) : void
      {
         var _loc2_:GMAttack = mDBFacade.gameMaster.attackById.itemFor(param1.attack.attackType);
         if(_loc2_)
         {
            if(_loc2_.DamageMod > 0)
            {
               this.actorView.receiveHeal(param1,_loc2_);
            }
            else if(param1.blocked == 0)
            {
               this.actorView.receiveDamage(param1,_loc2_);
               receiveDamage(param1);
            }
            else
            {
               trace("TODO: Implement blocked view things and such!   BLOCKED!!!!!");
            }
         }
      }
      
      public function get canSuffer() : Boolean
      {
         return !this.hasAbility(1);
      }
      
      public function get canBeKnockedBack() : Boolean
      {
         return mCanBeKnockedBack;
      }
      
      public function set canBeKnockedBack(param1:Boolean) : void
      {
         mCanBeKnockedBack = param1;
      }
      
      private function receiveDamage(param1:CombatResult) : void
      {
         if(isHeroType && param1.attacker != param1.attackee)
         {
            mMouseEventHandler.sendGotHitEvent();
         }
         var _loc2_:Number = 1;
         if(param1.knockback == 1 && canBeKnockedBack)
         {
            if(!mSufferKnockBackTimeline)
            {
               mSufferKnockBackTimeline = mDBFacade.timelineFactory.createScriptTimeline("GENERIC_SUFFER_KNOCKBACK",this,mDistributedDungeonFloor);
            }
            mSufferKnockBackTimeline.currentAttackType = param1.attack.attackType;
            mActorStateMachine.enterCombatResultChoreographyState(_loc2_,null,mSufferKnockBackTimeline,param1,mDistributedDungeonFloor.getActor(param1.attacker));
         }
         else if(param1.suffer == 1 && canSuffer)
         {
            if(!mSufferTimeline)
            {
               mSufferTimeline = mDBFacade.timelineFactory.createScriptTimeline("GENERIC_STUN",this,mDistributedDungeonFloor);
            }
            mActorStateMachine.enterCombatResultChoreographyState(_loc2_,null,mSufferTimeline,param1,mDistributedDungeonFloor.getActor(param1.attacker));
         }
      }
      
      public function ReceiveTimelineAction(param1:String) : void
      {
         if(mTeleportInTimeline && param1 == mTeleportInTimeline.attackName)
         {
            mActorStateMachine.enterChoreographyState(1,null,mTeleportInTimeline);
         }
         if(mTeleportOutTimeline && param1 == mTeleportOutTimeline.attackName)
         {
            mActorStateMachine.enterChoreographyState(1,null,mTeleportOutTimeline);
         }
      }
      
      protected function getWeaponForId(param1:uint) : WeaponGameObject
      {
         for each(var _loc2_ in mWeapons)
         {
            if(_loc2_ && _loc2_.type == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get weapons() : Vector.<WeaponGameObject>
      {
         return mWeapons;
      }
      
      public function set type(param1:uint) : void
      {
         mActorType = param1;
      }
      
      public function get type() : uint
      {
         return mActorType;
      }
      
      public function get isHeroType() : Boolean
      {
         if(mActorType > 100 && mActorType < 200)
         {
            return true;
         }
         return false;
      }
      
      public function get isProp() : Boolean
      {
         return this.actorData.gMActor.CharType == "PROP";
      }
      
      public function get isPet() : Boolean
      {
         return this.actorData.gMActor.CharType == "PET";
      }
      
      public function get usePetUI() : Boolean
      {
         return false;
      }
      
      public function get hasShowHealNumbers() : Boolean
      {
         return false;
      }
      
      public function set state(param1:String) : void
      {
         if(mState != param1)
         {
            mState = param1;
            determineState();
         }
      }
      
      public function set weaponDetails(param1:Vector.<WeaponDetails>) : void
      {
         mWeaponDetails = param1;
         if(mActorData && mDistributedDungeonFloor)
         {
            setupWeapons();
            initializeToFirstValidWeapon();
         }
      }
      
      protected function setupWeapons() : void
      {
         for each(var _loc1_ in mWeapons)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
         }
         var _loc2_:Number = 0;
         mWeapons = new Vector.<WeaponGameObject>();
         for each(var _loc3_ in mWeaponDetails)
         {
            if(_loc3_.type != 0)
            {
               _loc1_ = new WeaponGameObject(_loc3_,this,mActorView,mDBFacade,mDistributedDungeonFloor,_loc2_);
               mWeapons.push(_loc1_);
            }
            else
            {
               mWeapons.push(null);
            }
            _loc2_++;
         }
         setupConsumables();
      }
      
      protected function setupConsumables() : void
      {
      }
      
      protected function initializeToFirstValidWeapon() : void
      {
         var _loc1_:WeaponGameObject = null;
         var _loc2_:* = 0;
         if(mWeapons.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < mWeapons.length)
            {
               _loc1_ = mWeapons[_loc2_];
               if(_loc1_ != null)
               {
                  this.currentWeapon = _loc1_;
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      public function isDead() : Boolean
      {
         if(mActorStateMachine == null)
         {
            return false;
         }
         return mActorStateMachine.currentStateName == "ActorDeadState";
      }
      
      public function isInReviveState() : Boolean
      {
         if(mActorStateMachine == null)
         {
            return false;
         }
         return mActorStateMachine.currentStateName == "ActorReviveState";
      }
      
      public function localToGlobal(param1:Point) : Point
      {
         return this.view.root.localToGlobal(param1);
      }
      
      public function globalToLocal(param1:Point) : Point
      {
         return this.view.root.globalToLocal(param1);
      }
      
      public function hitTestObject(param1:DisplayObject) : Boolean
      {
         return this.view.root.hitTestObject(param1);
      }
      
      public function localCombatHit(param1:CombatResult) : void
      {
         mActorView.localCombatHit(param1);
      }
      
      public function set scale(param1:Number) : void
      {
         this.view.root.scaleX = param1;
         this.view.root.scaleY = param1;
      }
      
      public function set flip(param1:uint) : void
      {
         mFlip = param1;
         if(mFlip)
         {
            this.actorView.body.scaleX = -Math.abs(this.actorView.body.scaleX);
         }
      }
      
      public function get flip() : uint
      {
         return mFlip;
      }
      
      public function set level(param1:uint) : void
      {
         mLevel = param1;
      }
      
      public function get level() : uint
      {
         return mLevel;
      }
      
      public function get stats() : StatVector
      {
         return mStats;
      }
      
      public function set stats(param1:StatVector) : void
      {
         mStats = param1;
         mActorView.setHp(mHitPoints,this.maxHitPoints);
         mDBFacade.eventManager.dispatchEvent(new HpEvent("HpEvent_HP_UPDATE",id,mHitPoints,this.maxHitPoints));
      }
      
      protected function determineState() : void
      {
         if(this.actorData != null)
         {
            switch(mState)
            {
               case "dead":
                  mActorStateMachine.enterDeadState(finishedDeathCallback);
                  break;
               case "":
                  mActorStateMachine.enterDefaultState();
                  break;
               default:
                  Logger.error("No case handled for state: " + mState + " for actorGameObject.");
            }
         }
      }
      
      protected function finishedDeathCallback(param1:GameClock = null) : void
      {
         if(mHasOwnership)
         {
            this.destroy();
         }
      }
      
      protected function refreshStatVector() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 5;
         var _loc4_:Number = Number(mTeam == 5 ? mLevel : Math.pow(mLevel,1.5));
         var _loc3_:StatVector = StatVector.add(mActorData.baseValues,StatVector.multiplyScalar(mActorData.levelValues,_loc4_));
         var _loc2_:StatVector = StatVector.add(StatVector.multiply(_loc3_,mDBFacade.gameMaster.stat_BonusMultiplier),mDBFacade.gameMaster.stat_bias);
         _loc2_.values[0] = mActorData.hp + _loc2_.values[0];
         _loc2_.values[1] = mActorData.mp + _loc2_.values[1];
         _loc2_.values[13] = mActorData.gMActor.BaseMove + _loc2_.values[13];
         stats = _loc2_;
      }
      
      override protected function buildFilter() : b2FilterData
      {
         var _loc1_:b2FilterData = new b2FilterData();
         _loc1_.maskBits = 0;
         _loc1_.categoryBits = 0;
         _loc1_.categoryBits |= DBGlobal.b2dMaskForTeam(team);
         if(!this.isNavigable)
         {
            _loc1_.maskBits |= 1;
            _loc1_.maskBits |= DBGlobal.b2dMaskForAllTeamsBut(team);
            if(this.actorData.gMActor.CollideWithTeam || this.isOwner)
            {
               _loc1_.maskBits |= DBGlobal.b2dMaskForTeam(team);
            }
         }
         if(actorData.gMActor.Species != "TRAP")
         {
            _loc1_.maskBits |= 2;
         }
         return _loc1_;
      }
      
      public function set team(param1:int) : void
      {
         mTeam = param1;
      }
      
      public function get team() : int
      {
         return mTeam;
      }
      
      public function hasAbility(param1:uint) : Boolean
      {
         return (actorData.gMActor.Ability & param1) != 0 || buffHandler.HasAbility(param1);
      }
      
      public function startRunIdleMonitoring() : void
      {
         if(!mRunIdleMonitorTask)
         {
            mRunIdleMonitorTask = mPreRenderWorkComponent.doEveryFrame(runIdleMonitor);
         }
      }
      
      public function stopRunIdleMonitoring() : void
      {
         if(mRunIdleMonitorTask)
         {
            mRunIdleMonitorTask.destroy();
            mRunIdleMonitorTask = null;
         }
      }
      
      private function runIdleMonitor(param1:GameClock) : void
      {
         if(mActorView.velocity.lengthSquared == 0)
         {
            mActorView.playAnim("idle");
         }
         else
         {
            mActorView.playAnim("run");
         }
      }
      
      public function set setAFK(param1:uint) : void
      {
         this.mAFK = param1 != 0;
         mActorView.AFK = this.mAFK;
      }
      
      public function get isBlocking() : Boolean
      {
         return mIsBlocking;
      }
      
      public function set isBlocking(param1:Boolean) : void
      {
         mIsBlocking = param1;
      }
      
      public function get maximumDotForBlocking() : Number
      {
         return mMaximumDotForBlock;
      }
      
      public function set maximumDotForBlocking(param1:Number) : void
      {
         mMaximumDotForBlock = param1;
      }
      
      public function ponderBuffChanges() : void
      {
      }
   }
}

