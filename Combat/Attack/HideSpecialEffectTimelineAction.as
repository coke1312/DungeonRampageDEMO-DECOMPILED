package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class HideSpecialEffectTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "hideSpecialEffect";
      
      public function HideSpecialEffectTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : HideSpecialEffectTimelineAction
      {
         return new HideSpecialEffectTimelineAction(param1,param2,param3);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mActorView.hideSpecialEffect();
      }
      
      override public function stop() : void
      {
         mActorView.showSpecialEffect();
         super.stop();
      }
   }
}

