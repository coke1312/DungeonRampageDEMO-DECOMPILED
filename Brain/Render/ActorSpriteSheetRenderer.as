package Brain.Render
{
   import Brain.AssetRepository.SpriteSheetAsset;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.WorkComponent;
   
   public class ActorSpriteSheetRenderer extends SpriteSheetRenderer implements IRenderer
   {
      
      public static var SPRITE_SHEET_RENDERER_TYPE:String = "SpriteSheetRenderer";
      
      protected var mFrameRate:Number = 24;
      
      protected var mPlayRate:Number = 1;
      
      protected var mDuration:Number = 0;
      
      protected var mFrameTimes:Vector.<Number>;
      
      protected var mLoop:Boolean = true;
      
      private var mIsPlaying:Boolean = false;
      
      private var mAnimationFrame:uint = 0;
      
      private var mPlayHead:Number = 0;
      
      protected var mHeading:Number = 0;
      
      public function ActorSpriteSheetRenderer(param1:WorkComponent, param2:SpriteSheetAsset)
      {
         super(param1,param2);
         mBitmap.name = "ActorSpriteSheetRenderer";
         mFrameTimes = param2.timingVector;
         if(mFrameTimes.length != param2.numFramesX)
         {
            throw new Error("Warning: frameTimes vector length and sheet numFramesX must match");
         }
         mDuration = 0;
         for each(var _loc3_ in mFrameTimes)
         {
            mDuration += _loc3_ / 1000;
         }
      }
      
      public function get playRate() : Number
      {
         return mPlayRate;
      }
      
      public function get rendererType() : String
      {
         return SPRITE_SHEET_RENDERER_TYPE;
      }
      
      public function set playRate(param1:Number) : void
      {
         mPlayRate = param1;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      public function get durationInSeconds() : Number
      {
         return mDuration / mPlayRate;
      }
      
      public function get frameCount() : Number
      {
         return mFrameTimes.length;
      }
      
      override public function get loop() : Boolean
      {
         return mLoop;
      }
      
      public function get frameRate() : uint
      {
         return mFrameRate;
      }
      
      private function getFrameFromTime(param1:Number) : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = 0;
         for each(var _loc2_ in mFrameTimes)
         {
            _loc4_ += _loc2_ / 1000 / mPlayRate;
            if(_loc4_ > param1)
            {
               break;
            }
            _loc3_++;
         }
         return _loc3_;
      }
      
      private function getTimeFromFrame(param1:uint) : Number
      {
         var _loc3_:int = 0;
         var _loc2_:* = param1;
         if(param1 >= mFrameTimes.length)
         {
            Logger.warn("Trying to set animation to frame: " + param1 + ", but mFrameTimes only has length of: " + mFrameTimes.length);
            _loc2_ = mFrameTimes.length;
         }
         var _loc4_:Number = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ += mFrameTimes[_loc3_] / 1000 / mPlayRate;
            _loc3_++;
         }
         return _loc4_;
      }
      
      private function getAnimationIndexFromClock(param1:GameClock) : uint
      {
         mPlayHead += param1.tickLength;
         if(!mLoop && mPlayHead >= this.durationInSeconds)
         {
            stop();
            return this.mSpriteSheet.numFramesX - 1;
         }
         mPlayHead %= this.durationInSeconds;
         mAnimationFrame = this.getFrameFromTime(mPlayHead);
         return mAnimationFrame;
      }
      
      public function get isPlaying() : Boolean
      {
         return mIsPlaying;
      }
      
      override public function play(param1:uint = 0, param2:Boolean = true, param3:Function = null) : void
      {
         mIsPlaying = true;
         mAnimationFrame = param1;
         mPlayHead = this.getTimeFromFrame(param1);
         mLoop = param2;
         super.play(param1,param2,param3);
         if(mIsPlaying && mBitmap.stage != null && mOnFrameTask == null)
         {
            this.onAdd();
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(mOnFrameTask)
         {
            mOnFrameTask.destroy();
            mOnFrameTask = null;
         }
         mIsPlaying = false;
      }
      
      override protected function onFrame(param1:GameClock) : void
      {
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         if(mIsPlaying && mBitmap.stage != null)
         {
            _loc3_ = getAnimationIndexFromClock(param1);
            _loc5_ = getDirectionIndexFromHeading(mHeading);
            _loc4_ = mXIndex;
            _loc2_ = mYIndex;
            setFrameIndexes(_loc3_,_loc5_);
            if(mXIndex != _loc4_ || mYIndex != _loc2_)
            {
               super.onFrame(param1);
            }
         }
      }
      
      override public function set heading(param1:Number) : void
      {
         while(param1 < -180)
         {
            param1 += 360;
         }
         while(param1 > 180)
         {
            param1 -= 360;
         }
         mHeading = param1;
      }
      
      public function get heading() : Number
      {
         return mHeading;
      }
      
      public function getDirectionIndexFromHeading(param1:Number) : uint
      {
         if(param1 > 90)
         {
            param1 = -param1 + 180;
         }
         else if(param1 < -90)
         {
            param1 = -param1 - 180;
         }
         switch(int(mSpriteSheet.numFramesY) - 1)
         {
            case 0:
               return 0;
            case 1:
               if(180 >= param1 && param1 >= 0)
               {
                  return 1;
               }
               if(0 >= param1 && param1 >= -180)
               {
                  return 0;
               }
               throw new Error("unknown heading:",param1);
               break;
            case 2:
               if(90 >= param1 && param1 >= 60)
               {
                  return 0;
               }
               if(60 >= param1 && param1 >= 0)
               {
                  return 2;
               }
               if(0 >= param1 && param1 >= -90)
               {
                  return 1;
               }
               throw new Error("unknown heading:",param1);
               break;
            case 4:
               if(120 >= param1 && param1 >= 60)
               {
                  return 4;
               }
               if(60 >= param1 && param1 >= 30)
               {
                  return 3;
               }
               if(30 >= param1 && param1 >= -30)
               {
                  return 2;
               }
               if(-30 >= param1 && param1 >= -60)
               {
                  return 1;
               }
               if(-60 >= param1 && param1 >= -120)
               {
                  return 0;
               }
               throw new Error("unknown heading:",param1);
               break;
            default:
               throw new Error("unsupported numFramesY: " + mSpriteSheet.numFramesY.toString());
         }
      }
      
      override public function setFrame(param1:uint) : void
      {
         var _loc2_:int = int(getDirectionIndexFromHeading(this.heading));
         setFrameIndexes(param1,_loc2_);
         updateToCurrentFrame();
      }
   }
}

