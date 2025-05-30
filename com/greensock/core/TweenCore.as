package com.greensock.core
{
   import com.greensock.*;
   
   public class TweenCore
   {
      
      protected static var _classInitted:Boolean;
      
      public static const version:Number = 1.64;
      
      public var initted:Boolean;
      
      protected var _hasUpdate:Boolean;
      
      public var active:Boolean;
      
      protected var _delay:Number;
      
      public var cachedReversed:Boolean;
      
      public var nextNode:TweenCore;
      
      public var cachedTime:Number;
      
      protected var _rawPrevTime:Number = -1;
      
      public var vars:Object;
      
      public var cachedTotalTime:Number;
      
      public var data:*;
      
      public var timeline:SimpleTimeline;
      
      public var cachedOrphan:Boolean;
      
      public var cachedStartTime:Number;
      
      public var prevNode:TweenCore;
      
      public var cachedDuration:Number;
      
      public var gc:Boolean;
      
      public var cachedPauseTime:Number;
      
      public var cacheIsDirty:Boolean;
      
      public var cachedPaused:Boolean;
      
      public var cachedTimeScale:Number;
      
      public var cachedTotalDuration:Number;
      
      public function TweenCore(param1:Number = 0, param2:Object = null)
      {
         super();
         this.vars = param2 != null ? param2 : {};
         if(this.vars.isGSVars)
         {
            this.vars = this.vars.vars;
         }
         this.cachedDuration = this.cachedTotalDuration = param1;
         _delay = this.vars.delay ? Number(this.vars.delay) : 0;
         this.cachedTimeScale = this.vars.timeScale ? Number(this.vars.timeScale) : 1;
         this.active = Boolean(param1 == 0 && _delay == 0 && this.vars.immediateRender != false);
         this.cachedTotalTime = this.cachedTime = 0;
         this.data = this.vars.data;
         if(!_classInitted)
         {
            if(!isNaN(TweenLite.rootFrame))
            {
               return;
            }
            TweenLite.initClass();
            _classInitted = true;
         }
         var _loc3_:SimpleTimeline = this.vars.timeline is SimpleTimeline ? this.vars.timeline : (this.vars.useFrames ? TweenLite.rootFramesTimeline : TweenLite.rootTimeline);
         _loc3_.insert(this,_loc3_.cachedTotalTime);
         if(this.vars.reversed)
         {
            this.cachedReversed = true;
         }
         if(this.vars.paused)
         {
            this.paused = true;
         }
      }
      
      public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
      }
      
      public function get delay() : Number
      {
         return _delay;
      }
      
      public function get duration() : Number
      {
         return this.cachedDuration;
      }
      
      public function set reversed(param1:Boolean) : void
      {
         if(param1 != this.cachedReversed)
         {
            this.cachedReversed = param1;
            setTotalTime(this.cachedTotalTime,true);
         }
      }
      
      public function set startTime(param1:Number) : void
      {
         if(this.timeline != null && (param1 != this.cachedStartTime || this.gc))
         {
            this.timeline.insert(this,param1 - _delay);
         }
         else
         {
            this.cachedStartTime = param1;
         }
      }
      
      public function restart(param1:Boolean = false, param2:Boolean = true) : void
      {
         this.reversed = false;
         this.paused = false;
         this.setTotalTime(param1 ? -_delay : 0,param2);
      }
      
      public function set delay(param1:Number) : void
      {
         this.startTime += param1 - _delay;
         _delay = param1;
      }
      
      public function resume() : void
      {
         this.paused = false;
      }
      
      public function get paused() : Boolean
      {
         return this.cachedPaused;
      }
      
      public function play() : void
      {
         this.reversed = false;
         this.paused = false;
      }
      
      public function set duration(param1:Number) : void
      {
         var _loc2_:Number = param1 / this.cachedDuration;
         this.cachedDuration = this.cachedTotalDuration = param1;
         if(this.active && !this.cachedPaused && param1 != 0)
         {
            this.setTotalTime(this.cachedTotalTime * _loc2_,true);
         }
         setDirtyCache(false);
      }
      
      public function invalidate() : void
      {
      }
      
      public function complete(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(!param1)
         {
            renderTime(this.totalDuration,param2,false);
            return;
         }
         if(this.timeline.autoRemoveChildren)
         {
            this.setEnabled(false,false);
         }
         else
         {
            this.active = false;
         }
         if(!param2)
         {
            if(this.vars.onComplete && this.cachedTotalTime >= this.cachedTotalDuration && !this.cachedReversed)
            {
               this.vars.onComplete.apply(null,this.vars.onCompleteParams);
            }
            else if(this.cachedReversed && this.cachedTotalTime == 0 && Boolean(this.vars.onReverseComplete))
            {
               this.vars.onReverseComplete.apply(null,this.vars.onReverseCompleteParams);
            }
         }
      }
      
      public function get totalTime() : Number
      {
         return this.cachedTotalTime;
      }
      
      public function get startTime() : Number
      {
         return this.cachedStartTime;
      }
      
      public function get reversed() : Boolean
      {
         return this.cachedReversed;
      }
      
      public function set currentTime(param1:Number) : void
      {
         setTotalTime(param1,false);
      }
      
      protected function setDirtyCache(param1:Boolean = true) : void
      {
         var _loc2_:TweenCore = param1 ? this : this.timeline;
         while(_loc2_)
         {
            _loc2_.cacheIsDirty = true;
            _loc2_ = _loc2_.timeline;
         }
      }
      
      public function reverse(param1:Boolean = true) : void
      {
         this.reversed = true;
         if(param1)
         {
            this.paused = false;
         }
         else if(this.gc)
         {
            this.setEnabled(true,false);
         }
      }
      
      public function set paused(param1:Boolean) : void
      {
         if(param1 != this.cachedPaused && Boolean(this.timeline))
         {
            if(param1)
            {
               this.cachedPauseTime = this.timeline.rawTime;
            }
            else
            {
               this.cachedStartTime += this.timeline.rawTime - this.cachedPauseTime;
               this.cachedPauseTime = NaN;
               setDirtyCache(false);
            }
            this.cachedPaused = param1;
            this.active = Boolean(!this.cachedPaused && this.cachedTotalTime > 0 && this.cachedTotalTime < this.cachedTotalDuration);
         }
         if(!param1 && this.gc)
         {
            this.setTotalTime(this.cachedTotalTime,false);
            this.setEnabled(true,false);
         }
      }
      
      public function kill() : void
      {
         setEnabled(false,false);
      }
      
      public function set totalTime(param1:Number) : void
      {
         setTotalTime(param1,false);
      }
      
      public function get currentTime() : Number
      {
         return this.cachedTime;
      }
      
      protected function setTotalTime(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.timeline)
         {
            _loc3_ = this.cachedPaused ? this.cachedPauseTime : this.timeline.cachedTotalTime;
            if(this.cachedReversed)
            {
               _loc4_ = this.cacheIsDirty ? this.totalDuration : this.cachedTotalDuration;
               this.cachedStartTime = _loc3_ - (_loc4_ - param1) / this.cachedTimeScale;
            }
            else
            {
               this.cachedStartTime = _loc3_ - param1 / this.cachedTimeScale;
            }
            if(!this.timeline.cacheIsDirty)
            {
               setDirtyCache(false);
            }
            if(this.cachedTotalTime != param1)
            {
               renderTime(param1,param2,false);
            }
         }
      }
      
      public function pause() : void
      {
         this.paused = true;
      }
      
      public function set totalDuration(param1:Number) : void
      {
         this.duration = param1;
      }
      
      public function get totalDuration() : Number
      {
         return this.cachedTotalDuration;
      }
      
      public function setEnabled(param1:Boolean, param2:Boolean = false) : Boolean
      {
         this.gc = !param1;
         if(param1)
         {
            this.active = Boolean(!this.cachedPaused && this.cachedTotalTime > 0 && this.cachedTotalTime < this.cachedTotalDuration);
            if(!param2 && this.cachedOrphan)
            {
               this.timeline.insert(this,this.cachedStartTime - _delay);
            }
         }
         else
         {
            this.active = false;
            if(!param2 && !this.cachedOrphan)
            {
               this.timeline.remove(this,true);
            }
         }
         return false;
      }
   }
}

