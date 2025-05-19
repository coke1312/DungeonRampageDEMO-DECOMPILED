package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class AnimationFrameAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "animFrame";
      
      protected var mAnimName:String;
      
      public var mFrameNumber:uint;
      
      public function AnimationFrameAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:String, param5:uint)
      {
         super(param1,param2,param3);
         mFrameNumber = param5;
         mAnimName = param4;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : AnimationFrameAttackTimelineAction
      {
         var _loc6_:String = param4.animName;
         var _loc5_:uint = uint(param4.frame);
         return new AnimationFrameAttackTimelineAction(param1,param2,param3,_loc6_,_loc5_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mActorView.setAnimAt(mAnimName,mFrameNumber);
      }
   }
}

