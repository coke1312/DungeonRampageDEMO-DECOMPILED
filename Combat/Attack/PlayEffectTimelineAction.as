package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   
   public class PlayEffectTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "effect";
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mDistributedDungeonFloor:DistributedDungeonFloor;
      
      protected var mEffectName:String;
      
      protected var mEffectPath:String;
      
      protected var mXOffset:Number;
      
      protected var mYOffset:Number;
      
      protected var mHeadingOffset:Number;
      
      protected var mHeadingOffsetAngle:Number;
      
      protected var mParentToActor:Boolean;
      
      protected var mPlayAtTarget:Boolean;
      
      protected var mBehindAvatar:Boolean;
      
      protected var mScale:Number;
      
      protected var mAutoAdjustHeading:Boolean;
      
      protected var mLoop:Boolean;
      
      protected var mLayer:String;
      
      protected var mPlayRate:Number;
      
      protected var mUseTimelineSpeed:Boolean;
      
      protected var mInsertParentName:String;
      
      protected var mInsertIconPath:String;
      
      protected var mInsertIconName:String;
      
      protected var mInsertIconClip:MovieClip;
      
      protected var mInsertParentClip:MovieClip;
      
      protected var mDoIconInsert:Boolean;
      
      public var mManaged:Boolean;
      
      protected var mInvertAngles:Boolean = false;
      
      public function PlayEffectTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:String, param5:String, param6:Number = 0, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Number = 1, param14:Boolean = false, param15:Boolean = false, param16:String = "sorted", param17:Boolean = false, param18:Boolean = false, param19:Boolean = false, param20:String = "", param21:String = "", param22:String = "")
      {
         super(param1,param2,param3);
         mEffectName = param4;
         mEffectPath = param5;
         mXOffset = param6;
         mYOffset = param7;
         mHeadingOffset = param8;
         mHeadingOffsetAngle = param9;
         mPlayAtTarget = param10;
         mParentToActor = param11;
         mBehindAvatar = param12;
         mScale = param13;
         mAutoAdjustHeading = param14;
         mLoop = param15;
         mLayer = param16 != null ? param16 : "sorted";
         mManaged = param17;
         if(!mScale)
         {
            mScale = 1;
         }
         mPlayRate = 1;
         mUseTimelineSpeed = false;
         if(param18)
         {
            mUseTimelineSpeed = true;
         }
         mInvertAngles = param19;
         mInsertParentName = param20;
         mInsertIconPath = param21;
         mInsertIconName = param22;
         mDoIconInsert = mInsertParentName != null && mInsertIconPath != null && mInsertIconName != null;
         if(mDoIconInsert)
         {
            mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(mInsertIconPath),iconAssetLoaded(this));
         }
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : PlayEffectTimelineAction
      {
         return new PlayEffectTimelineAction(param1,param2,param3,param4.name,param4.path,param4.xOffset,param4.yOffset,param4.headingOffset,param4.headingOffsetAngle,param4.playAtTarget,param4.parentToActor,param4.behindAvatar,param4.scale,param4.autoAdjustHeading,param4.loop,param4.layer,param4.managed,param4.useTimelineSpeed,param4.invertAngles,param4.insertParentName,param4.insertIconPath,param4.insertIconName);
      }
      
      override public function destroy() : void
      {
         mDistributedDungeonFloor = null;
         mInsertIconClip = null;
         mInsertParentName = "";
         mInsertIconName = "";
         super.destroy();
         if(mAssetLoadingComponent != null)
         {
            mAssetLoadingComponent.destroy();
            mAssetLoadingComponent = null;
         }
      }
      
      protected function TryInsertClipIntoEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(mInsertIconClip != null && mInsertParentClip != null)
         {
            if(mInsertParentClip.getChildByName(mInsertParentName) == null)
            {
               Logger.warn("mInsertParentClip.getChildByName( " + mInsertParentClip + " ) == null");
               return;
            }
            _loc1_ = MovieClip(mInsertParentClip.getChildByName(mInsertParentName));
            if(_loc1_ == null)
            {
               Logger.warn("parentNameMovieClip == null");
               return;
            }
            while(_loc1_.numChildren > 0)
            {
               _loc1_.removeChildAt(0);
            }
            _loc1_.addChild(mInsertIconClip);
         }
      }
      
      private function iconAssetLoaded(param1:PlayEffectTimelineAction) : Function
      {
         var timeline_action:PlayEffectTimelineAction = param1;
         return function(param1:SwfAsset):void
         {
            var _loc2_:Class = param1.getClass(timeline_action.mInsertIconName);
            if(_loc2_ == null)
            {
               Logger.error("Unable to find class: " + timeline_action.mInsertIconName);
               return;
            }
            timeline_action.mInsertIconClip = new _loc2_();
            timeline_action.mInsertIconClip.mouseChildren = false;
            timeline_action.mInsertIconClip.mouseEnabled = false;
            timeline_action.TryInsertClipIntoEffect();
         };
      }
      
      protected function assetLoadedCallback(param1:PlayEffectTimelineAction) : Function
      {
         var timeline_action:PlayEffectTimelineAction = param1;
         return function(param1:MovieClip):void
         {
            timeline_action.mInsertParentClip = param1;
            timeline_action.TryInsertClipIntoEffect();
         };
      }
      
      public function calculateHeadingOffset(param1:Number, param2:Number, param3:Vector3D, param4:Number = 0) : Vector3D
      {
         param2 += param4;
         if(param2 < 0)
         {
            param2 = 360 + param2;
         }
         param2 = convertToRadians(param2);
         var _loc5_:Vector3D = new Vector3D(0,0,0);
         _loc5_.x = param3.x + param1 * Math.cos(param2);
         _loc5_.y = param3.y + param1 * Math.sin(param2);
         return _loc5_;
      }
      
      private function convertToRadians(param1:Number) : Number
      {
         return param1 * 3.141592653589793 / 180;
      }
      
      public function get useTimelineSpeed() : Boolean
      {
         return mUseTimelineSpeed;
      }
      
      public function calculatePositionBasedOnOffsets(param1:ActorGameObject) : Vector3D
      {
         var _loc3_:Vector3D = null;
         var _loc2_:Vector3D = new Vector3D(0,0,0);
         if(mPlayAtTarget)
         {
            _loc2_ = param1.position;
         }
         else
         {
            _loc3_ = new Vector3D(0,0,0);
            if(!mParentToActor)
            {
               if(mHeadingOffset)
               {
                  _loc3_ = mActorGameObject.position;
               }
               else
               {
                  _loc2_ = mActorGameObject.position;
               }
            }
            if(!mHeadingOffsetAngle)
            {
               mHeadingOffsetAngle = 0;
            }
            if(mHeadingOffset)
            {
               _loc2_ = calculateHeadingOffset(mHeadingOffset,mActorGameObject.heading,_loc3_,mHeadingOffsetAngle);
            }
         }
         if(!mYOffset)
         {
            mYOffset = 0;
         }
         if(!mXOffset)
         {
            mXOffset = 0;
         }
         _loc2_.y += mYOffset;
         _loc2_.x += mXOffset;
         return _loc2_;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         if(mPlayAtTarget && param1.targetActor == null)
         {
            return;
         }
         mPlayRate = param1.playSpeed;
         var _loc2_:ActorGameObject = null;
         if(mParentToActor)
         {
            _loc2_ = mActorGameObject;
         }
         var _loc3_:Vector3D = calculatePositionBasedOnOffsets(param1.targetActor);
         var _loc4_:uint = mActorGameObject.distributedDungeonFloor.effectManager.playEffect(DBFacade.buildFullDownloadPath(mEffectPath),mEffectName,_loc3_,_loc2_,mBehindAvatar,mScale,0,0,0,0,false,mLayer,mManaged,mPlayRate,mDoIconInsert ? assetLoadedCallback(this) : null);
         if(mManaged)
         {
            param1.mManagedEffects.add(_loc4_);
         }
      }
   }
}

