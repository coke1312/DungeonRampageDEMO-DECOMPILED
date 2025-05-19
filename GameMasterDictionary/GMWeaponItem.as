package GameMasterDictionary
{
   import Brain.Logger.Logger;
   
   public class GMWeaponItem extends GMInventoryBase
   {
      
      public static const MELEE_WEAPON_SORT:Vector.<String> = new <String>["AXE_TYPE","HAMMER_TYPE","SWORD_TYPE","MEATCLEAVER_TYPE","COOKING_TYPE","FRYING_PAN_TYPE","KATANA_TYPE","SPEAR_TYPE","SHIELD_TYPE","FARMTOOL_TYPE","GREATSWORD_TYPE","FLAIL_TYPE","MACE_TYPE","LIGHT_SPEAR_TYPE","HEAVY_SPEAR_TYPE"];
      
      public static const SHOOTING_WEAPON_SORT:Vector.<String> = new <String>["BOW_TYPE","CROSSBOW_TYPE","PISTOL_TYPE","THROWING_TYPE","HEAVY_THROWING_TYPE","LIGHT_THROWING_TYPE","TRAP_TYPE","SEED_TYPE","THROWING_SPEAR_TYPE"];
      
      public static const MAGIC_WEAPON_SORT:Vector.<String> = new <String>["LIGHTNING_STAFF_TYPE","FIRE_STAFF_TYPE","STAFF_TYPE","LIGHTNING_MAGIC_TYPE","FIRE_MAGIC_TYPE","DARK_MAGIC_TYPE","SCROLL_TYPE","FIRE_RUNE_TYPE","FLAME_STAFF_TYPE","FIRE_GLOVE_TYPE","FIRE_ORB_TYPE","DRAGON_CHARM_TYPE"];
      
      public static const ALL_WEAPON_SORT:Vector.<String> = MELEE_WEAPON_SORT.concat(SHOOTING_WEAPON_SORT).concat(MAGIC_WEAPON_SORT);
      
      public var Release:String;
      
      public var ClassType:String;
      
      public var MasterType:String;
      
      public var DoNotDrop:Boolean;
      
      public var Power:uint;
      
      public var Speed:Number;
      
      public var ScalingFactor:Number;
      
      public var WeaponController:String;
      
      public var ControllerTimeTillEnd:Number;
      
      public var HoldingAttack:String;
      
      public var ChargeAttack:String;
      
      public var ScalingMaxPowerMultiplier:Number;
      
      public var ScaleTapAttack:Boolean;
      
      public var ScalingMinProjectiles:uint;
      
      public var ScalingMaxProjectiles:uint;
      
      public var ScalingProjectileStartAngle:Number;
      
      public var ScalingProjectileEndAngle:Number;
      
      public var ScalingDistanceTime:Number;
      
      public var ScalingHeroMinDistance:Number;
      
      public var ScalingHeroMaxDistance:Number;
      
      public var ScalingProjectileMinDistance:Number;
      
      public var ScalingProjectileMaxDistance:Number;
      
      public var RepeaterOnlyChargeRepeated:Boolean;
      
      public var RepeaterIncrementSpeedPercent:Number;
      
      public var RepeaterMaxSpeedPercent:Number;
      
      public var AbilityArray:Array;
      
      public var AttackArray:Array;
      
      public var PotentialModifiers:Vector.<GMModifier>;
      
      public var WeaponAestheticList:Vector.<GMWeaponAesthetic>;
      
      public var TapIcon:String;
      
      public var TapTitle:String;
      
      public var TapDescription:String;
      
      public var HoldIcon:String;
      
      public var HoldTitle:String;
      
      public var HoldDescription:String;
      
      public var ChooseRandomAttack:Boolean;
      
      public function GMWeaponItem(param1:Object)
      {
         super(param1);
         Release = param1.Release;
         ClassType = param1.ClassType;
         MasterType = param1.Mastertype;
         DoNotDrop = param1.DoNotDrop;
         Power = param1.Power;
         Speed = param1.Speed;
         ScalingFactor = param1.ScalingFactor;
         WeaponController = param1.WeaponController;
         ControllerTimeTillEnd = param1.ControllerTimeTillEnd;
         HoldingAttack = param1.HoldingAttack;
         ChargeAttack = param1.ChargeAttack != null ? param1.ChargeAttack : "";
         ScalingMaxPowerMultiplier = param1.ScalingMaxPowerMultiplier != null ? param1.ScalingMaxPowerMultiplier : 1;
         ScaleTapAttack = param1.ScaleTapAttack;
         ScalingMinProjectiles = param1.ScalingMinProjectileMultiplier != null ? param1.ScalingMinProjectileMultiplier : 1;
         ScalingMaxProjectiles = param1.ScalingMaxProjectileMultiplier != null ? param1.ScalingMaxProjectileMultiplier : 1;
         ScalingProjectileStartAngle = param1.ScalingProjectileStartAngle != null ? param1.ScalingProjectileStartAngle : 0;
         ScalingProjectileEndAngle = param1.ScalingProjectileEndAngle != null ? param1.ScalingProjectileEndAngle : 0;
         ScalingDistanceTime = param1.ScalingDistanceTime != null ? param1.ScalingDistanceTime : 0;
         ScalingHeroMinDistance = param1.ScalingHeroMinDistance != null ? param1.ScalingHeroMinDistance : 0;
         ScalingHeroMaxDistance = param1.ScalingHeroMaxDistance != null ? param1.ScalingHeroMaxDistance : 0;
         ScalingProjectileMinDistance = param1.ScalingProjectileMinDistance != null ? param1.ScalingProjectileMinDistance : 0;
         ScalingProjectileMaxDistance = param1.ScalingProjectileMaxDistance != null ? param1.ScalingProjectileMaxDistance : 0;
         RepeaterOnlyChargeRepeated = param1.RepeaterOnlyChargeRepeated;
         RepeaterIncrementSpeedPercent = param1.RepeaterIncrementSpeedPercent != null ? param1.RepeaterIncrementSpeedPercent : 0.5;
         RepeaterMaxSpeedPercent = param1.RepeaterMaxSpeedPercent != null ? param1.RepeaterMaxSpeedPercent : 3;
         TapIcon = param1.TapIcon;
         TapTitle = param1.TapTitle ? param1.TapTitle : "";
         TapDescription = param1.TapDescription ? param1.TapDescription : "";
         HoldIcon = param1.HoldIcon;
         HoldTitle = param1.HoldTitle ? param1.HoldTitle : "";
         HoldDescription = param1.HoldDescription ? param1.HoldDescription : "";
         AbilityArray = new Array(param1.Ability1,param1.Ability2,param1.Ability3,param1.Ability4,param1.Ability5);
         AttackArray = new Array(param1.Attack1,param1.Attack2,param1.Attack3,param1.Attack4,param1.Attack5,param1.Attack6,param1.Attack7,param1.Attack8,param1.Attack9,param1.Attack10);
         ChooseRandomAttack = param1.ChooseRandomAttack;
         WeaponAestheticList = new Vector.<GMWeaponAesthetic>();
         ItemCategory = "WEAPON";
         PotentialModifiers = new Vector.<GMModifier>();
      }
      
      public function getWeaponAesthetic(param1:uint, param2:Boolean = false) : GMWeaponAesthetic
      {
         var _loc3_:int = 0;
         if(WeaponAestheticList == null)
         {
            Logger.error("No weapon aesthetic list on weapon: " + this.Constant + ", id: " + this.Id);
            return null;
         }
         _loc3_ = 0;
         while(_loc3_ < WeaponAestheticList.length)
         {
            if(param2)
            {
               if(WeaponAestheticList[_loc3_].IsLegendary)
               {
                  return WeaponAestheticList[_loc3_];
               }
            }
            else if(param1 >= WeaponAestheticList[_loc3_].MinLevel && param1 <= WeaponAestheticList[_loc3_].MaxLevel)
            {
               return WeaponAestheticList[_loc3_];
            }
            _loc3_++;
         }
         if(param2)
         {
            return WeaponAestheticList[0];
         }
         Logger.error("Unable to find Weapon Aesthetic for weapon : " + this.Constant);
         return WeaponAestheticList[0];
      }
   }
}

