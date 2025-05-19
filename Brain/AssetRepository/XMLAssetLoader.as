package Brain.AssetRepository
{
   import Brain.Facade.Facade;
   
   public class XMLAssetLoader extends AssetLoader
   {
      
      protected var mXMLAsset:XMLAsset;
      
      public function XMLAssetLoader(param1:Facade, param2:AssetLoaderInfo, param3:Function, param4:Function = null)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function buildAsset(param1:Object) : Asset
      {
         mXMLAsset = new XMLAsset(new XML(param1));
         return mXMLAsset;
      }
   }
}

