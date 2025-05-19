package Brain.AssetRepository
{
   import flash.display.Bitmap;
   
   public class ImageAsset extends Asset
   {
      
      protected var mImage:Bitmap;
      
      public function ImageAsset(param1:Bitmap)
      {
         super();
         mImage = param1;
      }
      
      public function get image() : Bitmap
      {
         return mImage;
      }
      
      override public function destroy() : void
      {
         mImage = null;
         super.destroy();
      }
   }
}

