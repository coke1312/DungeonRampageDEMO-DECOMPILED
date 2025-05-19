package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Logger.Logger;
   import Brain.Sound.SoundAsset;
   import Facade.DBFacade;
   import Sound.DBSoundComponent;
   
   public class SoundTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "sound";
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mSoundComponent:DBSoundComponent;
      
      protected var mSwfPath:String;
      
      protected var mSoundName:String;
      
      public function SoundTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:String, param5:String)
      {
         super(param1,param2,param3);
         mSwfPath = param4;
         mSoundName = param5;
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mSoundComponent = new DBSoundComponent(mDBFacade);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : SoundTimelineAction
      {
         return new SoundTimelineAction(param1,param2,param3,param4.path,param4.name);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         var timeline:ScriptTimeline = param1;
         super.execute(timeline);
         if(mSwfPath && mSoundName)
         {
            mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath(mSwfPath),mSoundName,function(param1:SoundAsset):void
            {
               mSoundComponent.playSfxOneShot(param1,mActorView.worldCenter);
            });
         }
         else
         {
            Logger.error("SoundTimelineAction: invalid sound: swfPath: " + mSwfPath + " soundName: " + mSoundName);
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

