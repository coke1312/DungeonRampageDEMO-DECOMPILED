package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class MovementAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "move";
      
      protected var mMovementType:String;
      
      public function MovementAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:String)
      {
         super(param1,param2,param3);
         mMovementType = param4;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : MovementAttackTimelineAction
      {
         var _loc5_:String = param4.movementType;
         return new MovementAttackTimelineAction(param1,param2,param3,_loc5_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mActorGameObject.movementControllerType = mMovementType;
      }
   }
}

