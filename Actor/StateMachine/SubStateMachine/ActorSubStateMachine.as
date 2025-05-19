package Actor.StateMachine.SubStateMachine
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Actor.StateMachine.ActorNavigationState;
   import Actor.StateMachine.ActorState;
   import Actor.StateMachine.ActorStateMachine;
   import Combat.Attack.ScriptTimeline;
   import Facade.DBFacade;
   
   public class ActorSubStateMachine extends ActorStateMachine
   {
      
      protected var mActorNavigationState:ActorNavigationState;
      
      protected var mActorChoreographyState:ActorChoreographySubState;
      
      public function ActorSubStateMachine(param1:DBFacade, param2:ActorGameObject, param3:ActorView)
      {
         super(param1,param2,param3);
         buildStates();
      }
      
      public function exit() : void
      {
         (this.currentState as ActorState).exitState();
         this.currentState = null;
      }
      
      private function buildStates() : void
      {
         mActorNavigationState = new ActorNavigationState(mDBFacade,mActorGameObject,mActorView);
         mActorChoreographyState = new ActorChoreographySubState(mDBFacade,mActorGameObject,mActorView);
      }
      
      public function enterNavigationState() : void
      {
         this.transitionToState(mActorNavigationState);
      }
      
      public function enterChoreographyState(param1:Number, param2:ActorGameObject, param3:ScriptTimeline, param4:Function = null, param5:Function = null, param6:Boolean = false) : void
      {
         var playSpeed:Number = param1;
         var targetActor:ActorGameObject = param2;
         var script:ScriptTimeline = param3;
         var finishedCallback:Function = param4;
         var stopCallback:Function = param5;
         var loop:Boolean = param6;
         var enterNavigationAndCallFinishedCallback:Function = function():void
         {
            enterNavigationState();
            if(finishedCallback != null)
            {
               finishedCallback();
            }
         };
         mActorChoreographyState.setChoreography(playSpeed,targetActor,script,enterNavigationAndCallFinishedCallback,stopCallback,loop);
         this.transitionToState(mActorChoreographyState);
      }
      
      override public function destroy() : void
      {
         if(this.currentState != null)
         {
            this.currentState.exitState();
         }
         this.currentState = null;
         mActorNavigationState.destroy();
         mActorNavigationState = null;
         mActorChoreographyState.destroy();
         mActorChoreographyState = null;
         super.destroy();
      }
   }
}

