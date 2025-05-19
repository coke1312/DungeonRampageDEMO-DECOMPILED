package Brain.AssetRepository
{
   import Brain.Facade.Facade;
   import flash.display.Bitmap;
   
   public class ImageAssetLoader extends AssetLoader
   {
      
      protected var mImageAsset:ImageAsset;
      
      public function ImageAssetLoader(param1:Facade, param2:AssetLoaderInfo, param3:Function, param4:Function = null)
      {
         super(param1,param2,param3,param4,true);
      }
      
      override protected function buildAsset(param1:Object) : Asset
      {
         var _loc2_:Bitmap = param1 as Bitmap;
         mImageAsset = new ImageAsset(_loc2_);
         return mImageAsset;
      }
   }
}

