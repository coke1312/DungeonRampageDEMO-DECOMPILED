package Brain.UI
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   
   public class UICircularProgressBar extends UIObject
   {
      
      protected var mDuration:Number;
      
      protected var mDeltaAngle:Number;
      
      protected var mCurrentAngle:Number;
      
      protected var mCurrentX:Number;
      
      protected var mCurrentY:Number;
      
      protected var mColor:uint;
      
      protected var mRadius:Number;
      
      protected var mStartAngle:Number;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mGraphics:Graphics;
      
      protected var mEmptyClip:MovieClip;
      
      protected var mStartTime:Number;
      
      protected var mDrawTask:Task;
      
      public function UICircularProgressBar(param1:Facade, param2:MovieClip, param3:Number, param4:uint, param5:Number, param6:Number = 1, param7:Number = 180)
      {
         super(param1,param2);
         mLogicalWorkComponent = new LogicalWorkComponent(param1);
         mEmptyClip = new MovieClip();
         mGraphics = mEmptyClip.graphics;
         param2.addChildAt(mEmptyClip,param2.numChildren);
         mStartAngle = param7;
         mDuration = param5;
         mDeltaAngle = param6;
         mRadius = param3;
         mColor = param4;
         mCurrentAngle = param7;
         calculateStep();
      }
      
      private function killDrawTask(param1:GameClock) : void
      {
         mGraphics.clear();
         mDrawTask.destroy();
      }
      
      private function calculateStep() : void
      {
         var _loc1_:Number = mCurrentAngle * 3.141592653589793 / 180;
         mCurrentX = mRadius * Math.sin(_loc1_);
         mCurrentY = mRadius * Math.cos(_loc1_);
      }
      
      public function get clip() : MovieClip
      {
         return mEmptyClip;
      }
      
      public function set clip(param1:MovieClip) : void
      {
         mEmptyClip = param1;
      }
      
      public function get angle() : Number
      {
         return mCurrentAngle;
      }
      
      public function set angle(param1:Number) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = Math.round(param1 / mDeltaAngle);
         var _loc3_:Number = mCurrentAngle * 3.141592653589793 / 180;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc2_ = mRadius * Math.sin(_loc3_);
            _loc5_ = mRadius * Math.cos(_loc3_);
            mGraphics.moveTo(mCurrentX,mCurrentY);
            mGraphics.lineStyle(5,mColor);
            mGraphics.lineTo(_loc2_,_loc5_);
            mGraphics.endFill();
            mCurrentX = _loc2_;
            mCurrentY = _loc5_;
            mCurrentAngle -= mDeltaAngle;
            _loc4_++;
         }
      }
      
      public function set updateTask(param1:Task) : void
      {
         mDrawTask = param1;
      }
      
      override public function destroy() : void
      {
         if(mDrawTask)
         {
            mDrawTask.destroy();
         }
         mDrawTask = null;
         super.destroy();
      }
   }
}

