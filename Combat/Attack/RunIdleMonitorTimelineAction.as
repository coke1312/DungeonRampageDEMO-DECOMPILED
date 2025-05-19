package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class RunIdleMonitorTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "runIdleMonitor";
      
      public function RunIdleMonitorTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : RunIdleMonitorTimelineAction
      {
         return new RunIdleMonitorTimelineAction(param1,param2,param3);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mActorGameObject.startRunIdleMonitoring();
      }
      
      override public function stop() : void
      {
         mActorGameObject.stopRunIdleMonitoring();
      }
   }
}

