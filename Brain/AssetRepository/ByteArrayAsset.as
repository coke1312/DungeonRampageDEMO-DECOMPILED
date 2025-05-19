package Brain.AssetRepository
{
   import flash.utils.ByteArray;
   
   public class ByteArrayAsset extends Asset
   {
      
      protected var mByteArray:ByteArray;
      
      public function ByteArrayAsset(param1:ByteArray)
      {
         super();
         mByteArray = param1;
      }
      
      public function get byteArray() : ByteArray
      {
         return mByteArray;
      }
      
      override public function destroy() : void
      {
         mByteArray = null;
         super.destroy();
      }
   }
}

