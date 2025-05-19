package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.Task;
   import Facade.DBFacade;
   
   public class TimeScaleTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "timeScale";
      
      private var mTask:Task;
      
      private var mDuration:Number = 0;
      
      private var mTimeScale:Number = 1;
      
      public function TimeScaleTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object)
      {
         super(param1,param2,param3);
         if(param4.duration == null)
         {
            Logger.error("TimeScaleTimelineAction: Must specify duration");
         }
         if(param4.timeScale == null)
         {
            Logger.error("TimeScaleTimelineAction: Must specify timeScale");
         }
         var _loc5_:uint = 24;
         mDuration = param4.duration / _loc5_;
         mTimeScale = param4.timeScale;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : TimeScaleTimelineAction
      {
         if(param1.isOwner)
         {
            return new TimeScaleTimelineAction(param1,param2,param3,param4);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         this.mDBFacade.gameClock.timeScale = mTimeScale;
         mTask = mWorkComponent.doLater(mDuration,resetTimeScale);
      }
      
      private function resetTimeScale(param1:GameClock) : void
      {
         this.mDBFacade.gameClock.timeScale = 1;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function stop() : void
      {
         this.mDBFacade.gameClock.timeScale = 1;
         if(mTask)
         {
            mTask.destroy();
            mTask = null;
         }
      }
   }
}

