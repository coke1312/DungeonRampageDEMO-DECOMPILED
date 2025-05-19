package Actor.StateMachine
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Logger.Logger;
   import Combat.Attack.AttackTimeline;
   import Combat.Attack.ScriptTimeline;
   import Facade.DBFacade;
   import GeneratedCode.AttackChoreography;
   import GeneratedCode.CombatResult;
   
   public class ActorMacroStateMachine extends ActorStateMachine
   {
      
      protected var mDefaultState:ActorDefaultState;
      
      protected var mDeadState:ActorDeadState;
      
      public function ActorMacroStateMachine(param1:DBFacade, param2:ActorGameObject, param3:ActorView)
      {
         super(param1,param2,param3);
         mDefaultState = new ActorDefaultState(mDBFacade,mActorGameObject,mActorView);
         mDeadState = new ActorDeadState(mDBFacade,mActorGameObject,mActorView);
      }
      
      public function enterAttackChoreographyState(param1:Number, param2:ActorGameObject, param3:AttackTimeline, param4:AttackChoreography, param5:Function = null, param6:Function = null, param7:Boolean = false) : void
      {
         param3.appendChoreography(param4);
         var _loc8_:Boolean = param4.loop == 1 ? true : false;
         param3.currentAttackType = param4.attack.attackType;
         param3.projectileMultiplier = param4.scalingMaxProjectiles;
         enterChoreographyState(param1,param2,param3,param5,param6,param7);
      }
      
      public function enterCombatResultChoreographyState(param1:Number, param2:ActorGameObject, param3:ScriptTimeline, param4:CombatResult, param5:ActorGameObject, param6:Function = null, param7:Function = null, param8:Boolean = false) : void
      {
         param3.currentAttackType = param4.attack.attackType;
         param3.currentCombatResult = param4;
         param3.currentAttacker = param5;
         enterChoreographyState(param1,param2,param3,param6,param7,param8);
      }
      
      public function enterChoreographyState(param1:Number, param2:ActorGameObject, param3:ScriptTimeline, param4:Function = null, param5:Function = null, param6:Boolean = false, param7:Boolean = false) : void
      {
         var _loc8_:ActorDefaultState = null;
         if(this.currentState == mDefaultState)
         {
            _loc8_ = this.currentState as ActorDefaultState;
            param3.autoAim = param7;
            _loc8_.enterChoreographyState(param1,param2,param3,param4,param5,param6);
         }
         else
         {
            Logger.warn("Trying to enter a choreographyState when the macro state is not in the default state.");
         }
      }
      
      public function enterNavigationState() : void
      {
         var _loc1_:ActorDefaultState = null;
         if(this.currentState == mDefaultState)
         {
            _loc1_ = this.currentState as ActorDefaultState;
            _loc1_.enterNavigationState();
         }
         else
         {
            Logger.warn("Trying to enter a choreographyState when the macro state is not in the default state.");
         }
      }
      
      public function get currentSubState() : ActorState
      {
         if(this.currentState as ActorState == mDefaultState)
         {
            return mDefaultState.currentSubState;
         }
         return null;
      }
      
      public function enterDeadState(param1:Function) : void
      {
         mDeadState.finishedCallback = param1;
         this.transitionToState(mDeadState);
      }
      
      public function enterDefaultState() : void
      {
         this.transitionToState(mDefaultState);
      }
      
      override public function destroy() : void
      {
         mDefaultState.destroy();
         mDefaultState = null;
         mDeadState.destroy();
         mDeadState = null;
         super.destroy();
      }
   }
}

