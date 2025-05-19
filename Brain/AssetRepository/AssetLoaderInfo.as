package Brain.AssetRepository
{
   import Brain.Logger.Logger;
   
   public class AssetLoaderInfo
   {
      
      public var dependentAssetPath:String;
      
      public var useCache:Boolean;
      
      public function AssetLoaderInfo(param1:String, param2:Boolean)
      {
         super();
         useCache = param2;
         dependentAssetPath = param1;
         if(dependentAssetPath == null || dependentAssetPath == "" || dependentAssetPath == "null" || dependentAssetPath.indexOf("../../../null") != -1)
         {
            Logger.error("Asset Path is null or empty");
         }
      }
      
      public function getKey() : String
      {
         return dependentAssetPath;
      }
      
      public function getRawAssetPath() : String
      {
         return dependentAssetPath;
      }
   }
}

