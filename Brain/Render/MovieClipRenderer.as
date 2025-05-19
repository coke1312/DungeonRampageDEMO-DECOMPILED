package Brain.Render
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MovieClipRenderer
   {
      
      private static const LOOP_LABEL:String = "loop";
      
      private static const NO_LOOP_LABEL:String = "noloop";
      
      protected var mFrameRate:Number = 24;
      
      protected var mPlayRate:Number = 1;
      
      protected var mLoop:Boolean = true;
      
      protected var mPlayHead:Number = 1;
      
      protected var mStartFrame:uint = 1;
      
      protected var mMaxFrames:uint;
      
      protected var mClip:MovieClip;
      
      protected var mOnFrameTask:Task;
      
      protected var mFinishedCallback:Function;
      
      protected var mIsPlaying:Boolean = false;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      public function MovieClipRenderer(param1:Facade, param2:MovieClip, param3:Function = null)
      {
         super();
         this.clip = param2;
         mFinishedCallback = param3;
         if(mMaxFrames > 1)
         {
            mLogicalWorkComponent = new LogicalWorkComponent(param1);
            if(mClip.stage)
            {
               onAdd();
            }
            mClip.addEventListener("addedToStage",onAdd);
            mClip.addEventListener("removedFromStage",onRemove);
         }
      }
      
      public function setFrame(param1:uint) : void
      {
         mPlayHead = param1;
         this.updateClip(mClip);
      }
      
      public function get currentFrame() : uint
      {
         return Math.round(mPlayHead % mMaxFrames) + 1;
      }
      
      public function play(param1:uint = 0, param2:Boolean = false, param3:Function = null) : void
      {
         if(param3 != null)
         {
            mFinishedCallback = param3;
         }
         if(mMaxFrames <= 1)
         {
            mClip.gotoAndStop(1);
         }
         else
         {
            mPlayHead = param1;
            mLoop = param2;
            mIsPlaying = true;
            mMaxFrames = initialize(mClip);
            this.updateClip(mClip);
            if(mClip.stage)
            {
               onAdd();
            }
         }
      }
      
      public function set finishedCallback(param1:Function) : void
      {
         mFinishedCallback = param1;
      }
      
      public function stop() : void
      {
         mIsPlaying = false;
      }
      
      public function destroy() : void
      {
         if(mClip)
         {
            mClip.removeEventListener("addedToStage",onAdd);
            mClip.removeEventListener("removedFromStage",onRemove);
         }
         if(mOnFrameTask != null)
         {
            mOnFrameTask.destroy();
            mOnFrameTask = null;
         }
         if(mLogicalWorkComponent)
         {
            mLogicalWorkComponent.destroy();
            mLogicalWorkComponent = null;
         }
         mClip = null;
         mFinishedCallback = null;
      }
      
      private function onAdd(param1:Event = null) : void
      {
         if(mOnFrameTask != null)
         {
            mOnFrameTask.destroy();
         }
         mOnFrameTask = mLogicalWorkComponent.doEveryFrame(onFrame);
      }
      
      private function onRemove(param1:Event = null) : void
      {
         if(mOnFrameTask != null)
         {
            mOnFrameTask.destroy();
            mOnFrameTask = null;
         }
      }
      
      public function get playRate() : Number
      {
         return mPlayRate;
      }
      
      public function set playRate(param1:Number) : void
      {
         mPlayRate = param1;
      }
      
      public function get frameRate() : Number
      {
         return mFrameRate;
      }
      
      public function set frameRate(param1:Number) : void
      {
         mFrameRate = frameRate;
      }
      
      public function set startFrame(param1:uint) : void
      {
         mStartFrame = param1;
      }
      
      public function get loop() : Boolean
      {
         return mLoop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         mLoop = param1;
      }
      
      public function onFrame(param1:GameClock) : void
      {
         if(!mClip)
         {
            return;
         }
         if(mClip.stage == null)
         {
            Logger.warn("Animating MovieClipRenderer that is not on stage");
         }
         if(!mIsPlaying)
         {
            return;
         }
         mPlayHead += mFrameRate * param1.tickLength * mPlayRate;
         if(mPlayHead > mMaxFrames - 1 && !mLoop)
         {
            mIsPlaying = false;
            mPlayHead = mMaxFrames - 1;
            this.updateClip(mClip);
            if(mOnFrameTask != null)
            {
               mOnFrameTask.destroy();
               mOnFrameTask = null;
            }
            mIsPlaying = false;
            if(mFinishedCallback != null)
            {
               mFinishedCallback();
            }
            return;
         }
         this.updateClip(mClip);
      }
      
      public function set clip(param1:MovieClip) : void
      {
         if(param1 == mClip)
         {
            return;
         }
         mClip = param1;
         mPlayHead = mStartFrame;
         mMaxFrames = initialize(mClip);
         this.updateClip(mClip);
      }
      
      public function get clip() : MovieClip
      {
         return mClip;
      }
      
      public function get numFrames() : uint
      {
         if(mClip == null)
         {
            return 0;
         }
         return mMaxFrames;
      }
      
      protected function updateClip(param1:DisplayObjectContainer) : void
      {
         var _loc5_:MovieClip = null;
         var _loc4_:DisplayObject = null;
         var _loc7_:DisplayObjectContainer = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc8_:int = 0;
         _loc5_ = param1 as MovieClip;
         if(_loc5_ && _loc5_.totalFrames > 1)
         {
            if(_loc5_.MCR_firstLoopFrame > 0)
            {
               if(_loc5_.MCR_playedIntro)
               {
                  _loc3_ = _loc5_.totalFrames - _loc5_.MCR_firstLoopFrame + 1;
                  _loc6_ = Math.round((mPlayHead - _loc5_.MCR_firstLoopFrame - 1) % _loc3_) + _loc5_.MCR_firstLoopFrame;
               }
               else
               {
                  _loc6_ = Math.round(mPlayHead % _loc5_.totalFrames) + 1;
                  if(mPlayHead >= _loc5_.totalFrames)
                  {
                     _loc5_.MCR_playedIntro = true;
                  }
               }
            }
            else
            {
               _loc6_ = Math.round(mPlayHead % _loc5_.totalFrames) + 1;
            }
            _loc5_.gotoAndStop(_loc6_);
         }
         _loc8_ = 0;
         while(_loc8_ < param1.numChildren)
         {
            try
            {
               _loc4_ = param1.getChildAt(_loc8_);
               _loc7_ = _loc4_ as DisplayObjectContainer;
               if(_loc7_ && _loc7_.numChildren)
               {
                  updateClip(_loc7_);
               }
               else
               {
                  _loc2_ = _loc4_ as MovieClip;
                  if(_loc2_ && _loc2_.totalFrames > 1)
                  {
                     updateClip(_loc2_);
                  }
               }
            }
            catch(error:Error)
            {
            }
            _loc8_++;
         }
      }
      
      public function get duration() : Number
      {
         if(mClip == null)
         {
            return 0;
         }
         return mMaxFrames / this.frameRate / this.playRate;
      }
      
      public function get isPlaying() : Boolean
      {
         return mIsPlaying;
      }
      
      protected function initialize(param1:DisplayObjectContainer, param2:uint = 0, param3:String = "") : uint
      {
         var _loc7_:DisplayObject = null;
         var _loc4_:MovieClip = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:int = 0;
         _loc4_ = param1 as MovieClip;
         if(_loc4_)
         {
            param2 = Math.max(param2,_loc4_.totalFrames);
            this.determineFrames(_loc4_);
         }
         _loc6_ = 0;
         while(_loc6_ < param1.numChildren)
         {
            try
            {
               _loc7_ = param1.getChildAt(_loc6_);
               _loc5_ = _loc7_ as DisplayObjectContainer;
               if(_loc5_ && _loc5_.numChildren)
               {
                  param2 = Math.max(param2,initialize(_loc5_,param2,param3 + "    "));
               }
               else if(_loc7_ is MovieClip)
               {
                  param2 = Math.max(param2,MovieClip(_loc7_).totalFrames);
               }
            }
            catch(error:Error)
            {
            }
            _loc6_++;
         }
         return param2;
      }
      
      protected function determineFrames(param1:MovieClip) : void
      {
         var _loc2_:int = -1;
         for each(var _loc3_ in param1.currentLabels)
         {
            if(_loc3_.name == "loop")
            {
               _loc2_ = _loc3_.frame;
               mLoop = true;
               break;
            }
            if(_loc3_.name == "noloop")
            {
               mLoop = false;
               break;
            }
         }
         param1.MCR_firstLoopFrame = _loc2_;
         param1.MCR_playedIntro = false;
      }
   }
}

