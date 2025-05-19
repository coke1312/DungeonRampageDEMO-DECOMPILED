package Actor.StateMachine.SubStateMachine
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Actor.StateMachine.ActorState;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Combat.Attack.ScriptTimeline;
   import Events.HeroOwnerEndedAttackStateEvent;
   import Facade.DBFacade;
   
   public class ActorChoreographySubState extends ActorState
   {
      
      public static const NAME:String = "ActorChoreographySubState";
      
      protected var mCurrentScript:ScriptTimeline;
      
      protected var mQueuedScript:ScriptTimeline;
      
      protected var mQueuedPlaySpeed:Number = 1;
      
      protected var mQueuedFinishedCallback:Function;
      
      protected var mQueuedStopCallback:Function;
      
      protected var mQueuedLoop:Boolean;
      
      protected var mQueuedTargetActor:ActorGameObject;
      
      protected var mEventComponent:EventComponent;
      
      public function ActorChoreographySubState(param1:DBFacade, param2:ActorGameObject, param3:ActorView, param4:Function = null)
      {
         super(param1,param2,param3,"ActorChoreographySubState",param4);
         mEventComponent = new EventComponent(mDBFacade);
      }
      
      public function setChoreography(param1:Number, param2:ActorGameObject, param3:ScriptTimeline, param4:Function = null, param5:Function = null, param6:Boolean = false) : void
      {
         mQueuedScript = param3;
         mQueuedPlaySpeed = param1;
         mQueuedFinishedCallback = param4;
         mQueuedStopCallback = param5;
         mQueuedLoop = param6;
         mQueuedTargetActor = param2;
      }
      
      override public function enterState() : void
      {
         super.enterState();
         if(mQueuedScript != null)
         {
            if(mCurrentScript != null)
            {
               mCurrentScript.stop();
            }
            mCurrentScript = mQueuedScript;
            mQueuedScript = null;
            mCurrentScript.play(mQueuedPlaySpeed,mQueuedTargetActor,mQueuedFinishedCallback,mQueuedStopCallback,mQueuedLoop);
         }
         else
         {
            Logger.error("No script in choreography!");
            mQueuedFinishedCallback();
         }
      }
      
      override public function exitState() : void
      {
         if(mActorGameObject.isOwner)
         {
            mEventComponent.dispatchEvent(new HeroOwnerEndedAttackStateEvent("PLAYER_ENDED_ATTACK_STATE"));
         }
         if(mCurrentScript != null)
         {
            if(mCurrentScript.isPlaying)
            {
               mCurrentScript.stop();
            }
            mCurrentScript = null;
         }
         super.exitState();
      }
      
      override public function destroy() : void
      {
         exitState();
      }
   }
}

