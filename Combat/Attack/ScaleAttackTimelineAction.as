package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class ScaleAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "scale";
      
      private var originalScaleValue:Number;
      
      private var scaleValue:Number;
      
      public function ScaleAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:Number, param4:DBFacade)
      {
         super(param1,param2,param4);
         scaleValue = param3;
         originalScaleValue = param2.root.scaleX;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : ScaleAttackTimelineAction
      {
         var _loc5_:Number = Number(param4.value);
         return new ScaleAttackTimelineAction(param1,param2,_loc5_,param3);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mActorView.root.scaleX = mActorView.root.scaleY = scaleValue;
      }
      
      override public function stop() : void
      {
         mActorView.root.scaleX = mActorView.root.scaleY = originalScaleValue;
         super.stop();
      }
   }
}

