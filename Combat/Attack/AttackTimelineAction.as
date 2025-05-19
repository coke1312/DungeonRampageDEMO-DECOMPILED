package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import GeneratedCode.CombatResult;
   
   public class AttackTimelineAction
   {
      
      protected var mActorGameObject:ActorGameObject;
      
      protected var mActorView:ActorView;
      
      protected var mDBFacade:DBFacade;
      
      protected var mAttackType:uint;
      
      protected var mCombatResult:CombatResult;
      
      protected var mAttacker:ActorGameObject;
      
      protected var mGMAttack:GMAttack;
      
      protected var mWorkComponent:LogicalWorkComponent;
      
      protected var mTimeline:ScriptTimeline;
      
      public function AttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super();
         mActorGameObject = param1;
         mActorView = param2;
         mDBFacade = param3;
         mWorkComponent = new LogicalWorkComponent(mDBFacade);
      }
      
      public function set attackType(param1:uint) : void
      {
         if(mAttackType != param1)
         {
            mAttackType = param1;
            mGMAttack = mDBFacade.gameMaster.attackById.itemFor(param1);
         }
      }
      
      public function set combatResult(param1:CombatResult) : void
      {
         mCombatResult = param1;
      }
      
      public function set attacker(param1:ActorGameObject) : void
      {
         mAttacker = param1;
      }
      
      public function execute(param1:ScriptTimeline) : void
      {
         mTimeline = param1;
      }
      
      public function destroy() : void
      {
         mActorGameObject = null;
         mActorView = null;
         mDBFacade = null;
         mCombatResult = null;
         mAttacker = null;
         mGMAttack = null;
         if(mWorkComponent)
         {
            mWorkComponent.destroy();
            mWorkComponent = null;
         }
      }
      
      public function stop() : void
      {
      }
   }
}

