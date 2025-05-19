package Sound
{
   import Brain.Sound.SoundAsset;
   import Brain.Sound.SoundComponent;
   import Brain.Sound.SoundHandle;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   
   public class DBSoundComponent extends SoundComponent
   {
      
      private var MIN_DISTANCE_FOR_SOUND:Number = 690;
      
      protected var mDBFacade:DBFacade;
      
      protected var mDBSoundManager:DBSoundManager;
      
      public function DBSoundComponent(param1:DBFacade)
      {
         super(param1);
         mDBFacade = param1;
         mDBSoundManager = mDBFacade.soundManager as DBSoundManager;
         MIN_DISTANCE_FOR_SOUND = mDBFacade.dbConfigManager.getConfigNumber("min_sound_distance",690);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         mDBFacade = null;
         mDBSoundManager = null;
      }
      
      public function playSfxOneShot(param1:SoundAsset, param2:Vector3D = null, param3:int = 0, param4:Number = 1, param5:Number = 0, param6:Number = 0) : void
      {
         var _loc7_:Vector3D = new Vector3D();
         _loc7_.x = -mDBFacade.camera.rootPosition.x;
         _loc7_.y = -mDBFacade.camera.rootPosition.y;
         if(param2 != null && Vector3D.distance(param2,_loc7_) > MIN_DISTANCE_FOR_SOUND)
         {
            return;
         }
         this.playOneShot(param1,"sfx",param3,param4,param5,param6);
      }
      
      public function playSfxManaged(param1:SoundAsset, param2:Number = 1, param3:Number = 0) : SoundHandle
      {
         return this.playManagedSound(param1,"sfx",param2,param3);
      }
      
      public function playMusic(param1:SoundAsset, param2:Number = 1, param3:Number = 0, param4:Number = 0) : SoundHandle
      {
         return playStreamingMusic(param1.sound,param2,param3,param4);
      }
      
      public function playStreamingMusic(param1:Sound, param2:Number = 1, param3:Number = 0, param4:Number = 0) : SoundHandle
      {
         var _loc5_:SoundHandle = new SoundHandle(mDBSoundManager,mDBFacade,param1,"music",unregisterSoundHandle,true,param2,param3);
         mSoundHandles.add(_loc5_);
         _loc5_.play(2147483647);
         return _loc5_;
      }
   }
}

