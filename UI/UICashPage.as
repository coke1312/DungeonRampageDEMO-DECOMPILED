package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Brain.UI.UIButton;
   import Brain.UI.UIRadioButton;
   import Facade.DBFacade;
   import Facade.Locale;
   import flash.display.MovieClip;
   
   public class UICashPage extends DBUIPopup
   {
      
      public static var IsPopupOpen:Boolean = false;
      
      protected var mBuyButton:UIButton;
      
      protected var mBuyCallback:Function;
      
      protected var mEarnButton:UIButton;
      
      protected var mDealMovieClips:Vector.<MovieClip>;
      
      protected var mDealRadioButtons:Vector.<UIRadioButton>;
      
      protected var mSelectedDeal:uint = 0;
      
      protected var mDealPriceMultiplier:Number = 1;
      
      public function UICashPage(param1:DBFacade, param2:Function, param3:Function)
      {
         var dbFacade:DBFacade = param1;
         var buyCallback:Function = param2;
         var closeCallback:Function = param3;
         if(IsPopupOpen)
         {
            Logger.warn("Cash page already open!");
         }
         IsPopupOpen = true;
         mBuyCallback = buyCallback;
         loadSplitTestData(dbFacade);
         mDealMovieClips = new Vector.<MovieClip>();
         super(dbFacade,Locale.getString("CASH_PAGE_TITLE"),null,true,true,function():void
         {
            dbFacade.metrics.log("ShopCashPageCancel");
            if(closeCallback != null)
            {
               closeCallback();
            }
         });
         this.buyDRApology();
      }
      
      public static function getCashSaleValue(param1:DBFacade) : Number
      {
         return param1.getSplitTestNumber("GemSale1",1);
      }
      
      private function loadSplitTestData(param1:DBFacade) : void
      {
         mDealPriceMultiplier = getCashSaleValue(param1);
      }
      
      override public function destroy() : void
      {
         IsPopupOpen = false;
         mBuyCallback = null;
         mDealMovieClips = null;
         if(mBuyButton)
         {
            mBuyButton.destroy();
         }
         if(mEarnButton)
         {
            mEarnButton.destroy();
         }
         super.destroy();
      }
      
      private function getCurrencySymbol(param1:String) : String
      {
         if(param1 == "USD")
         {
            return "$";
         }
         return "";
      }
      
      private function buy() : void
      {
      }
      
      private function buyDRApology() : void
      {
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var _loc4_:Class = param1.getClass("popup_coming_soon_content");
            var _loc3_:MovieClip = new _loc4_() as MovieClip;
            _loc3_.message_label.text = Locale.getString("DR_APOLOGY_CONTENT");
            var _loc2_:DBUIPopup = new DBUIPopup(mDBFacade,Locale.getString("DR_APOLOGY_TITLE"),_loc3_,true,true,null,true);
         });
         this.destroy();
      }
      
      private function earn() : void
      {
         this.buyDRApology();
      }
   }
}

