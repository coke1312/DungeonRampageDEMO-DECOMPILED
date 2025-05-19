package Brain.Render
{
   import Brain.AssetRepository.SpriteSheetAsset;
   import Brain.Clock.GameClock;
   import Brain.WorkLoop.WorkComponent;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class SpriteSheetRenderer extends BitmapRenderer
   {
      
      protected var mSpriteSheet:SpriteSheetAsset;
      
      protected var mXIndex:uint = 0;
      
      protected var mYIndex:uint = 0;
      
      public function SpriteSheetRenderer(param1:WorkComponent, param2:SpriteSheetAsset)
      {
         super(param1);
         mSpriteSheet = param2;
      }
      
      override public function destroy() : void
      {
         mSpriteSheet = null;
         super.destroy();
      }
      
      public function set spriteSheet(param1:SpriteSheetAsset) : void
      {
         mSpriteSheet = param1;
      }
      
      public function setFrameIndexes(param1:uint, param2:uint) : void
      {
         mXIndex = param1;
         mYIndex = param2;
      }
      
      protected function getCurrentFrame() : BitmapData
      {
         return mSpriteSheet.getFrame(mXIndex,mYIndex);
      }
      
      protected function getCurrentCenter() : Point
      {
         return mSpriteSheet.getCenter(mXIndex,mYIndex);
      }
      
      public function updateToCurrentFrame() : void
      {
         this.center = getCurrentCenter();
         this.bitmapData = getCurrentFrame();
      }
      
      override protected function onFrame(param1:GameClock) : void
      {
         super.onFrame(param1);
         this.updateToCurrentFrame();
      }
      
      public function play(param1:uint = 0, param2:Boolean = true, param3:Function = null) : void
      {
         setFrame(param1);
      }
      
      public function stop() : void
      {
      }
      
      public function get currentFrame() : uint
      {
         return mXIndex;
      }
      
      public function set heading(param1:Number) : void
      {
      }
      
      public function get loop() : Boolean
      {
         return false;
      }
      
      public function setFrame(param1:uint) : void
      {
         this.mXIndex = param1;
      }
   }
}

