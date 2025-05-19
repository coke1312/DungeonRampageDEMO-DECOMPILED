package Combat.Weapon
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.AssetRepository.JsonAsset;
   import Brain.GameObject.GameObject;
   import Combat.Attack.AttackTimeline;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import GameMasterDictionary.GMLegendaryModifier;
   import GameMasterDictionary.GMModifier;
   import GameMasterDictionary.GMRarity;
   import GameMasterDictionary.GMWeaponAesthetic;
   import GameMasterDictionary.GMWeaponItem;
   import GeneratedCode.WeaponDetails;
   import org.as3commons.collections.Map;
   
   public class WeaponGameObject extends GameObject
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mActorGameObject:ActorGameObject;
      
      protected var mActorView:ActorView;
      
      protected var mDistributedDungeonFloor:DistributedDungeonFloor;
      
      protected var mJsonObjs:Vector.<Object>;
      
      protected var mJsonAsset:JsonAsset;
      
      protected var mAttackTimelineMap:Map;
      
      protected var mWeaponCharge:Number;
      
      protected var mWeaponDetails:WeaponDetails;
      
      protected var mGMWeapon:GMWeaponItem;
      
      protected var mGMRarity:GMRarity;
      
      protected var mSlot:Number;
      
      private var mAttackSpeedModifier:Vector.<Number>;
      
      private var mManaModifier:Number;
      
      private var mChains:Number;
      
      private var mPierces:Number;
      
      private var mCooldownReduction:Number;
      
      private var mChargeReduction:Number;
      
      private var mCollisionScale:Number = 1;
      
      protected var mWeaponView:WeaponView;
      
      protected var mModifiers:Vector.<GMModifier>;
      
      protected var mLegendaryModifier:GMLegendaryModifier;
      
      protected var mWeaponAesthetic:GMWeaponAesthetic;
      
      public function WeaponGameObject(param1:WeaponDetails, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:DistributedDungeonFloor, param6:Number)
      {
         super(param4);
         mSlot = param6;
         mDBFacade = param4;
         mWeaponCharge = 1;
         mAttackSpeedModifier = new Vector.<Number>();
         mAttackSpeedModifier.push(1);
         mAttackSpeedModifier.push(1);
         mAttackSpeedModifier.push(1);
         mChains = 0;
         mPierces = 0;
         mManaModifier = 1;
         mCooldownReduction = 1;
         mChargeReduction = 1;
         mWeaponDetails = param1;
         mGMRarity = mDBFacade.gameMaster.rarityById.itemFor(mWeaponDetails.rarity);
         mActorGameObject = param2;
         mModifiers = new Vector.<GMModifier>();
         if(mWeaponDetails.modifier1 > 0)
         {
            mModifiers.push(mDBFacade.gameMaster.modifiersById.itemFor(mWeaponDetails.modifier1));
         }
         if(mWeaponDetails.modifier2 > 0)
         {
            mModifiers.push(mDBFacade.gameMaster.modifiersById.itemFor(mWeaponDetails.modifier2));
         }
         if(mWeaponDetails.legendarymodifier > 0)
         {
            mLegendaryModifier = mDBFacade.gameMaster.legendaryModifiersById.itemFor(mWeaponDetails.legendarymodifier);
         }
         updateStatsForModifiers();
         updateStatsForLegendaryModifier();
         mGMWeapon = mDBFacade.gameMaster.weaponItemById.itemFor(mWeaponDetails.type);
         mActorView = param3;
         mDistributedDungeonFloor = param5;
         mJsonObjs = new Vector.<Object>();
         mAttackTimelineMap = new Map();
         mWeaponAesthetic = mGMWeapon.getWeaponAesthetic(requiredLevel,mLegendaryModifier != null);
         mWeaponView = new WeaponView(mDBFacade,this);
      }
      
      public function updateStatsForModifiers() : void
      {
         for each(var _loc1_ in mModifiers)
         {
            mAttackSpeedModifier[0] *= _loc1_.MELEE_SPD;
            mAttackSpeedModifier[1] *= _loc1_.SHOOT_SPD;
            mAttackSpeedModifier[2] *= _loc1_.MAGIC_SPD;
            mManaModifier *= _loc1_.MP_COST;
            mChains += _loc1_.CHAIN;
            mPierces += _loc1_.PIERCE;
            mCooldownReduction *= _loc1_.COOLDOWN_REDUC;
            mChargeReduction *= _loc1_.CHARGE_REDUC;
            mCollisionScale = _loc1_.INCREASE_COLLISION;
         }
      }
      
      public function updateStatsForLegendaryModifier() : void
      {
         if(!mLegendaryModifier)
         {
         }
      }
      
      public function finalWeaponSpeedWithModifiers(param1:int) : Number
      {
         return attackSpeedModifier(param1) * this.weaponData.Speed;
      }
      
      public function attackSpeedModifier(param1:int) : Number
      {
         if(param1 >= 0 && param1 < 3)
         {
            return mAttackSpeedModifier[param1];
         }
         return 1;
      }
      
      public function get manaCostModifier() : Number
      {
         return mManaModifier;
      }
      
      public function get weaponView() : WeaponView
      {
         return mWeaponView;
      }
      
      public function get actorGameObject() : ActorGameObject
      {
         return mActorGameObject;
      }
      
      public function get weaponData() : GMWeaponItem
      {
         return mGMWeapon;
      }
      
      public function get weaponAesthetic() : GMWeaponAesthetic
      {
         return mWeaponAesthetic;
      }
      
      public function get modifierList() : Vector.<GMModifier>
      {
         return mModifiers;
      }
      
      public function get legendaryModifier() : GMLegendaryModifier
      {
         return mLegendaryModifier;
      }
      
      public function get name() : String
      {
         return mWeaponAesthetic.Name;
      }
      
      override public function destroy() : void
      {
         mDBFacade = null;
         mActorGameObject = null;
         mActorView = null;
         mDistributedDungeonFloor = null;
         mGMWeapon = null;
         mAttackTimelineMap.clear();
         mAttackTimelineMap = null;
         mWeaponView.destroy();
         mWeaponView = null;
         mModifiers = null;
         super.destroy();
      }
      
      public function get weaponCharge() : Number
      {
         return mWeaponCharge;
      }
      
      public function set weaponCharge(param1:Number) : void
      {
         mWeaponCharge = param1;
      }
      
      public function get type() : uint
      {
         return mWeaponDetails.type;
      }
      
      public function get power() : uint
      {
         return mWeaponDetails.power;
      }
      
      public function get slot() : int
      {
         return this.mSlot;
      }
      
      public function get requiredLevel() : int
      {
         return mWeaponDetails.requiredlevel;
      }
      
      public function get rarity() : int
      {
         return mWeaponDetails.rarity;
      }
      
      public function get gmRarity() : GMRarity
      {
         return mGMRarity;
      }
      
      public function chains() : Number
      {
         return mChains;
      }
      
      public function pierces() : Number
      {
         return mPierces;
      }
      
      public function cooldownReduction() : Number
      {
         return mCooldownReduction;
      }
      
      public function chargeReduction() : Number
      {
         return mChargeReduction;
      }
      
      public function collisionScale() : Number
      {
         return mCollisionScale;
      }
      
      public function getAttackTimeline(param1:uint) : AttackTimeline
      {
         var _loc2_:String = findTimelineNameFromAttackType(param1);
         var _loc3_:AttackTimeline = mAttackTimelineMap.itemFor(_loc2_);
         if(!_loc3_)
         {
            _loc3_ = mDBFacade.timelineFactory.createAttackTimeline(_loc2_,this,mActorGameObject,mDistributedDungeonFloor);
            mAttackTimelineMap.add(_loc2_,_loc3_);
         }
         return _loc3_;
      }
      
      protected function findTimelineNameFromAttackType(param1:uint) : String
      {
         var _loc2_:GMAttack = mDBFacade.gameMaster.attackById.itemFor(param1);
         if(_loc2_ == null)
         {
            return "";
         }
         return _loc2_.AttackTimeline;
      }
      
      public function isConsumable() : Boolean
      {
         return false;
      }
   }
}

