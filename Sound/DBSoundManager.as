package Sound
{
   import Brain.Logger.Logger;
   import Brain.Sound.SoundHandle;
   import Brain.Sound.SoundManager;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   import org.as3commons.collections.Set;
   
   public class DBSoundManager extends SoundManager
   {
      
      public static const MUSIC_MIXER_CATEGORY:String = "music";
      
      public static const SFX_MIXER_CATEGORY:String = "sfx";
      
      protected var mCurrentMusic:SoundHandle;
      
      public function DBSoundManager(param1:DBFacade)
      {
         super(param1);
         setVolumeScaleForCategory("music",DBGlobal.MUSIC_VOLUME);
         setVolumeScaleForCategory("sfx",1);
      }
      
      public function set musicVolumeScale(param1:Number) : void
      {
         this.setVolumeScaleForCategory("music",param1);
      }
      
      public function get musicVolumeScale() : Number
      {
         return getVolumeScaleForCategory("music");
      }
      
      public function set sfxVolumeScale(param1:Number) : void
      {
         this.setVolumeScaleForCategory("sfx",param1);
      }
      
      public function get sfxVolumeScale() : Number
      {
         return getVolumeScaleForCategory("sfx");
      }
      
      override public function registerSoundPlaying(param1:SoundHandle) : void
      {
         if(param1.category == "music")
         {
            registerMusicPlaying(param1);
         }
         else
         {
            super.registerSoundPlaying(param1);
         }
      }
      
      protected function registerMusicPlaying(param1:SoundHandle) : void
      {
         if(mCurrentMusic == null)
         {
            mCurrentMusic = param1;
            super.registerSoundPlaying(param1);
            return;
         }
         var _loc2_:Set = mSoundsDictionary.itemFor("music") as Set;
         if(!_loc2_.has(mCurrentMusic))
         {
            Logger.error("CurrentMusicHandle in DBSoundManager is not registered.");
            return;
         }
         mCurrentMusic.stop();
         mCurrentMusic = null;
         mCurrentMusic = param1;
         super.registerSoundPlaying(mCurrentMusic);
      }
      
      override public function unregisterSoundPlaying(param1:SoundHandle) : void
      {
         if(param1.category == "music")
         {
            unregisterMusicPlaying(param1);
         }
         else
         {
            super.unregisterSoundPlaying(param1);
         }
      }
      
      protected function unregisterMusicPlaying(param1:SoundHandle) : void
      {
         if(mCurrentMusic == null)
         {
            Logger.error("Trying to unregister music playing but mCurrentMusic is null");
            return;
         }
         mCurrentMusic = null;
         super.unregisterSoundPlaying(param1);
      }
   }
}

