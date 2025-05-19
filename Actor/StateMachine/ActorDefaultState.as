package Actor.StateMachine
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Actor.StateMachine.SubStateMachine.ActorSubStateMachine;
   import Combat.Attack.ScriptTimeline;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class ActorDefaultState extends ActorState
   {
      
      public static const NAME:String = "ActorDefaultState";
      
      private var mSubStateMachine:ActorSubStateMachine;
      
      public function ActorDefaultState(param1:DBFacade, param2:ActorGameObject, param3:ActorView, param4:Function = null)
      {
         super(param1,param2,param3,"ActorDefaultState",param4);
         mSubStateMachine = new ActorSubStateMachine(param1,param2,param3);
      }
      
      override public function enterState() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         super.enterState();
         if(mActorGameObject.isOwner)
         {
            _loc1_ = mActorGameObject as HeroGameObjectOwner;
            _loc1_.startUserInput();
         }
         mSubStateMachine.enterNavigationState();
      }
      
      override public function exitState() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         mSubStateMachine.exit();
         if(mActorGameObject.isOwner)
         {
            _loc1_ = mActorGameObject as HeroGameObjectOwner;
            _loc1_.stopUserInput();
         }
         super.exitState();
      }
      
      public function enterChoreographyState(param1:Number, param2:ActorGameObject, param3:ScriptTimeline, param4:Function = null, param5:Function = null, param6:Boolean = false) : void
      {
         mSubStateMachine.enterChoreographyState(param1,param2,param3,param4,param5,param6);
      }
      
      public function enterNavigationState() : void
      {
         mSubStateMachine.enterNavigationState();
      }
      
      public function get currentSubState() : ActorState
      {
         return mSubStateMachine.currentState as ActorState;
      }
      
      override public function destroy() : void
      {
         mSubStateMachine.destroy();
         mSubStateMachine = null;
         super.destroy();
      }
   }
}

