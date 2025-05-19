package Effects
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Facade.DBFacade;
   import Floor.FloorView;
   import flash.display.MovieClip;
   
   public class EffectView extends FloorView
   {
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mEffect:MovieClip;
      
      private var mEffectClassName:String;
      
      protected var mLoop:Boolean;
      
      private var mShouldBePlaying:ShouldBePlaying;
      
      protected var mAssetLoadedCallback:Function;
      
      public function EffectView(param1:DBFacade, param2:EffectGameObject, param3:Function = null)
      {
         super(param1,param2);
         mAssetLoadingComponent = new AssetLoadingComponent(mFacade);
         mEffectClassName = param2.className;
         mAssetLoadedCallback = param3;
         mAssetLoadingComponent.getSwfAsset(param2.swfPath,assetLoaded);
      }
      
      public function setPlayRate(param1:Number) : void
      {
         if(mMovieClipRenderer)
         {
            mMovieClipRenderer.playRate = param1;
         }
      }
      
      public function play(param1:Boolean, param2:Function) : void
      {
         if(mMovieClipRenderer)
         {
            mMovieClipRenderer.play(0,param1,param2);
         }
         else
         {
            mShouldBePlaying = new ShouldBePlaying(param1,param2);
         }
      }
      
      public function stop() : void
      {
         mShouldBePlaying = null;
         if(mMovieClipRenderer)
         {
            mMovieClipRenderer.stop();
            mMovieClipRenderer.finishedCallback = null;
         }
         this.removeFromStage();
         if(mRoot.parent)
         {
            mRoot.parent.removeChild(mRoot);
         }
      }
      
      private function assetLoaded(param1:SwfAsset) : void
      {
         var _loc2_:Class = param1.getClass(mEffectClassName);
         if(_loc2_ == null)
         {
            Logger.error("Unable to find class: " + mEffectClassName);
            return;
         }
         mEffect = new _loc2_();
         mMovieClipRenderer = new MovieClipRenderController(mFacade,mEffect);
         if(mShouldBePlaying)
         {
            mMovieClipRenderer.play(0,mShouldBePlaying.loop,mShouldBePlaying.finishedCallback);
         }
         mRoot.mouseChildren = false;
         mRoot.mouseEnabled = false;
         mRoot.addChild(mEffect);
         if(mAssetLoadedCallback != null)
         {
            mAssetLoadedCallback(mEffect);
         }
      }
      
      override public function destroy() : void
      {
         mEffect = null;
         if(mAssetLoadingComponent)
         {
            mAssetLoadingComponent.destroy();
            mAssetLoadingComponent = null;
         }
         super.destroy();
      }
   }
}

class ShouldBePlaying
{
   
   public var loop:Boolean;
   
   public var finishedCallback:Function;
   
   public function ShouldBePlaying(param1:Boolean, param2:Function)
   {
      super();
      loop = param1;
      finishedCallback = param2;
   }
}
