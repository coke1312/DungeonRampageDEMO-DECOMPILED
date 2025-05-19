package DistributedObjects
{
   import Actor.ActorData;
   import Actor.ActorGameObject;
   import Actor.HeroData;
   import Actor.Player.HeroStateMachine;
   import Actor.Player.HeroView;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Combat.Attack.AttackTimeline;
   import Combat.Weapon.ConsumableWeaponGameObject;
   import Events.BusterPointsEvent;
   import Events.ChatEvent;
   import Events.ExperienceEvent;
   import Events.FacebookLevelUpPostEvent;
   import Events.GameObjectEvent;
   import Events.HpEvent;
   import Events.ManaEvent;
   import Events.PlayerIsTypingEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import Floor.FloorMessageView;
   import Floor.FloorView;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMSkin;
   import GameMasterDictionary.StatVector;
   import GeneratedCode.AttackChoreography;
   import GeneratedCode.ConsumableDetails;
   import GeneratedCode.HeroGameObjectNetworkComponent;
   import GeneratedCode.IHeroGameObject;
   import GeneratedCode.WeaponDetails;
   
   public class HeroGameObject extends ActorGameObject implements IHeroGameObject
   {
      
      public static const LEGENDARY_MOD_STAMINA:uint = 1;
      
      public static const LEGENDARY_MOD_APTITUDE:uint = 2;
      
      public static const LEGENDARY_MOD_ACCELERATION:uint = 3;
      
      public static const MAX_HEALTH_BOMBS_PER_DUNGEON:uint = 3;
      
      public static const MAX_PARTY_BOMBS_PER_DUNGEON:uint = 3;
      
      protected var mHeroGameObjectNetworkComponent:HeroGameObjectNetworkComponent;
      
      protected var mCanMove:Boolean = true;
      
      protected var mMana:uint;
      
      protected var mMaxBusterPoints:uint = 4294967295;
      
      protected var mBusterPoints:uint;
      
      protected var mExperiencePoints:uint;
      
      protected var mHeroView:HeroView;
      
      protected var mHeroStateMachine:HeroStateMachine;
      
      protected var mPlayerID:uint;
      
      protected var mSlotPoints:Vector.<uint>;
      
      protected var mChatEventComponent:EventComponent;
      
      protected var mCanInitiateAnAttack:Boolean;
      
      protected var mHeroData:HeroData;
      
      protected var mGMSkin:GMSkin;
      
      protected var mPartyBombsUsed:uint = 0;
      
      protected var mHealthBombsUsed:uint = 0;
      
      protected var mStaminaModMultiplier:Number;
      
      protected var mAptitudeModMultiplier:Number;
      
      protected var mAccelerationModMultiplier:Number;
      
      protected var mConsumableDetails:Vector.<ConsumableDetails>;
      
      protected var mConsumableWeapons:Vector.<ConsumableWeaponGameObject>;
      
      public function HeroGameObject(param1:DBFacade, param2:uint)
      {
         super(param1,param2);
         mWantNavCollisions = true;
         mLogicalWorkComponent = new LogicalWorkComponent(mFacade);
         mChatEventComponent = new EventComponent(param1);
         mCanInitiateAnAttack = true;
      }
      
      override protected function processJsonNavCollisions(param1:Array, param2:Function) : void
      {
         super.processJsonNavCollisions(param1,param2);
      }
      
      override protected function buildView() : void
      {
         view = new HeroView(mDBFacade,this);
      }
      
      override public function set view(param1:FloorView) : void
      {
         mHeroView = param1 as HeroView;
         super.view = param1;
      }
      
      public function get heroView() : HeroView
      {
         return mHeroView;
      }
      
      override protected function buildStateMachine() : void
      {
         mHeroStateMachine = new HeroStateMachine(mDBFacade,this,this.mHeroView);
         stateMachine = mHeroStateMachine;
      }
      
      public function get heroStateMachine() : HeroStateMachine
      {
         return mHeroStateMachine;
      }
      
      public function get canInitiateAnAttack() : Boolean
      {
         return mCanInitiateAnAttack;
      }
      
      public function set canInitiateAnAttack(param1:Boolean) : void
      {
         mCanInitiateAnAttack = param1;
      }
      
      public function setNetworkComponentDistributedPlayer(param1:HeroGameObjectNetworkComponent) : void
      {
         mHeroGameObjectNetworkComponent = param1;
      }
      
      override public function attack(param1:uint, param2:ActorGameObject, param3:Number, param4:AttackTimeline, param5:Function = null, param6:Function = null, param7:Boolean = false, param8:Boolean = false) : void
      {
         if(mCanInitiateAnAttack)
         {
            param4.currentAttackType = param1;
            mHeroStateMachine.enterChoreographyState(param3,param2,param4,param5,param6,param7,param8);
         }
      }
      
      override public function destroy() : void
      {
         mChatEventComponent.destroy();
         mHeroStateMachine.destroy();
         mHeroStateMachine = null;
         mHeroView = null;
         super.destroy();
      }
      
      override protected function determineState() : void
      {
         var _loc1_:String = mState;
         if("down" !== _loc1_)
         {
            super.determineState();
         }
         else
         {
            if(this.heroStateMachine.currentStateName == "ActorReviveState")
            {
               return;
            }
            mHeroStateMachine.enterReviveState();
         }
      }
      
      public function setState(param1:String) : void
      {
         state = param1;
      }
      
      public function set skinType(param1:uint) : void
      {
         mGMSkin = mDBFacade.gameMaster.getSkinByType(param1);
         if(mGMSkin == null)
         {
            Logger.error("Unable to find GMSkin for skin type: " + param1 + " Loading default skin for heroType: " + type);
            mGMSkin = mDBFacade.gameMaster.getSkinByConstant(gMHero.DefaultSkin);
            if(mGMSkin == null)
            {
               Logger.error("Unable to find default skin with constant: " + gMHero.DefaultSkin);
               return;
            }
         }
      }
      
      public function get skinType() : uint
      {
         return mGMSkin.Id;
      }
      
      override public function get gmSkin() : GMSkin
      {
         return mGMSkin;
      }
      
      override protected function buildActorData() : ActorData
      {
         mHeroData = new HeroData(mDBFacade,this,mGMSkin);
         return mHeroData;
      }
      
      public function set manaPoints(param1:uint) : void
      {
         mMana = param1;
         mFacade.eventManager.dispatchEvent(new ManaEvent("ManaEvent_MANA_UPDATE",id,mMana,this.maxManaPoints));
      }
      
      public function get manaPoints() : uint
      {
         return mMana;
      }
      
      public function set experiencePoints(param1:uint) : void
      {
         var _loc2_:uint = mLevel;
         mExperiencePoints = param1;
         if(actorData)
         {
            this.level = this.gMHero.getLevelFromExp(mExperiencePoints);
         }
         if(mLevel != _loc2_)
         {
            mHeroView.playHeroLevelUpEffects();
            if(this is HeroGameObjectOwner)
            {
               mFacade.eventManager.dispatchEvent(new FacebookLevelUpPostEvent("FacebookLevelUpPostEvent",mLevel));
            }
         }
         mFacade.eventManager.dispatchEvent(new ExperienceEvent("ExperienceEvent_EXPERIENCE_UPDATE",id,mExperiencePoints));
      }
      
      public function set dungeonBusterPoints(param1:uint) : void
      {
         mBusterPoints = param1;
         mFacade.eventManager.dispatchEvent(new BusterPointsEvent("BusterPointEvent_BUSTER_POINTS_UPDATE",id,mBusterPoints,mMaxBusterPoints));
      }
      
      public function get dungeonBusterPoints() : uint
      {
         return mBusterPoints;
      }
      
      public function get experiencePoints() : uint
      {
         return mExperiencePoints;
      }
      
      public function set maxBusterPoints(param1:uint) : void
      {
         mMaxBusterPoints = param1;
         mFacade.eventManager.dispatchEvent(new BusterPointsEvent("BusterPointEvent_BUSTER_POINTS_UPDATE",id,mBusterPoints,mMaxBusterPoints));
      }
      
      public function get maxBusterPoints() : uint
      {
         return mMaxBusterPoints;
      }
      
      public function get healthBombUsesRemaining() : int
      {
         var _loc1_:Number = 3 - mHealthBombsUsed;
         if(_loc1_ < 0)
         {
            Logger.warn("More healthbombs have been consumed than allowed in limited use dungeons.");
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      public function get partyBombUsesRemaining() : int
      {
         var _loc1_:Number = 3 - mPartyBombsUsed;
         if(_loc1_ < 0)
         {
            Logger.warn("More partybombs have been consumed than allowed in limited use dungeons.");
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      public function set healthBombsUsed(param1:uint) : void
      {
         mHealthBombsUsed = param1;
      }
      
      public function set partyBombsUsed(param1:uint) : void
      {
         mPartyBombsUsed = param1;
      }
      
      public function canUseHealthBombs() : Boolean
      {
         if(mDistributedDungeonFloor.isInfiniteDungeon)
         {
            return mHealthBombsUsed < 3;
         }
         return true;
      }
      
      public function canUsePartyBombs() : Boolean
      {
         if(mDistributedDungeonFloor.isInfiniteDungeon)
         {
            return mPartyBombsUsed < 3;
         }
         return true;
      }
      
      override public function postGenerate() : void
      {
         super.postGenerate();
         mFacade.eventManager.dispatchEvent(new ManaEvent("ManaEvent_MANA_UPDATE",id,mMana,this.maxManaPoints));
         mFacade.eventManager.dispatchEvent(new BusterPointsEvent("BusterPointEvent_BUSTER_POINTS_UPDATE",id,mBusterPoints,mMaxBusterPoints));
         mFacade.eventManager.dispatchEvent(new ExperienceEvent("ExperienceEvent_EXPERIENCE_UPDATE",id,mExperiencePoints));
         mFacade.eventManager.dispatchEvent(new HpEvent("HpEvent_HP_UPDATE",id,mHitPoints,this.maxHitPoints));
         mChatEventComponent.addListener(GameObjectEvent.uniqueEvent("ChatEvent_INCOMING_CHAT_UPDATE",mPlayerID),function(param1:ChatEvent):void
         {
            Chat(param1.message);
         });
         mChatEventComponent.addListener(GameObjectEvent.uniqueEvent("PLAYER_IS_TYPING",mPlayerID),function(param1:PlayerIsTypingEvent):void
         {
            if(param1.subtype == "CHAT_BOX_FOCUS_IN")
            {
               ShowPlayerisTyping(true);
            }
            else
            {
               ShowPlayerisTyping(false);
            }
         });
         processLegendaryModifiers();
      }
      
      public function processLegendaryModifiers() : void
      {
         mStaminaModMultiplier = 0;
         mAptitudeModMultiplier = 0;
         mAccelerationModMultiplier = 0;
         for each(var _loc1_ in mWeaponDetails)
         {
            switch(int(_loc1_.legendarymodifier) - 1)
            {
               case 0:
                  mStaminaModMultiplier += 10 + _loc1_.requiredlevel * 0.9;
                  break;
               case 1:
                  mAptitudeModMultiplier += 10 + _loc1_.requiredlevel * 0.4;
                  break;
               case 2:
                  mAccelerationModMultiplier += 0.1;
                  break;
            }
         }
      }
      
      override public function get maxHitPoints() : Number
      {
         return this.buffHandler.multiplier.maxHitPoints * (mStats.maxHitPoints + mStaminaModMultiplier);
      }
      
      override public function get maxManaPoints() : Number
      {
         return this.buffHandler.multiplier.maxManaPoints * (mStats.maxManaPoints + mAptitudeModMultiplier);
      }
      
      override public function get movementSpeed() : Number
      {
         var _loc2_:Number = mStats.movementSpeed;
         var _loc3_:Number = this.buffHandler.multiplier.movementSpeed;
         return _loc2_ * _loc3_ * (1 + mAccelerationModMultiplier);
      }
      
      public function set slotPoints(param1:Vector.<uint>) : void
      {
         mSlotPoints = param1;
      }
      
      public function setNetworkComponentHeroGameObject(param1:HeroGameObjectNetworkComponent) : void
      {
      }
      
      override public function set stats(param1:StatVector) : void
      {
         super.stats = param1;
         mFacade.eventManager.dispatchEvent(new ManaEvent("ManaEvent_MANA_UPDATE",id,mMana,this.maxManaPoints));
      }
      
      public function set playerID(param1:uint) : void
      {
         mPlayerID = param1;
      }
      
      public function get playerID() : uint
      {
         return mPlayerID;
      }
      
      public function TriggerEffect(param1:String) : void
      {
      }
      
      public function get gMHero() : GMHero
      {
         return mActorData.gMActor as GMHero;
      }
      
      override protected function refreshStatVector() : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:GMHero = gMHero;
         this.level = _loc1_.getLevelFromExp(mExperiencePoints);
         var _loc2_:StatVector = new StatVector();
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc1_.UpgradeToSlotOffset[_loc3_].length)
            {
               var _loc7_:* = _loc1_.UpgradeToSlotOffset[_loc3_][_loc5_];
               var _loc8_:* = _loc2_.values[_loc7_] + mSlotPoints[_loc3_];
               _loc2_.values[_loc7_] = _loc8_;
               _loc5_++;
            }
            _loc3_++;
         }
         var _loc6_:StatVector = StatVector.add(mActorData.baseValues,StatVector.multiplyScalar(mActorData.levelValues,mLevel));
         _loc6_ = StatVector.add(_loc6_,StatVector.multiply(_loc1_.Normalized_upgrades,_loc2_));
         var _loc4_:StatVector = StatVector.add(StatVector.multiply(_loc6_,mDBFacade.gameMaster.stat_BonusMultiplier),mDBFacade.gameMaster.stat_bias);
         mStats = StatVector.clone(_loc4_);
         mStats.values[0] = mActorData.hp + _loc4_.values[0];
         mStats.values[1] = mActorData.mp + _loc4_.values[1];
         mStats.values[13] = _loc1_.BaseMove * _loc4_.values[13];
      }
      
      public function IsInvulnerable() : Boolean
      {
         return buffHandler.IsInvulnerable();
      }
      
      public function setStateAndAttackChoreography(param1:String, param2:AttackChoreography) : void
      {
         state = param1;
         ReceiveAttackChoreography(param2);
      }
      
      public function StopChoreography() : void
      {
         if(this.stateMachine != null && this.stateMachine.currentSubState && this.stateMachine.currentSubState.name == "ActorChoreographySubState")
         {
            this.stateMachine.enterNavigationState();
         }
      }
      
      public function PartyBomb(param1:uint) : void
      {
         var _loc3_:HeroGameObject = mDBFacade.gameObjectManager.getReferenceFromId(param1) as HeroGameObject;
         var _loc4_:String = _loc3_.screenName + "\n" + Locale.getString("BOMB_DROPPER");
         var _loc2_:FloorMessageView = new FloorMessageView(mDBFacade,"",_loc4_.toLocaleUpperCase());
      }
      
      public function set consumableDetails(param1:Vector.<ConsumableDetails>) : void
      {
         mConsumableDetails = param1;
         var _loc5_:uint = 0;
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         if(param1.length > 0)
         {
            _loc5_ = param1[0].type;
            _loc2_ = param1[0].count;
         }
         if(param1.length > 1)
         {
            _loc4_ = param1[1].type;
            _loc3_ = param1[1].count;
         }
         if(mActorData && mDistributedDungeonFloor)
         {
            setupConsumables();
         }
      }
      
      override protected function setupConsumables() : void
      {
         for each(var _loc2_ in mConsumableWeapons)
         {
            if(_loc2_)
            {
               _loc2_.destroy();
            }
         }
         var _loc1_:uint = 0;
         mConsumableWeapons = new Vector.<ConsumableWeaponGameObject>();
         for each(var _loc3_ in mConsumableDetails)
         {
            if(_loc3_.type != 0)
            {
               mConsumableWeapons.push(new ConsumableWeaponGameObject(_loc3_,this,mActorView,mDBFacade,mDistributedDungeonFloor,_loc1_));
            }
            else
            {
               mConsumableWeapons.push(null);
            }
            _loc1_++;
         }
      }
      
      public function get consumables() : Vector.<ConsumableWeaponGameObject>
      {
         return mConsumableWeapons;
      }
   }
}

