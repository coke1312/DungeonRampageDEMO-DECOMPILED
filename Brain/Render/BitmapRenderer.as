package Brain.Render
{
   import Brain.Clock.GameClock;
   import Brain.WorkLoop.Task;
   import Brain.WorkLoop.WorkComponent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BitmapRenderer
   {
      
      protected var mWorkComponent:WorkComponent;
      
      protected var mOnFrameTask:Task;
      
      protected var mBitmap:Bitmap = new Bitmap();
      
      protected var mSmoothing:Boolean = false;
      
      protected var mCenter:Point = new Point(0.5,0.5);
      
      public function BitmapRenderer(param1:WorkComponent)
      {
         super();
         mBitmap.smoothing = mSmoothing;
         mBitmap.pixelSnapping = "auto";
         mWorkComponent = param1;
         mBitmap.addEventListener("addedToStage",onAdd);
         mBitmap.addEventListener("removedFromStage",onRemove);
      }
      
      public function destroy() : void
      {
         mBitmap.removeEventListener("addedToStage",onAdd);
         mBitmap.removeEventListener("removedFromStage",onRemove);
         onRemove();
         mWorkComponent.destroy();
         mWorkComponent = null;
         mBitmap = null;
      }
      
      protected function onAdd(param1:Event = null) : void
      {
         if(mOnFrameTask != null)
         {
            mOnFrameTask.destroy();
         }
         mOnFrameTask = mWorkComponent.doEveryFrame(onFrame);
      }
      
      protected function onRemove(param1:Event = null) : void
      {
         if(mOnFrameTask != null)
         {
            mOnFrameTask.destroy();
            mOnFrameTask = null;
         }
      }
      
      public function set center(param1:Point) : void
      {
         mCenter = param1;
         mBitmap.x = -mCenter.x;
         mBitmap.y = -mCenter.y;
      }
      
      public function get center() : Point
      {
         return mCenter;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         mSmoothing = param1;
         mBitmap.smoothing = mSmoothing;
      }
      
      public function get smoothing() : Boolean
      {
         return mSmoothing;
      }
      
      public function get displayObject() : DisplayObject
      {
         return mBitmap;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         if(param1 == mBitmap.bitmapData)
         {
            return;
         }
         mBitmap.bitmapData = param1;
         mBitmap.smoothing = mSmoothing;
         mBitmap.x = -mCenter.x;
         mBitmap.y = -mCenter.y;
      }
      
      protected function onFrame(param1:GameClock) : void
      {
      }
      
      public function get bitmapData() : BitmapData
      {
         return mBitmap.bitmapData;
      }
   }
}

