package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.Task;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import flash.geom.Vector3D;
   
   public class AutoMoveTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "automove";
      
      private var mTask:Task;
      
      protected var mAttack:GMAttack;
      
      protected var mDistance:Number;
      
      protected var mDuration:Number;
      
      protected var mAngle:Number;
      
      public function AutoMoveTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade) : AutoMoveTimelineAction
      {
         if(param1.isOwner)
         {
            return new AutoMoveTimelineAction(param1,param2,param3);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         var _loc4_:HeroGameObjectOwner = HeroGameObjectOwner(mActorGameObject);
         if(mDuration <= 0 || isNaN(mAngle))
         {
            Logger.warn("Invalid data for AutoMoveTimelineAction. mDistance: " + mDistance + " mDuration: " + mDuration + " mAngle: " + mAngle + " attack: " + mAttackType);
            return;
         }
         var _loc5_:Number = mDistance / mDuration;
         var _loc3_:Number = mAngle * 3.141592653589793 / 180;
         var _loc2_:Vector3D = new Vector3D(Math.cos(_loc3_) * _loc5_,Math.sin(_loc3_) * _loc5_);
         _loc4_.autoMoveVelocity = _loc2_;
         mTask = mWorkComponent.doLater(mDuration,resetVelocity);
      }
      
      private function resetVelocity(param1:GameClock) : void
      {
         var _loc2_:HeroGameObjectOwner = HeroGameObjectOwner(mActorGameObject);
         _loc2_.autoMoveVelocity.scaleBy(0);
      }
      
      override public function destroy() : void
      {
         if(mTask)
         {
            resetVelocity(null);
            mTask.destroy();
            mTask = null;
         }
         super.destroy();
      }
   }
}

