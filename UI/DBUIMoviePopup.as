package UI
{
   import Brain.UI.UIButton;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class DBUIMoviePopup extends DBUIOneButtonPopup
   {
      
      private static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_screens.swf";
      
      private var mContainerMC:MovieClip = new MovieClip();
      
      private var mLoader:Loader;
      
      private var mMoviePlayer:Object;
      
      private var mWidth:Number = width;
      
      private var mHeight:Number = height;
      
      private var mPopUpClassName:String = popUpClassName;
      
      private var mLoadingPopUp:DBUIPopup;
      
      private var mUseCurtain:Boolean = !showPagination;
      
      public function DBUIMoviePopup(param1:DBFacade, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Function, param8:Number, param9:Number, param10:Boolean)
      {
         var dbFacade:DBFacade = param1;
         var popUpClassName:String = param2;
         var titleText:String = param3;
         var contentText:String = param4;
         var moviePath:String = param5;
         var centerText:String = param6;
         var centerCallback:Function = param7;
         var width:Number = param8;
         var height:Number = param9;
         var showPagination:Boolean = param10;
         super(dbFacade,titleText,mContainerMC,centerText,centerCallback);
         mMessage.text = contentText;
         mLoadingPopUp = new DBUIPopup(mDBFacade,"LOADING",null,true,false);
         mLoader = new Loader();
         mLoader.contentLoaderInfo.addEventListener("init",onLoaderInit);
         mLoader.contentLoaderInfo.addEventListener("ioError",loaderIOErrorHandler);
         mLoader.load(new URLRequest(moviePath));
         if(!showPagination)
         {
            mPopup.center_button_news.visible = false;
            mPopup.pagination.visible = false;
         }
         else
         {
            mPopup.center_button.visible = false;
            mCenterButton = new UIButton(mDBFacade,mPopup.center_button_news);
            mCenterButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
            mCenterButton.label.text = mCenterText;
            mCenterButton.releaseCallback = function():void
            {
               close(mCenterCallback);
            };
         }
      }
      
      override protected function animatedEntrance() : void
      {
         super.animatedEntrance();
      }
      
      override public function getPagination() : MovieClip
      {
         return mPopup.pagination;
      }
      
      override protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_screens.swf";
      }
      
      override protected function getClassName() : String
      {
         return mPopUpClassName;
      }
      
      private function loaderIOErrorHandler(param1:IOErrorEvent) : void
      {
         mLoadingPopUp.destroy();
         mLoadingPopUp = null;
         destroy();
      }
      
      private function onLoaderInit(param1:Event) : void
      {
         mContainerMC.addChild(mLoader);
         mLoader.x = -mWidth / 2;
         mLoader.y = -mHeight / 2;
         mLoader.content.addEventListener("onReady",onPlayerReady);
         mLoader.content.addEventListener("onError",onPlayerError);
         mLoader.content.addEventListener("onStateChange",onPlayerStateChange);
         mLoader.content.addEventListener("onPlaybackQualityChange",onVideoPlaybackQualityChange);
      }
      
      private function onPlayerReady(param1:Event) : void
      {
         mLoadingPopUp.destroy();
         mLoadingPopUp = null;
         mMoviePlayer = mLoader.content;
         mMoviePlayer.setSize(mWidth,mHeight);
      }
      
      private function onPlayerError(param1:Event) : void
      {
         mLoadingPopUp.destroy();
         mLoadingPopUp = null;
      }
      
      private function onPlayerStateChange(param1:Event) : void
      {
      }
      
      private function onVideoPlaybackQualityChange(param1:Event) : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         mContainerMC = null;
         mLoader.contentLoaderInfo.removeEventListener("init",onLoaderInit);
         if(mLoader.content)
         {
            mLoader.content.removeEventListener("onReady",onPlayerReady);
            mLoader.content.removeEventListener("onError",onPlayerError);
            mLoader.content.removeEventListener("onStateChange",onPlayerStateChange);
            mLoader.content.removeEventListener("onPlaybackQualityChange",onVideoPlaybackQualityChange);
            mLoader.unloadAndStop();
         }
         mLoader = null;
      }
   }
}

