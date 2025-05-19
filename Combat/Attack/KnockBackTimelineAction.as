package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import flash.geom.Vector3D;
   
   public class KnockBackTimelineAction extends AutoMoveTimelineAction
   {
      
      public static const TYPE:String = "knockback";
      
      public function KnockBackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade) : KnockBackTimelineAction
      {
         if(param1.isOwner)
         {
            return new KnockBackTimelineAction(param1,param2,param3);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:GMAttack = mDBFacade.gameMaster.attackById.itemFor(mAttackType);
         if(_loc3_ && mAttacker != null)
         {
            mDistance = _loc3_.Knockback;
            mDuration = _loc3_.KnockbackDur;
            _loc2_ = new Vector3D(mActorGameObject.worldCenter.x - mAttacker.worldCenter.x,mActorGameObject.worldCenter.y - mAttacker.worldCenter.y);
            mAngle = Math.atan2(_loc2_.y,_loc2_.x) * 180 / 3.141592653589793;
         }
         if(mDuration > 0)
         {
            super.execute(param1);
         }
      }
   }
}

