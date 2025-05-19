package Brain.Sound
{
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Brain.WorkLoop.WorkComponent;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundHandle
   {
      
      protected var mSoundManager:SoundManager;
      
      protected var mWorkComponent:WorkComponent;
      
      protected var mEventComponent:EventComponent;
      
      protected var mSoundCompleteTask:Task;
      
      protected var mSound:Sound;
      
      protected var mSoundChannel:SoundChannel;
      
      protected var mOwnerComponentDestroy:Function;
      
      protected var mVolume:Number;
      
      protected var mPanning:Number;
      
      protected var mCategory:String;
      
      protected var mLoopCount:int;
      
      protected var mSoundTransform:SoundTransform;
      
      protected var mPausePosition:Number;
      
      protected var mManaged:Boolean;
      
      protected var mRegistered:Boolean = false;
      
      public function SoundHandle(param1:SoundManager, param2:Facade, param3:Sound, param4:String, param5:Function, param6:Boolean, param7:Number = 1, param8:Number = 0)
      {
         super();
         mSoundManager = param1;
         mWorkComponent = new LogicalWorkComponent(param2);
         mSound = param3;
         mVolume = param7;
         mPanning = param8;
         mManaged = param6;
         mCategory = param4;
         mEventComponent = new EventComponent(param2);
         mEventComponent.addListener("SoundCategoryVoumeChangedEvent",handleVolumeCategoryChangedEvent);
         mOwnerComponentDestroy = param5;
         mSoundTransform = buildSoundTransform();
      }
      
      private function handleVolumeCategoryChangedEvent(param1:Event) : void
      {
         applySoundTransform();
      }
      
      public function play(param1:Number = 1, param2:Number = 0) : Boolean
      {
         if(!mRegistered && mManaged)
         {
            registerPlaying();
         }
         mLoopCount = param1;
         mSoundTransform = buildSoundTransform();
         mSoundChannel = mSound.play(0,mLoopCount,mSoundTransform);
         if(mSoundChannel == null)
         {
            return false;
         }
         var _loc3_:Number = (mSound.length - param2) / 1000;
         if(_loc3_ <= 0)
         {
            Logger.warn("Bad sound length=" + mSound.length.toString() + " or startPosition=" + param2.toString() + " url=" + mSound.url);
            mLoopCount = 0;
            this.soundComplete();
         }
         else
         {
            mSoundCompleteTask = mWorkComponent.doLater(_loc3_,soundComplete);
         }
         return true;
      }
      
      public function pause() : void
      {
         if(mSoundChannel == null)
         {
            return;
         }
         mPausePosition = mSoundChannel.position;
         unregisterPlayingFromManager();
         mSoundChannel.stop();
      }
      
      public function resume() : void
      {
         play(mLoopCount,mPausePosition);
      }
      
      protected function soundComplete(param1:GameClock = null) : void
      {
         if(mLoopCount == 0)
         {
            if(!mManaged)
            {
               destroy();
               return;
            }
            if(mSoundCompleteTask)
            {
               mSoundCompleteTask.destroy();
            }
            mSoundCompleteTask = null;
         }
         else
         {
            mLoopCount--;
            if(mSoundCompleteTask)
            {
               mSoundCompleteTask.destroy();
            }
            mSoundCompleteTask = null;
            if(mSoundChannel != null)
            {
               mSoundChannel.stop();
            }
            play(mLoopCount);
         }
      }
      
      public function stop() : void
      {
         if(mRegistered)
         {
            unregisterPlayingFromManager();
         }
         if(mSoundChannel == null)
         {
            return;
         }
         mSoundChannel.stop();
         mSoundChannel.removeEventListener("soundComplete",soundComplete);
         mPausePosition = 0;
         if(mSoundCompleteTask != null)
         {
            mSoundCompleteTask.destroy();
            mSoundCompleteTask = null;
         }
         mLoopCount = 0;
      }
      
      protected function registerPlaying() : void
      {
         mRegistered = true;
         mSoundManager.registerSoundPlaying(this);
      }
      
      protected function unregisterPlayingFromManager() : void
      {
         mRegistered = false;
         mSoundManager.unregisterSoundPlaying(this);
      }
      
      protected function buildSoundTransform() : SoundTransform
      {
         var _loc1_:Number = mSoundManager.getVolumeScaleForCategory(mCategory);
         return new SoundTransform(mVolume * _loc1_,mPanning);
      }
      
      protected function applySoundTransform() : void
      {
         mSoundTransform = buildSoundTransform();
         if(mSoundChannel == null)
         {
            return;
         }
         mSoundChannel.soundTransform = mSoundTransform;
      }
      
      public function get volume() : Number
      {
         return mVolume;
      }
      
      public function set volume(param1:Number) : void
      {
         mVolume = param1;
         applySoundTransform();
      }
      
      public function get panning() : Number
      {
         return mPanning;
      }
      
      public function set panning(param1:Number) : void
      {
         mPanning = param1;
         applySoundTransform();
      }
      
      public function get category() : String
      {
         return mCategory;
      }
      
      public function destroy() : void
      {
         stop();
         if(mOwnerComponentDestroy != null)
         {
            mOwnerComponentDestroy(this);
            mOwnerComponentDestroy = null;
         }
         mSoundManager = null;
         mSound = null;
         if(mSoundChannel)
         {
            mSoundChannel.stop();
            mSoundChannel = null;
         }
         mCategory = null;
         mSoundTransform = null;
         if(mEventComponent)
         {
            mEventComponent.destroy();
            mEventComponent = null;
         }
      }
   }
}

