package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class GotoTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "goto";
      
      private var mGotoFrame:int;
      
      private var mGotoFunction:Function;
      
      public function GotoTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object, param5:Function)
      {
         super(param1,param2,param3);
         mGotoFrame = param4.gotoFrame;
         mGotoFunction = param5;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object, param5:Function) : GotoTimelineAction
      {
         return new GotoTimelineAction(param1,param2,param3,param4,param5);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mGotoFunction(mGotoFrame);
      }
   }
}

