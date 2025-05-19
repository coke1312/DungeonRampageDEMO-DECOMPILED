package Actor.Buffs
{
   import Actor.ActorView;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Facade.DBFacade;
   import Floor.FloorView;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   
   public class BuffView extends FloorView
   {
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mBuff:MovieClip;
      
      private var mParentGameObject:BuffGameObject;
      
      private var mParentView:ActorView;
      
      private var mTintColor:Number;
      
      private var mTintAmount:Number;
      
      protected var mTween:TweenMax;
      
      protected var mSortLayer:String;
      
      private var mNewScale:Number;
      
      private var mOriginalScale:Number;
      
      private var mScaleUpStartDelayTime:Number;
      
      private var mScaleUpIncrementTime:Number;
      
      private var mScaleUpIncrementScale:Number;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mHideTween:TweenMax;
      
      private var mShowTween:TweenMax;
      
      public function BuffView(param1:DBFacade, param2:BuffGameObject, param3:ActorView, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number)
      {
         mParentView = param3;
         mParentGameObject = param2;
         mTintColor = param4;
         mTintAmount = param5;
         mSortLayer = param2.mSortLayer;
         mNewScale = param6;
         mScaleUpStartDelayTime = param7;
         mScaleUpIncrementTime = param8;
         mScaleUpIncrementScale = param9;
         mLogicalWorkComponent = new LogicalWorkComponent(param1);
         super(param1,param2);
         if(param2.className)
         {
            mAssetLoadingComponent = new AssetLoadingComponent(mFacade);
            mAssetLoadingComponent.getSwfAsset(param2.swfPath,assetLoaded);
         }
         else
         {
            checkForScaling();
         }
      }
      
      private function assetLoaded(param1:SwfAsset) : void
      {
         var _loc2_:Class = param1.getClass(mParentGameObject.className);
         if(mFacade == null)
         {
            return;
         }
         if(_loc2_)
         {
            mBuff = new _loc2_();
            mMovieClipRenderer = new MovieClipRenderController(mFacade,mBuff,finishedCallback);
            mMovieClipRenderer.play(0,true);
            mParentView.buildBuff(mBuff,mSortLayer);
            if(mTintColor != -1)
            {
               mTween = TweenMax.fromTo(mParentView.body,mMovieClipRenderer.durationInSeconds * 0.5,{"colorMatrixFilter":{}},{
                  "repeat":-1,
                  "yoyo":true,
                  "colorMatrixFilter":{
                     "colorize":mTintColor,
                     "amount":mTintAmount
                  }
               });
            }
            checkForScaling();
         }
         else
         {
            Logger.warn(mParentGameObject.className + " doesn\'t exist !");
         }
      }
      
      private function checkForScaling() : void
      {
         if(mNewScale)
         {
            mOriginalScale = mParentView.root.scaleX;
            if(mScaleUpIncrementScale == 0 || mScaleUpIncrementTime == 0)
            {
               mParentView.root.scaleX = mParentView.root.scaleY = mNewScale;
            }
            else
            {
               mLogicalWorkComponent.doLater(mScaleUpStartDelayTime,delayStartScaling);
            }
         }
      }
      
      private function delayStartScaling(param1:GameClock) : void
      {
         mLogicalWorkComponent.doEverySeconds(mScaleUpIncrementTime,scaleUpCall);
      }
      
      private function scaleUpCall(param1:GameClock) : void
      {
         var gameClock:GameClock = param1;
         if(mParentView.root.scaleX <= mNewScale - mScaleUpIncrementScale)
         {
            mParentView.root.scaleX += mScaleUpIncrementScale;
            mParentView.root.scaleY += mScaleUpIncrementScale;
            TweenMax.to(mParentView.body,mScaleUpIncrementTime / 2,{
               "tint":mTintColor,
               "onCompleteListener":function():void
               {
                  TweenMax.to(mParentView.body,0,{"removeTint":true});
               }
            });
         }
         else
         {
            mParentView.root.scaleX = mParentView.root.scaleY = mNewScale;
            mLogicalWorkComponent.clear();
         }
      }
      
      public function showInHUD() : void
      {
         mDBFacade.hud.showBuffDisplay(mParentGameObject);
      }
      
      override public function destroy() : void
      {
         if(mFacade == null)
         {
            return;
         }
         if(mNewScale)
         {
            TweenMax.to(mParentView.root,0.3,{
               "scaleX":mOriginalScale,
               "scaleY":mOriginalScale
            });
         }
         if(mAssetLoadingComponent != null)
         {
            mAssetLoadingComponent.destroy();
            mAssetLoadingComponent = null;
         }
         if(mMovieClipRenderer)
         {
            mMovieClipRenderer.destroy();
            mMovieClipRenderer = null;
         }
         if(mTween != null)
         {
            mTween.complete();
            mTween.kill();
            mTween = null;
         }
         if(mHideTween != null)
         {
            mHideTween.complete();
            mHideTween.kill();
            mHideTween = null;
         }
         if(mShowTween != null)
         {
            mShowTween.complete();
            mShowTween.kill();
            mShowTween = null;
         }
         if(mParentView != null)
         {
            mParentView.destroyBuff(mBuff);
         }
         super.destroy();
      }
      
      public function finishedCallback() : void
      {
      }
      
      public function hide(param1:Number) : void
      {
         var transitionTime:Number = param1;
         if(mBuff != null)
         {
            mHideTween = TweenMax.to(mBuff,transitionTime,{
               "alpha":0,
               "onCompleteListener":function():void
               {
                  mBuff.visible = false;
                  mBuff.alpha = 1;
               }
            });
         }
      }
      
      public function show(param1:Number) : void
      {
         mBuff.alpha = 0;
         mBuff.visible = true;
         mShowTween = TweenMax.to(mBuff,param1,{"alpha":1});
      }
   }
}

