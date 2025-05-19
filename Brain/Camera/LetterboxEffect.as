package Brain.Camera
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   
   public class LetterboxEffect
   {
      
      private var mFacade:Facade;
      
      private var mRectSprite:Sprite;
      
      private var mDuration:uint;
      
      private var mTransitionDuration:Number;
      
      private var mColor:Vector3D;
      
      private var mOffset:Number;
      
      private var mAlpha:Number;
      
      private var mWorkComponent:LogicalWorkComponent;
      
      private var mFadeTask:Task;
      
      private var mFramesElapsed:uint;
      
      private const mPadding:Number = 512;
      
      public function LetterboxEffect(param1:Facade)
      {
         super();
         mFramesElapsed = 0;
         mFacade = param1;
         mWorkComponent = new LogicalWorkComponent(param1);
      }
      
      public function doFade(param1:uint, param2:Number, param3:Vector3D, param4:Number) : void
      {
         var _loc5_:int = 0;
         if(!mRectSprite)
         {
            mDuration = param1;
            mTransitionDuration = param2;
            mColor = new Vector3D(param3.x,param3.y,param3.z);
            mAlpha = param4;
            mOffset = param4 / param2;
            execute();
         }
         else
         {
            _loc5_ = mDuration - mFramesElapsed;
            mDuration = _loc5_ > param1 ? _loc5_ : param1;
            mTransitionDuration = param2;
            mFramesElapsed = 0;
            mAlpha = mAlpha > param4 ? mAlpha : param4;
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
         mRectSprite.graphics.drawRect(0,0,mFacade.stageRef.fullScreenWidth + 512,75);
         mRectSprite.graphics.drawRect(0,mFacade.stageRef.fullScreenHeight - 550,mFacade.stageRef.fullScreenWidth + 512,375);
         mRectSprite.graphics.endFill();
         mRectSprite.cacheAsBitmap = true;
         mRectSprite.alpha = 0;
         mFacade.sceneGraphManager.addChild(mRectSprite,100);
         mFadeTask = mWorkComponent.doEveryFrame(UpdateBackgroundFade);
      }
      
      public function UpdateBackgroundFade(param1:GameClock) : void
      {
         if(!mRectSprite)
         {
            Logger.warn("LetterboxEffect with null RectSprite");
            return;
         }
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
         else if(mFramesElapsed > mTransitionDuration)
         {
            mRectSprite.alpha = mAlpha;
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

