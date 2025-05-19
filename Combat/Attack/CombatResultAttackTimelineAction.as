package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Logger.Logger;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import GeneratedCode.CombatResult;
   
   public class CombatResultAttackTimelineAction extends AttackTimelineAction
   {
      
      protected var mDungeonFloor:DistributedDungeonFloor;
      
      public function CombatResultAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:CombatResult, param5:DistributedDungeonFloor)
      {
         super(param1,param2,param3);
         mCombatResult = param4;
         mDungeonFloor = param5;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         var _loc2_:ActorGameObject = mDungeonFloor.getActor(mCombatResult.attackee);
         if(_loc2_ == null)
         {
            Logger.warn("Tried to execute a combat result on an actor that is not on the dungeon floor.  Actor id: " + mCombatResult.attackee.toString());
            return;
         }
         _loc2_.ReceiveCombatResult(mCombatResult);
      }
   }
}

