package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class HideTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "visible";
      
      protected var value:Boolean = false;
      
      public function HideTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object)
      {
         super(param1,param2,param3);
         value = param4.value;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : HideTimelineAction
      {
         return new HideTimelineAction(param1,param2,param3,param4);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mActorGameObject.view.root.visible = value;
      }
      
      override public function stop() : void
      {
         mActorGameObject.view.root.visible = true;
      }
   }
}

