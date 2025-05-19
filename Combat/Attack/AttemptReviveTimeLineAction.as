package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Clock.GameClock;
   import Brain.WorkLoop.Task;
   import Facade.DBFacade;
   
   public class AttemptReviveTimeLineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "attemptRevive";
      
      private var mKeyboardCheckTask:Task;
      
      private var mDeltaPerFrame:Number;
      
      public function AttemptReviveTimeLineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : AttemptReviveTimeLineAction
      {
         return new AttemptReviveTimeLineAction(param1,param2,param3);
      }
      
      private function keyboardCheck(param1:GameClock) : void
      {
         if(!mDBFacade.inputManager.check(32) || !this.mTimeline.targetActor.isInReviveState())
         {
            mTimeline.stop();
         }
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mKeyboardCheckTask = mWorkComponent.doEveryFrame(keyboardCheck);
      }
      
      override public function stop() : void
      {
         if(mKeyboardCheckTask)
         {
            mKeyboardCheckTask.destroy();
            mKeyboardCheckTask = null;
         }
      }
   }
}

