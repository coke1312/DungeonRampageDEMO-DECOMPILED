package Brain.AssetRepository
{
   import Brain.Facade.Facade;
   import flash.display.MovieClip;
   
   public class SwfAssetLoader extends AssetLoader
   {
      
      protected var mSwfAsset:SwfAsset;
      
      public function SwfAssetLoader(param1:Facade, param2:AssetLoaderInfo, param3:Function, param4:Function)
      {
         super(param1,param2,param3,param4,true);
      }
      
      override protected function buildAsset(param1:Object) : Asset
      {
         var _loc2_:MovieClip = param1 as MovieClip;
         mSwfAsset = new SwfAsset(_loc2_,mAssetLoaderInfo.getRawAssetPath());
         return mSwfAsset;
      }
   }
}

