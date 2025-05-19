package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class PlayAnimationAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "playAnim";
      
      protected var mAnimName:String;
      
      public var mStartFrame:uint;
      
      protected var mScriptTimeline:ScriptTimeline;
      
      public function PlayAnimationAttackTimelineAction(param1:ScriptTimeline, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:String, param6:uint)
      {
         super(param2,param3,param4);
         mStartFrame = param6;
         mAnimName = param5;
         mScriptTimeline = param1;
      }
      
      public static function buildFromJson(param1:ScriptTimeline, param2:ActorGameObject, param3:ActorView, param4:DBFacade, param5:Object) : PlayAnimationAttackTimelineAction
      {
         var _loc7_:String = param5.animName;
         var _loc6_:uint = uint(param5.startFrame);
         return new PlayAnimationAttackTimelineAction(param1,param2,param3,param4,_loc7_,_loc6_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mActorView.playAnim(mAnimName,mStartFrame,true,false,mScriptTimeline.playSpeed);
      }
   }
}

