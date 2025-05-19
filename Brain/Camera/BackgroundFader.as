package Brain.Camera
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   
   public class BackgroundFader
   {
      
      public static const TYPE:String = "fadebackground";
      
      private var mFacade:Facade;
      
      private var mExcludes:Array;
      
      private var mRectSprite:Sprite;
      
      private var mDuration:uint;
      
      private var mTransitionDuration:Number;
      
      private var mColor:Vector3D;
      
      private var mOffset:Number;
      
      private var mAlpha:Number;
      
      private var mWorkComponent:LogicalWorkComponent;
      
      private var mFadeTask:Task;
      
      private var mFramesElapsed:uint;
      
      private var mStartTop:Number;
      
      private var mStartLeft:Number;
      
      private const mPadding:Number = 512;
      
      public function BackgroundFader(param1:Facade)
      {
         super();
         mFramesElapsed = 0;
         mFacade = param1;
         mWorkComponent = new LogicalWorkComponent(param1);
      }
      
      public function doFade(param1:Array, param2:uint, param3:Number, param4:Vector3D, param5:Number) : void
      {
         var _loc6_:int = 0;
         if(!mRectSprite)
         {
            mDuration = param2;
            mTransitionDuration = param3;
            mColor = new Vector3D(param4.x,param4.y,param4.z);
            mAlpha = param5;
            mOffset = param5 / param3;
            mExcludes = param1;
            execute();
         }
         else
         {
            _loc6_ = mDuration - mFramesElapsed;
            mDuration = _loc6_ > param2 ? _loc6_ : param2;
            mTransitionDuration = param3;
            mFramesElapsed = 0;
            mAlpha = mAlpha > param5 ? mAlpha : param5;
            mOffset = mAlpha / mTransitionDuration;
         }
      }
      
      private function execute() : void
      {
         if(mFramesElapsed != 0)
         {
            ResetFade();
         }
         mFramesElapsed = 0;
         mRectSprite = new Sprite();
         mRectSprite.graphics.beginFill(mColor.x << 16 | mColor.y << 8 | mColor.z,1);
         mStartTop = mFacade.camera.visibleRectangle.top - 512 * 0.5;
         mStartLeft = mFacade.camera.visibleRectangle.left - 512 * 0.5;
         mRectSprite.graphics.drawRect(mStartLeft,mStartTop,mFacade.stageRef.fullScreenWidth + 512,mFacade.stageRef.fullScreenHeight + 512);
         mRectSprite.graphics.endFill();
         mRectSprite.cacheAsBitmap = true;
         mRectSprite.alpha = 0;
         mFacade.sceneGraphManager.addChild(mRectSprite,42);
         for each(var _loc1_ in mExcludes)
         {
            mFacade.sceneGraphManager.addChild(_loc1_,46);
         }
         mFadeTask = mWorkComponent.doEveryFrame(UpdateBackgroundFade);
      }
      
      public function UpdateBackgroundFade(param1:GameClock) : void
      {
         if(!mRectSprite)
         {
            Logger.error("BackgroundFader with null RectSprite");
            return;
         }
         mRectSprite.x = mFacade.camera.visibleRectangle.left - mStartLeft - 512 * 0.5;
         mRectSprite.y = mFacade.camera.visibleRectangle.top - mStartTop - 512 * 0.5;
         ++mFramesElapsed;
         if(mFramesElapsed <= mTransitionDuration)
         {
            mRectSprite.alpha += mOffset;
            mRectSprite.alpha = Math.min(mRectSprite.alpha,mAlpha);
         }
         else if(mFramesElapsed >= mDuration - mTransitionDuration)
         {
            mRectSprite.alpha -= mOffset;
            mRectSprite.alpha = Math.max(mRectSprite.alpha,0);
         }
         if(mFramesElapsed > mDuration)
         {
            ResetFade();
            return;
         }
      }
      
      private function ResetFade() : void
      {
         mFramesElapsed = 0;
         mFacade.sceneGraphManager.removeChild(mRectSprite);
         for each(var _loc1_ in mExcludes)
         {
            mFacade.sceneGraphManager.addChild(_loc1_,20);
         }
         mExcludes = null;
         mRectSprite = null;
         mFadeTask.destroy();
         mFadeTask = null;
      }
      
      public function forceStop() : void
      {
         if(mFadeTask && mRectSprite)
         {
            ResetFade();
         }
      }
   }
}

