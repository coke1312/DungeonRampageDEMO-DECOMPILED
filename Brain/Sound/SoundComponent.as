package Brain.Sound
{
   import Brain.Component.Component;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.ISetIterator;
   
   public class SoundComponent extends Component
   {
      
      protected var mSoundHandles:Set;
      
      public function SoundComponent(param1:Facade)
      {
         super(param1);
         mSoundHandles = new Set();
      }
      
      public function playOneShot(param1:SoundAsset, param2:String, param3:int = 0, param4:Number = 1, param5:Number = 0, param6:Number = 0) : void
      {
         var _loc7_:SoundHandle = new SoundHandle(mFacade.soundManager,mFacade,param1.sound,param2,null,false,param4,param5);
         _loc7_.play(param3,param6);
      }
      
      public function playManagedSound(param1:SoundAsset, param2:String, param3:Number = 1, param4:Number = 0) : SoundHandle
      {
         var soundAsset:SoundAsset = param1;
         var category:String = param2;
         var volume:Number = param3;
         var panning:Number = param4;
         var soundHandle:SoundHandle = new SoundHandle(mFacade.soundManager,mFacade,soundAsset.sound,category,function(param1:SoundHandle):void
         {
            unregisterSoundHandle(param1);
         },true,volume,panning);
         mSoundHandles.add(soundHandle);
         return soundHandle;
      }
      
      protected function unregisterSoundHandle(param1:SoundHandle) : void
      {
         if(!mSoundHandles.has(param1))
         {
            Logger.warn("Trying to unregister soundHandle which does not exist in SoundComponent\'s set.");
            return;
         }
         mSoundHandles.remove(param1);
      }
      
      override public function destroy() : void
      {
         var _loc1_:SoundHandle = null;
         var _loc2_:ISetIterator = mSoundHandles.iterator() as ISetIterator;
         while(_loc2_.hasNext())
         {
            _loc1_ = _loc2_.next();
            _loc1_.destroy();
         }
         mSoundHandles.clear();
         mSoundHandles = null;
      }
   }
}

