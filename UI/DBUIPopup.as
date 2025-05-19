package UI
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Brain.UI.UIButton;
   import Brain.UI.UIObject;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMOffer;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class DBUIPopup extends UIObject
   {
      
      protected static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_town.swf";
      
      protected static const POPUP_CLASS_NAME:String = "popup";
      
      protected static const EMPTY_POPUP_CLASS_NAME:String = "UI_loading_popup";
      
      protected static const CURTAIN_ALPHA:Number = 0.75;
      
      private var mUseOriginalPopUp:Boolean = false;
      
      protected var mDBFacade:DBFacade = dbFacade;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mWantCurtain:Boolean;
      
      protected var mCurtainActive:Boolean = false;
      
      protected var mTitle:TextField;
      
      protected var mMessage:TextField;
      
      protected var mContent:Sprite;
      
      protected var mCloseButton:UIButton;
      
      protected var mCloseCallback:Function;
      
      protected var mPopup:MovieClip;
      
      protected var mSwfAsset:SwfAsset;
      
      public function DBUIPopup(param1:DBFacade, param2:String = "", param3:* = null, param4:Boolean = true, param5:Boolean = true, param6:Function = null, param7:Boolean = false)
      {
         var dbFacade:DBFacade = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var wantCurtain:Boolean = param5;
         var closeCallback:Function = param6;
         var useOriginalPopUp:Boolean = param7;
         super(dbFacade,new MovieClip());
         mUseOriginalPopUp = useOriginalPopUp;
         mWantCurtain = wantCurtain;
         makeCurtain();
         if(allowClose)
         {
            mCloseCallback = closeCallback;
            mDBFacade.stageRef.addEventListener("keyDown",handleKeyDown);
         }
         mDBFacade.sceneGraphManager.addChild(mRoot,105);
         mAssetLoadingComponent = new AssetLoadingComponent(dbFacade);
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(getSwfPath()),function(param1:SwfAsset):void
         {
            setupUI(param1,titleText,content,allowClose,closeCallback);
         });
      }
      
      public function getPagination() : MovieClip
      {
         Logger.error("Pagination for UIPopup shouldn\'t be available here.");
         return null;
      }
      
      protected function useCurtain() : Boolean
      {
         return true;
      }
      
      protected function makeCurtain() : void
      {
         if(!mCurtainActive)
         {
            mFacade.sceneGraphManager.showPopupCurtain();
            mCurtainActive = true;
         }
      }
      
      protected function removeCurtain() : void
      {
         if(mCurtainActive)
         {
            mCurtainActive = false;
            mFacade.sceneGraphManager.removePopupCurtain();
         }
      }
      
      protected function animatedEntrance() : void
      {
         makeCurtain();
      }
      
      override public function destroy() : void
      {
         if(mDBFacade == null)
         {
            return;
         }
         TweenMax.killTweensOf(mRoot);
         removeCurtain();
         mDBFacade.stageRef.removeEventListener("keyDown",handleKeyDown);
         mDBFacade = null;
         mCloseCallback = null;
         if(mCloseButton)
         {
            mCloseButton.destroy();
         }
         mAssetLoadingComponent.destroy();
         mPopup = null;
         super.destroy();
      }
      
      protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_town.swf";
      }
      
      protected function getClassName() : String
      {
         return mUseOriginalPopUp ? "popup" : "UI_loading_popup";
      }
      
      public function colorizeMessage(param1:TextFormat, param2:int, param3:int) : void
      {
         mMessage.setTextFormat(param1,param2,param3);
      }
      
      protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         mSwfAsset = swfAsset;
         var popupClass:Class = swfAsset.getClass(this.getClassName());
         mPopup = new popupClass() as MovieClip;
         mRoot.addChild(mPopup);
         if(mPopup.message_label)
         {
            mPopup.message_label.mouseEnabled = false;
         }
         if(mPopup.left_button)
         {
            mPopup.left_button.visible = false;
         }
         if(mPopup.center_button)
         {
            mPopup.center_button.visible = false;
         }
         if(mPopup.right_button)
         {
            mPopup.right_button.visible = false;
         }
         if(mPopup.title_label)
         {
            mTitle = mPopup.title_label;
            mTitle.text = titleText;
         }
         if(mPopup.message_label)
         {
            mMessage = mPopup.message_label;
            mMessage.text = "";
         }
         if(content is MovieClip)
         {
            mContent = mPopup.content;
            mContent.addChild(content);
         }
         else if(content is String)
         {
            mMessage.text = content;
         }
         if(mPopup.close)
         {
            if(allowClose)
            {
               mCloseButton = new UIButton(mDBFacade,mPopup.close);
               mCloseButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
               mCloseButton.releaseCallback = function():void
               {
                  close(closeCallback);
               };
            }
            else
            {
               mPopup.close.visible = false;
            }
         }
         if(mWantCurtain)
         {
            animatedEntrance();
         }
      }
      
      protected function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 27)
         {
            this.close(mCloseCallback);
         }
      }
      
      protected function close(param1:Function, param2:GMOffer = null) : void
      {
         if(param1 != null)
         {
            if(param2 == null)
            {
               param1();
            }
            else
            {
               param1(param2.getDisplayName(mDBFacade.gameMaster,Locale.getString("GIFT_UNKNOWN_NAME")),param2.Id);
            }
         }
         this.destroy();
      }
   }
}

