package Actor.Player
{
   import Actor.ActorView;
   import Actor.StateMachine.ActorMacroStateMachine;
   import Actor.StateMachine.ActorReviveState;
   import DistributedObjects.HeroGameObject;
   import Facade.DBFacade;
   
   public class HeroStateMachine extends ActorMacroStateMachine
   {
      
      protected var mReviveState:ActorReviveState;
      
      public function HeroStateMachine(param1:DBFacade, param2:HeroGameObject, param3:ActorView)
      {
         super(param1,param2,param3);
         mReviveState = new ActorReviveState(mDBFacade,param2,mActorView);
      }
      
      override public function destroy() : void
      {
         mReviveState.destroy();
         super.destroy();
      }
      
      public function enterReviveState() : void
      {
         this.transitionToState(mReviveState);
      }
   }
}

