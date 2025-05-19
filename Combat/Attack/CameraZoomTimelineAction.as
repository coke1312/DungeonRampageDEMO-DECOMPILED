package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.Task;
   import Facade.DBFacade;
   
   public class CameraZoomTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "zoom";
      
      private var mTask:Task;
      
      private var mDuration:Number = 0;
      
      private var mZoomFactor:Number = 1;
      
      private var mLerpInDuration:Number = 0;
      
      private var mLerpOutDuration:Number = 0;
      
      public function CameraZoomTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object)
      {
         super(param1,param2,param3);
         if(param4.duration == null)
         {
            Logger.error("CameraZoomTimelineAction: Must specify duration");
         }
         if(param4.zoomFactor == null)
         {
            Logger.error("CameraZoomTimelineAction: Must specify zoomFactor");
         }
         var _loc7_:uint = 24;
         mDuration = param4.duration / _loc7_;
         var _loc8_:Number = 0.63;
         var _loc6_:Number = 0.8666;
         var _loc5_:Number = (param4.zoomFactor - _loc6_) / _loc6_;
         mZoomFactor = _loc8_ * (1 + _loc5_);
         mLerpInDuration = param4.lerpInDuration != null ? param4.lerpInDuration / _loc7_ : 0;
         mLerpOutDuration = param4.lerpOutDuration != null ? param4.lerpOutDuration / _loc7_ : 0;
         if(mDuration < mLerpInDuration + mLerpOutDuration)
         {
            Logger.error("CameraZoomTimelineAction: duration must be >= lerp in + lerp out");
            mDuration = mLerpInDuration + mLerpOutDuration;
         }
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : CameraZoomTimelineAction
      {
         if(param1.isOwner)
         {
            return new CameraZoomTimelineAction(param1,param2,param3,param4);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         if(mLerpInDuration > 0)
         {
            this.mDBFacade.camera.tweenZoom(mLerpInDuration,mZoomFactor);
         }
         else
         {
            this.mDBFacade.camera.zoom = mZoomFactor;
         }
         mTask = mWorkComponent.doLater(mDuration - mLerpOutDuration,resetZoom);
      }
      
      private function resetZoom(param1:GameClock) : void
      {
         if(mLerpOutDuration > 0)
         {
            this.mDBFacade.camera.tweenToDefaultZoom(mLerpOutDuration);
         }
         else
         {
            this.mDBFacade.camera.zoom = this.mDBFacade.camera.defaultZoom;
         }
      }
      
      override public function destroy() : void
      {
         mWorkComponent.destroy();
         mWorkComponent = null;
         super.destroy();
      }
   }
}

