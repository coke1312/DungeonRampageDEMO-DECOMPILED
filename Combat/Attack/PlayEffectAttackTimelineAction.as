package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import GameMasterDictionary.GMWeaponAesthetic;
   import flash.geom.Vector3D;
   
   public class PlayEffectAttackTimelineAction extends PlayEffectTimelineAction
   {
      
      public static const TYPE:String = "attackEffect";
      
      public static const SWING_RIGHT:String = "attack_swingRight";
      
      public static const SWING_LEFT:String = "attack_swingLeft";
      
      public static const SWORD_TRAIL_DEFAULT_PREFIX:String = "db_fx_attack";
      
      protected var mActorPos:Vector3D;
      
      protected var mChargeTime:Number;
      
      protected var mWeapon:WeaponGameObject;
      
      protected var mRegisterChargeEffectCallback:Function;
      
      public function PlayEffectAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:DistributedDungeonFloor, param5:WeaponGameObject, param6:Function, param7:String, param8:String, param9:Number = 0, param10:Number = 0, param11:Number = 0, param12:Number = 0, param13:Boolean = false, param14:Boolean = false, param15:Boolean = false, param16:Number = 1, param17:Boolean = false, param18:Boolean = false, param19:String = "sorted", param20:Boolean = false, param21:Boolean = false, param22:Boolean = false, param23:String = "", param24:String = "", param25:String = "")
      {
         super(param1,param2,param3,param7,param8,param9,param10,param11,param12,param13,param14,param15,param16,param17,param18,param19,param20,param21,param22,param23,param24,param25);
         mDistributedDungeonFloor = param4;
         mWeapon = param5;
         var _loc26_:Number = mWeapon != null ? mWeapon.collisionScale() : 1;
         mScale *= _loc26_;
         mXOffset *= _loc26_;
         mYOffset *= _loc26_;
         mRegisterChargeEffectCallback = param6;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:DistributedDungeonFloor, param5:Object, param6:WeaponGameObject, param7:Function) : PlayEffectAttackTimelineAction
      {
         return new PlayEffectAttackTimelineAction(param1,param2,param3,param4,param6,param7,param5.name,param5.path,param5.xOffset,param5.yOffset,param5.headingOffset,param5.headingOffsetAngle,param5.playAtTarget,param5.parentToActor,param5.behindAvatar,param5.scale,param5.autoAdjustHeading,param5.loop,param5.layer,param5.managed,param5.useTimelineSpeed,param5.invertAngles,param5.insertParentName,param5.insertIconPath,param5.insertIconName);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         var _loc5_:GMWeaponAesthetic = null;
         if(mPlayAtTarget && param1.targetActor == null)
         {
            return;
         }
         if(useTimelineSpeed)
         {
            mPlayRate = param1.playSpeed;
         }
         var _loc3_:ActorGameObject = null;
         if(mParentToActor)
         {
            _loc3_ = mActorGameObject;
         }
         var _loc4_:Vector3D = calculatePositionBasedOnOffsets(param1.targetActor);
         var _loc10_:String = mEffectName.substring();
         var _loc7_:Number = mActorGameObject.heading;
         var _loc2_:* = 0;
         var _loc9_:Number = 0;
         if(mAutoAdjustHeading)
         {
            _loc2_ = _loc7_;
         }
         var _loc6_:Object = {};
         if(mInvertAngles)
         {
            _loc7_ += 180;
         }
         if(mEffectName.indexOf("_angle") >= 0)
         {
            if(mActorGameObject.currentWeapon)
            {
               _loc5_ = mActorGameObject.currentWeapon.weaponAesthetic;
            }
            if(_loc5_ && _loc5_.SwordTrailOverride)
            {
               _loc10_ = _loc10_.replace("db_fx_attack",_loc5_.SwordTrailOverride);
            }
            _loc6_ = convertAngleForEffectName(_loc7_);
            _loc10_ += _loc6_.string;
            if(_loc10_.indexOf("swing_angle") >= 0)
            {
               if(mActorGameObject.actorView.currentAnim == "attack_swingRight")
               {
                  _loc10_ += "_right";
               }
               else
               {
                  _loc10_ += "_left";
               }
            }
         }
         if(_loc6_.flip)
         {
            _loc9_ = 180;
         }
         var _loc8_:uint = 0;
         _loc8_ = mActorGameObject.distributedDungeonFloor.effectManager.playEffect(DBFacade.buildFullDownloadPath(mEffectPath),_loc10_,_loc4_,_loc3_,mBehindAvatar,mScale,0,0,_loc9_,_loc2_,mLoop,mLayer,mManaged,mPlayRate,mDoIconInsert ? assetLoadedCallback(this) : null);
         if(mManaged)
         {
            param1.mManagedEffects.add(_loc8_);
         }
      }
      
      public function convertAngleForEffectName(param1:int) : Object
      {
         var _loc3_:Object = {
            "string":"",
            "flip":true
         };
         if(param1 < 0)
         {
            param1 = 360 + param1;
         }
         var _loc2_:int = param1 % 45;
         if(_loc2_ > 22)
         {
            param1 += 45 - _loc2_;
         }
         else
         {
            param1 -= _loc2_;
         }
         if(param1 == 0 || param1 == 360)
         {
            _loc3_.string = "180";
         }
         else if(param1 == 45)
         {
            _loc3_.string = "135";
         }
         else if(param1 == 315)
         {
            _loc3_.string = "225";
         }
         else
         {
            _loc3_.flip = false;
            _loc3_.string = param1.toString();
         }
         return _loc3_;
      }
      
      override public function destroy() : void
      {
         mRegisterChargeEffectCallback = null;
         mWeapon = null;
         super.destroy();
      }
   }
}

