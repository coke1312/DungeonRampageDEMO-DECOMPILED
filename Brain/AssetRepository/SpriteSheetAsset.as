package Brain.AssetRepository
{
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.*;
   
   public class SpriteSheetAsset extends Asset
   {
      
      private var mFacade:Facade;
      
      protected var mFrames:Vector.<BitmapData>;
      
      protected var mCenters:Vector.<Point>;
      
      protected var mFrameWidth:uint;
      
      protected var mFrameHeight:uint;
      
      protected var mNumFramesX:uint = 1;
      
      protected var mNumFramesY:uint = 1;
      
      private var mCacheKeyFor:String;
      
      private var mBaseName:String;
      
      private var mTimingVector:Vector.<Number>;
      
      public function SpriteSheetAsset(param1:Facade)
      {
         super();
         mFacade = param1;
      }
      
      public function FactoryCompiledIn(param1:String, param2:Object, param3:String) : void
      {
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:String = null;
         var _loc5_:Class = null;
         mBaseName = param1;
         mCacheKeyFor = param3;
         mCenters = new Vector.<Point>();
         mFrames = new Vector.<BitmapData>();
         mFrameWidth = param2.width;
         mFrameHeight = param2.height;
         mNumFramesY = param2.offsets.length;
         mNumFramesX = param2.Timing.length;
         mTimingVector = new Vector.<Number>();
         _loc8_ = 0;
         while(_loc8_ < mNumFramesX)
         {
            _loc9_ = param2.Timing[_loc8_] * 1000 / 24;
            mTimingVector.push(_loc9_);
            _loc8_++;
         }
         var _loc10_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < mNumFramesY)
         {
            _loc4_ = 0;
            while(_loc4_ < mNumFramesX)
            {
               _loc7_ = param1 + "_" + _loc6_.toString() + "_" + _loc4_.toString() + ".png";
               _loc5_ = getDefinitionByName(_loc7_) as Class;
               mFrames[_loc10_] = new _loc5_();
               mCenters[_loc10_] = new Point(mFrameWidth * 0.5 - param2.offsets[_loc6_][_loc4_].y,mFrameHeight * 0.5 - param2.offsets[_loc6_][_loc4_].x);
               _loc10_++;
               _loc4_++;
            }
            _loc6_++;
         }
      }
      
      public function FactoryFromSWf(param1:String, param2:Object, param3:SwfAsset) : void
      {
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:String = null;
         var _loc5_:Class = null;
         mBaseName = param1;
         mCacheKeyFor = param3.swfPath;
         mCenters = new Vector.<Point>();
         mFrames = new Vector.<BitmapData>();
         mFrameWidth = param2.width;
         mFrameHeight = param2.height;
         mNumFramesY = param2.offsets.length;
         mNumFramesX = param2.Timing.length;
         mTimingVector = new Vector.<Number>();
         _loc8_ = 0;
         while(_loc8_ < mNumFramesX)
         {
            _loc9_ = param2.Timing[_loc8_] * 1000 / 24;
            mTimingVector.push(_loc9_);
            _loc8_++;
         }
         var _loc10_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < mNumFramesY)
         {
            _loc4_ = 0;
            while(_loc4_ < mNumFramesX)
            {
               _loc7_ = param1 + "_" + _loc6_.toString() + "_" + _loc4_.toString() + ".png";
               _loc5_ = param3.getClass(_loc7_,false);
               mFrames[_loc10_] = new _loc5_();
               mCenters[_loc10_] = new Point(mFrameWidth * 0.5 - param2.offsets[_loc6_][_loc4_].y,mFrameHeight * 0.5 - param2.offsets[_loc6_][_loc4_].x);
               _loc10_++;
               _loc4_++;
            }
            _loc6_++;
         }
      }
      
      override public function destroy() : void
      {
         mFacade = null;
         for each(var _loc1_ in mFrames)
         {
            _loc1_.dispose();
         }
         mFrames = null;
         super.destroy();
      }
      
      public function get cacheKey() : String
      {
         return mCacheKeyFor;
      }
      
      private function getFrameIndex(param1:uint, param2:uint) : uint
      {
         if(mNumFramesY == 1)
         {
            param2 = 0;
         }
         var _loc3_:uint = param2 * mNumFramesX + param1;
         if(_loc3_ >= mFrames.length)
         {
            throw new Error("Tried to get frameIndex out of bounds: " + mBaseName + " " + _loc3_ + " / " + mFrames.length + " x:" + param1 + " y:" + param2 + " t1:" + mNumFramesY + " t2:" + mNumFramesX);
         }
         return _loc3_;
      }
      
      public function getFrame(param1:uint, param2:uint) : BitmapData
      {
         var _loc3_:uint = getFrameIndex(param1,param2);
         if(mFrames.length <= _loc3_)
         {
            Logger.error("Trying to access frame: " + _loc3_ + " but there are only " + mFrames.length + "frames in animation named: " + this.mBaseName);
            return null;
         }
         return mFrames[_loc3_];
      }
      
      public function getCenter(param1:uint, param2:uint) : Point
      {
         var _loc3_:uint = getFrameIndex(param1,param2);
         if(mCenters.length <= _loc3_)
         {
            Logger.error("Trying to access frame: " + _loc3_ + " but there are only " + mFrames.length + "frames in animation named: " + this.mBaseName);
            return null;
         }
         return mCenters[_loc3_];
      }
      
      public function get timingVector() : Vector.<Number>
      {
         return mTimingVector;
      }
      
      public function get numFramesX() : uint
      {
         return mNumFramesX;
      }
      
      public function get numFramesY() : uint
      {
         return mNumFramesY;
      }
   }
}

