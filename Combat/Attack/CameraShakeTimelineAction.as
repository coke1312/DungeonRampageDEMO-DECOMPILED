package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   
   public class CameraShakeTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "shake";
      
      private var mDuration:Number = 0;
      
      private var mNumShakes:uint = 0;
      
      private var mRotation:Number = 0;
      
      private var mX:Number = 0;
      
      private var mY:Number = 0;
      
      public function CameraShakeTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object)
      {
         super(param1,param2,param3);
         if(param4.duration == null)
         {
            Logger.error("CameraShakeTimelineAction: Must specify duration");
         }
         if(param4.numShakes == null)
         {
            Logger.error("CameraShakeTimelineAction: Must specify numShakes");
         }
         if(param4.rotation == null && param4.x == null && param4.y == null)
         {
            Logger.error("CameraShakeTimelineAction: Must specify at least one of rotation, x, or y");
         }
         var _loc5_:uint = 24;
         mDuration = param4.duration / _loc5_;
         mNumShakes = param4.numShakes;
         mRotation = param4.rotation;
         mX = param4.x;
         mY = param4.y;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : CameraShakeTimelineAction
      {
         if(param1.isOwner || param1.actorData.gMActor.CanShakeCamera)
         {
            return new CameraShakeTimelineAction(param1,param2,param3,param4);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         if(mRotation)
         {
            this.mDBFacade.camera.shakeRotation(mDuration,mRotation,mNumShakes);
         }
         if(mX)
         {
            this.mDBFacade.camera.shakeX(mDuration,mX,mNumShakes);
         }
         if(mY)
         {
            this.mDBFacade.camera.shakeY(mDuration,mY,mNumShakes);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

