package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   
   public class BlockAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "block";
      
      private var mMaximumDotForBlocking:Number;
      
      private var mPreviousBlockValue:Number;
      
      public function BlockAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Number)
      {
         super(param1,param2,param3);
         mMaximumDotForBlocking = param4;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : BlockAttackTimelineAction
      {
         var _loc5_:Number = Number(param4.blockDot);
         return new BlockAttackTimelineAction(param1,param2,param3,_loc5_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         mActorGameObject.isBlocking = true;
         mActorGameObject.maximumDotForBlocking = mMaximumDotForBlocking;
         mPreviousBlockValue = mActorGameObject.maximumDotForBlocking;
      }
      
      override public function stop() : void
      {
         if(mActorGameObject)
         {
            mActorGameObject.maximumDotForBlocking = mPreviousBlockValue;
            mActorGameObject.isBlocking = false;
         }
         super.stop();
      }
   }
}

