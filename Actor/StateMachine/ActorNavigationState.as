package Actor.StateMachine
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.WorkLoop.Task;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class ActorNavigationState extends ActorState
   {
      
      public static const NAME:String = "ActorNavigationState";
      
      protected var mUpdateTask:Task;
      
      public function ActorNavigationState(param1:DBFacade, param2:ActorGameObject, param3:ActorView, param4:Function = null)
      {
         super(param1,param2,param3,"ActorNavigationState",param4);
      }
      
      override public function enterState() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         super.enterState();
         mActorGameObject.startRunIdleMonitoring();
         if(mActorGameObject.isOwner)
         {
            _loc1_ = mActorGameObject as HeroGameObjectOwner;
            _loc1_.inputController.inputType = "free";
         }
         mActorGameObject.movementControllerType = "normal";
      }
      
      override public function exitState() : void
      {
         mActorGameObject.stopRunIdleMonitoring();
         super.exitState();
      }
   }
}

