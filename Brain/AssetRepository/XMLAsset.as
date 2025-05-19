package Brain.AssetRepository
{
   public class XMLAsset extends Asset
   {
      
      protected var mXML:XML;
      
      public function XMLAsset(param1:XML)
      {
         super();
         mXML = param1;
      }
      
      public function get xml() : XML
      {
         return mXML;
      }
      
      override public function destroy() : void
      {
         mXML = null;
         super.destroy();
      }
   }
}

