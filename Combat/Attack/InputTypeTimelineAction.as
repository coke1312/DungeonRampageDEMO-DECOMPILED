package Combat.Attack
{
   import Actor.ActorView;
   import Brain.Logger.Logger;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class InputTypeTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "inputType";
      
      private var mHeroGameObjectOwner:HeroGameObjectOwner;
      
      private var mInputType:String;
      
      public function InputTypeTimelineAction(param1:HeroGameObjectOwner, param2:ActorView, param3:DBFacade, param4:String)
      {
         super(param1,param2,param3);
         mHeroGameObjectOwner = param1;
         mInputType = param4;
         if(mHeroGameObjectOwner == null)
         {
            Logger.error("ActorGameObject passed into InputTypeTimelineAction is not a HeroGameObjectOwner.");
         }
      }
      
      public static function buildFromJson(param1:HeroGameObjectOwner, param2:ActorView, param3:DBFacade, param4:Object) : InputTypeTimelineAction
      {
         var _loc5_:String = param4.inputType;
         return new InputTypeTimelineAction(param1,param2,param3,_loc5_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mHeroGameObjectOwner.inputController.inputType = mInputType;
      }
      
      override public function stop() : void
      {
         super.stop();
         if(mHeroGameObjectOwner && mHeroGameObjectOwner.inputController)
         {
            mHeroGameObjectOwner.inputController.inputType = "free";
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(mHeroGameObjectOwner && mHeroGameObjectOwner.inputController)
         {
            mHeroGameObjectOwner.inputController.inputType = "free";
         }
      }
   }
}

