package Brain.AssetRepository
{
   import org.as3commons.collections.Map;
   
   public class SpriteSheetAssetLoaderInfo extends AssetLoaderInfo
   {
      
      private static var mLoadedJson:Map = new Map();
      
      public var bitmapDataName:String;
      
      public function SpriteSheetAssetLoaderInfo(param1:String, param2:String, param3:String, param4:Boolean)
      {
         super(param1,param4);
         this.bitmapDataName = param2;
      }
      
      override public function getKey() : String
      {
         return getRawAssetPath() + "_" + bitmapDataName;
      }
   }
}

