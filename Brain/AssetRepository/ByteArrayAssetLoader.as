package Brain.AssetRepository
{
   import Brain.Facade.Facade;
   import flash.utils.ByteArray;
   
   public class ByteArrayAssetLoader extends AssetLoader
   {
      
      protected var mByteArrayAsset:ByteArrayAsset;
      
      public function ByteArrayAssetLoader(param1:Facade, param2:AssetLoaderInfo, param3:Function, param4:Function = null)
      {
         super(param1,param2,param3,param4,false,"binary");
      }
      
      override protected function buildAsset(param1:Object) : Asset
      {
         mByteArrayAsset = new ByteArrayAsset(param1 as ByteArray);
         return mByteArrayAsset;
      }
   }
}

