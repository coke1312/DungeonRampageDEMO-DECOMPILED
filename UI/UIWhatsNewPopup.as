package UI
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.ImageAsset;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Brain.UI.UIButton;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class UIWhatsNewPopup extends DBUITwoButtonPopup
   {
      
      private static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_screens.swf";
      
      private var mPopUpClassName:String = "whatsnew_popup";
      
      private var mImageURL:String;
      
      private var mImageLocator:MovieClip;
      
      private var massetLoadingComponent:AssetLoadingComponent;
      
      private var mLoadingPopUp:DBUIPopup;
      
      private var mImageRetreived:Boolean = false;
      
      private var mUseCurtain:Boolean = true;
      
      public function UIWhatsNewPopup(param1:DBFacade, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Function, param8:String, param9:String, param10:Boolean)
      {
         var webCallback:Function;
         var dbFacade:DBFacade = param1;
         var popupClassName:String = param2;
         var titleText:String = param3;
         var messageText:String = param4;
         var imageURL:String = param5;
         var mainText:String = param6;
         var mainCallback:Function = param7;
         var webText:String = param8;
         var webURL:String = param9;
         var showPagination:Boolean = param10;
         massetLoadingComponent = new AssetLoadingComponent(dbFacade);
         mImageURL = imageURL;
         mPopUpClassName = popupClassName;
         if(webURL)
         {
            webCallback = function():void
            {
               var _loc1_:URLRequest = new URLRequest(webURL);
               navigateToURL(_loc1_,"_blank");
            };
         }
         mUseCurtain = !showPagination;
         super(dbFacade,titleText,messageText,mainText,mainCallback,webText,webCallback);
         if(!mImageRetreived)
         {
            mLoadingPopUp = new DBUIPopup(mDBFacade,"LOADING");
         }
         if(!showPagination)
         {
            mPopup.left_button_news.visible = false;
            mPopup.pagination.visible = false;
         }
         else
         {
            mPopup.left_button.visible = false;
            mLeftButton = new UIButton(mDBFacade,mPopup.left_button_news);
            mLeftButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
            mLeftButton.label.text = mLeftText;
            mLeftButton.releaseCallback = function():void
            {
               close(mLeftCallback);
            };
         }
      }
      
      override protected function animatedEntrance() : void
      {
         if(mUseCurtain)
         {
            super.animatedEntrance();
         }
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
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         super.setupUI(swfAsset,titleText.toLocaleUpperCase(),content,allowClose,closeCallback);
         Logger.debug("MOD: mPopup: " + mPopup);
         mImageLocator = mPopup.whatsnew_image;
         Logger.debug("MOD: ImageLocator: " + mImageLocator);
         massetLoadingComponent.getImageAsset(mImageURL,function(param1:ImageAsset):void
         {
            if(mLoadingPopUp)
            {
               mLoadingPopUp.destroy();
               mLoadingPopUp = null;
            }
            Logger.debug("MOD: ImageAsset: " + param1);
            mImageLocator.addChild(param1.image);
            param1.image.x = param1.image.width * -0.5;
            param1.image.y = param1.image.height * -0.5;
            mImageRetreived = true;
         },function():void
         {
            if(mLoadingPopUp)
            {
               mLoadingPopUp.destroy();
               mLoadingPopUp = null;
            }
         });
      }
      
      override public function destroy() : void
      {
         if(massetLoadingComponent != null)
         {
            massetLoadingComponent.destroy();
            massetLoadingComponent = null;
         }
         super.destroy();
         mImageLocator = null;
      }
   }
}

