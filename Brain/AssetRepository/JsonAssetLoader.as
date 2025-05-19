package Brain.AssetRepository
{
   import Brain.Facade.Facade;
   
   public class JsonAssetLoader extends AssetLoader
   {
      
      protected var mJsonAsset:JsonAsset;
      
      public function JsonAssetLoader(param1:Facade, param2:AssetLoaderInfo, param3:Function, param4:Function)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function buildAsset(param1:Object) : Asset
      {
         mJsonAsset = new JsonAsset(param1);
         return mJsonAsset;
      }
   }
}

