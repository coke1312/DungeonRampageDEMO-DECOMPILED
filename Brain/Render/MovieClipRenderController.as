package Brain.Render
{
   import Brain.Facade.Facade;
   import Brain.Utils.IPoolable;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   
   public class MovieClipRenderController implements IPoolable
   {
      
      protected var mClip:MovieClip;
      
      protected var mFacade:Facade;
      
      protected var mRenderer:MovieClipRenderer;
      
      protected var mStartScaleX:Number;
      
      protected var mStartScaleY:Number;
      
      public var swfPath:String = "";
      
      public var className:String = "";
      
      public function MovieClipRenderController(param1:Facade, param2:MovieClip, param3:Function = null)
      {
         super();
         mFacade = param1;
         mClip = param2;
         mStartScaleX = mClip.scaleX;
         mStartScaleY = mClip.scaleY;
         determineRenderer(param3);
      }
      
      public function postCheckout(param1:Boolean) : void
      {
         if(!param1)
         {
            mClip.scaleX = mStartScaleX;
            mClip.scaleY = mStartScaleY;
         }
      }
      
      public function postCheckin() : void
      {
         this.stop();
         if(mClip.parent)
         {
            mClip.parent.removeChild(mClip);
         }
      }
      
      public function getPoolKey() : String
      {
         return swfPath + ":" + className;
      }
      
      private function determineRenderer(param1:Function) : void
      {
         for each(var _loc2_ in mClip.currentLabels)
         {
            if(_loc2_.name.indexOf("random") >= 0)
            {
               mRenderer = new MovieClipRandomRenderer(mFacade,mClip,param1);
               return;
            }
            if(_loc2_.name == "pause")
            {
               mRenderer = new MovieClipCutsceneRenderer(mFacade,mClip,param1);
               return;
            }
         }
         mRenderer = new MovieClipRenderer(mFacade,mClip,param1);
      }
      
      public function destroy() : void
      {
         if(mRenderer)
         {
            mRenderer.destroy();
         }
         mRenderer = null;
         mFacade = null;
         mClip = null;
      }
      
      public function stop() : void
      {
         mRenderer.stop();
      }
      
      public function play(param1:uint = 0, param2:Boolean = false, param3:Function = null) : void
      {
         mRenderer.play(param1,param2,param3);
      }
      
      public function set finishedCallback(param1:Function) : void
      {
         mRenderer.finishedCallback = param1;
      }
      
      public function setFrame(param1:uint) : void
      {
         mRenderer.setFrame(param1);
      }
      
      public function get currentFrame() : uint
      {
         return mRenderer.currentFrame;
      }
      
      public function get clip() : MovieClip
      {
         return mRenderer.clip;
      }
      
      public function get durationInSeconds() : Number
      {
         return mRenderer.duration;
      }
      
      public function get frameCount() : Number
      {
         return mRenderer.numFrames;
      }
      
      public function get isPlaying() : Boolean
      {
         return mRenderer.isPlaying;
      }
      
      public function set frameRate(param1:Number) : void
      {
         mRenderer.frameRate = param1;
      }
      
      public function set startFrame(param1:uint) : void
      {
         mRenderer.startFrame = param1;
      }
      
      public function get loop() : Boolean
      {
         return mRenderer.loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         mRenderer.loop = param1;
      }
      
      public function get playRate() : Number
      {
         return mRenderer.playRate;
      }
      
      public function set playRate(param1:Number) : void
      {
         mRenderer.playRate = param1;
      }
   }
}

