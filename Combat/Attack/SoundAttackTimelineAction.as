package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Sound.SoundAsset;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import Sound.DBSoundComponent;
   
   public class SoundAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "attackSound";
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mSoundComponent:DBSoundComponent;
      
      public function SoundAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mSoundComponent = new DBSoundComponent(mDBFacade);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : SoundAttackTimelineAction
      {
         return new SoundAttackTimelineAction(param1,param2,param3);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         var gmAttack:GMAttack;
         var timeline:ScriptTimeline = param1;
         super.execute(timeline);
         gmAttack = mDBFacade.gameMaster.attackById.itemFor(mAttackType);
         if(gmAttack && gmAttack.AttackSound)
         {
            mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),gmAttack.AttackSound,function(param1:SoundAsset):void
            {
               mSoundComponent.playSfxOneShot(param1,mActorView.worldCenter,0,gmAttack.AttackVolume);
            });
         }
      }
      
      override public function destroy() : void
      {
         mSoundComponent.destroy();
         mSoundComponent = null;
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         super.destroy();
      }
   }
}

