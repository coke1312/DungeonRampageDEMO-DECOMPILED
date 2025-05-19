package Brain.AssetRepository
{
   public class SoundAssetLoaderInfo extends AssetLoaderInfo
   {
      
      protected var mSoundName:String;
      
      public function SoundAssetLoaderInfo(param1:String, param2:String, param3:Boolean)
      {
         super(param1,param3);
         mSoundName = param2;
      }
      
      override public function getKey() : String
      {
         return getRawAssetPath() + "_" + mSoundName;
      }
   }
}

