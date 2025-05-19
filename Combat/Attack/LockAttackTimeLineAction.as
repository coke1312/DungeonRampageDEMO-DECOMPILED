package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class LockAttackTimeLineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "lockAttack";
      
      private var mHeroGameObjectOwner:HeroGameObjectOwner;
      
      public function LockAttackTimeLineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
         mHeroGameObjectOwner = null;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade) : LockAttackTimeLineAction
      {
         return new LockAttackTimeLineAction(param1,param2,param3);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mHeroGameObjectOwner = mActorGameObject as HeroGameObjectOwner;
         if(mHeroGameObjectOwner != null)
         {
            mHeroGameObjectOwner.canInitiateAnAttack = false;
         }
      }
      
      override public function stop() : void
      {
         if(mHeroGameObjectOwner != null)
         {
            mHeroGameObjectOwner.canInitiateAnAttack = true;
         }
         super.stop();
      }
   }
}

