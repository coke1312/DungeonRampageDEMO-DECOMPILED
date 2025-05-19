package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import DistributedObjects.HeroGameObject;
   import Facade.DBFacade;
   
   public class AttackAutoMoveTimelineAction extends AutoMoveTimelineAction
   {
      
      public static const TYPE:String = "attackautomove";
      
      public function AttackAutoMoveTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade) : AttackAutoMoveTimelineAction
      {
         if(param1.isOwner)
         {
            return new AttackAutoMoveTimelineAction(param1,param2,param3);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         var _loc2_:AttackTimeline = null;
         mAttack = mDBFacade.gameMaster.attackById.itemFor(mAttackType);
         mDuration = mAttack.MoveDuration;
         mDistance = mAttack.MoveAmount;
         mAngle = mAttack.MoveAngle + mActorGameObject.heading;
         if(param1 is AttackTimeline)
         {
            _loc2_ = param1 as AttackTimeline;
            if(mActorGameObject is HeroGameObject)
            {
               mDuration = _loc2_.distanceScalingTime > 0 ? _loc2_.distanceScalingTime : mDuration;
               mDistance = _loc2_.distanceScalingHero > 0 ? _loc2_.distanceScalingHero : mDistance;
            }
         }
         if(mDuration > 0 && mDistance > 0)
         {
            super.execute(param1);
         }
      }
   }
}

