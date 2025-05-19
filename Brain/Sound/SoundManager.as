package Brain.Sound
{
   import Brain.Event.EventComponent;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.Set;
   
   public class SoundManager
   {
      
      private static const GLOBAL_VOLUME_DAMPENER:Number = 0.1;
      
      protected var mCategoryVolumeScale:Map;
      
      protected var mEventComponent:EventComponent;
      
      protected var mMaxConcurrentSounds:uint = 20;
      
      protected var mSoundsDictionary:Map;
      
      public function SoundManager(param1:Facade)
      {
         super();
         mCategoryVolumeScale = new Map();
         mSoundsDictionary = new Map();
         mEventComponent = new EventComponent(param1);
      }
      
      public function destroy() : void
      {
         mEventComponent.destroy();
         mEventComponent = null;
         mSoundsDictionary = null;
         mCategoryVolumeScale = null;
      }
      
      public function registerSoundPlaying(param1:SoundHandle) : void
      {
         var _loc2_:Set = null;
         if(mSoundsDictionary.hasKey(param1.category))
         {
            _loc2_ = mSoundsDictionary.itemFor(param1.category) as Set;
            if(_loc2_.has(param1))
            {
               Logger.warn("Trying to register a sound handle that already exists in the set.");
               return;
            }
            _loc2_.add(param1);
         }
         else
         {
            _loc2_ = new Set();
            _loc2_.add(param1);
            mSoundsDictionary.add(param1.category,_loc2_);
         }
      }
      
      public function unregisterSoundPlaying(param1:SoundHandle) : void
      {
         if(!mSoundsDictionary.hasKey(param1.category))
         {
            Logger.error("Tryign to remove soundHandle from a category that does not exist in the dictionary. Category: " + param1.category);
         }
         var _loc2_:Set = mSoundsDictionary.itemFor(param1.category) as Set;
         if(_loc2_.has(param1))
         {
            _loc2_.remove(param1);
         }
         else
         {
            Logger.warn("Trying to remove a soundHandle from a soundCategory that does not have it in the set.");
         }
      }
      
      public function setVolumeScaleForCategory(param1:String, param2:Number) : void
      {
         param2 *= 0.1;
         if(mCategoryVolumeScale.hasKey(param1))
         {
            mCategoryVolumeScale.replaceFor(param1,param2);
         }
         else
         {
            mCategoryVolumeScale.add(param1,param2);
         }
         mEventComponent.dispatchEvent(new SoundCategoryVoumeChangedEvent());
      }
      
      public function getVolumeScaleForCategory(param1:String) : Number
      {
         if(mCategoryVolumeScale.hasKey(param1))
         {
            return mCategoryVolumeScale.itemFor(param1);
         }
         Logger.warn("No category found for category: " + param1 + "  Returning 1.");
         return 1;
      }
   }
}

