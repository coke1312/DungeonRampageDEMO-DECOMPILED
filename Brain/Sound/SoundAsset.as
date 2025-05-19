package Brain.Sound
{
   import Brain.AssetRepository.Asset;
   import flash.media.Sound;
   
   public class SoundAsset extends Asset
   {
      
      protected var mSound:Sound;
      
      public function SoundAsset(param1:Sound)
      {
         super();
         mSound = param1;
      }
      
      public function get sound() : Sound
      {
         return mSound;
      }
      
      override public function destroy() : void
      {
         mSound = null;
         super.destroy();
      }
   }
}

