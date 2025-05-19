package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class KnockbackImmunityTimeLineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "knockbackImmunity";
      
      private var mHeroGameObjectOwner:HeroGameObjectOwner;
      
      private var mCanBeKnockedBack:Boolean;
      
      private var mCanBeKnockedBack_original:Boolean;
      
      public function KnockbackImmunityTimeLineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Boolean)
      {
         super(param1,param2,param3);
         mHeroGameObjectOwner = null;
         mCanBeKnockedBack = param4;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : KnockbackImmunityTimeLineAction
      {
         var _loc5_:Boolean = Boolean(param4.value);
         return new KnockbackImmunityTimeLineAction(param1,param2,param3,_loc5_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mHeroGameObjectOwner = mActorGameObject as HeroGameObjectOwner;
         if(mHeroGameObjectOwner != null)
         {
            mCanBeKnockedBack_original = mHeroGameObjectOwner.canBeKnockedBack;
            mHeroGameObjectOwner.canBeKnockedBack = mCanBeKnockedBack;
         }
      }
      
      override public function stop() : void
      {
         if(mHeroGameObjectOwner != null)
         {
            mHeroGameObjectOwner.canBeKnockedBack = mCanBeKnockedBack_original;
         }
         mHeroGameObjectOwner = null;
         super.stop();
      }
   }
}

