package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.UI.UIButton;
   import Facade.DBFacade;
   import GameMasterDictionary.GMOffer;
   import flash.display.MovieClip;
   
   public class UIOfferPopup extends DBUIPopup
   {
      
      private static const TEMPLATE_CLASSNAME:String = "shop_offer_template";
      
      private static const PREMIUM_TEMPLATE_CLASSNAME:String = "shop_offer_premium_template";
      
      private static const POPUP_CLASS_NAME:String = "coin_purchase_popup";
      
      protected var mOfferIds:Vector.<uint>;
      
      protected var mBuyCallback:Function;
      
      protected var mOfferTemplateClass:Class;
      
      protected var mPremiumOfferTemplateClass:Class;
      
      protected var mUIOffers:Vector.<UIShopOffer> = new Vector.<UIShopOffer>();
      
      protected var mEmptyOffers:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var mUseIconScaling:Boolean;
      
      public function UIOfferPopup(param1:DBFacade, param2:String, param3:Vector.<uint>, param4:Function, param5:Function, param6:Boolean = true)
      {
         mOfferIds = param3;
         mBuyCallback = param4;
         mUseIconScaling = param6;
         super(param1,param2,null,true,true,param5);
      }
      
      override public function destroy() : void
      {
         mBuyCallback = null;
         mUIOffers = null;
         mEmptyOffers = null;
         mOfferTemplateClass = null;
         super.destroy();
      }
      
      override protected function getClassName() : String
      {
         return "coin_purchase_popup";
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var offerId:uint;
         var emptyOffer:MovieClip;
         var gmOffer:GMOffer;
         var uiShopOffer:UIShopBundleOffer;
         var offerClass:Class;
         var i:uint;
         var callback:*;
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         var popupClass:Class = swfAsset.getClass(this.getClassName());
         mPopup = new popupClass();
         mRoot.addChild(mPopup);
         mTitle = mPopup.title_label;
         mTitle.text = titleText;
         mEmptyOffers.push(mPopup.coin_shop_empty_slot_1);
         mEmptyOffers.push(mPopup.coin_shop_empty_slot_2);
         mEmptyOffers.push(mPopup.coin_shop_empty_slot_3);
         mOfferTemplateClass = swfAsset.getClass("shop_offer_template");
         mPremiumOfferTemplateClass = swfAsset.getClass("shop_offer_premium_template");
         i = 0;
         while(i < mOfferIds.length)
         {
            callback = function(param1:GMOffer):void
            {
               close(mBuyCallback,param1);
            };
            offerId = mOfferIds[i];
            gmOffer = mDBFacade.gameMaster.offerById.itemFor(offerId);
            offerClass = gmOffer.CurrencyType == "PREMIUM" && gmOffer.Price ? mPremiumOfferTemplateClass : mOfferTemplateClass;
            uiShopOffer = new UIShopBundleOffer(mDBFacade,offerClass,callback,mUseIconScaling);
            emptyOffer = mEmptyOffers[i];
            emptyOffer.parent.addChild(uiShopOffer.root);
            uiShopOffer.root.x = emptyOffer.x;
            uiShopOffer.root.y = emptyOffer.y;
            mUIOffers[i] = uiShopOffer;
            uiShopOffer.showOffer(gmOffer,null);
            uiShopOffer.root.visible = true;
            mEmptyOffers[i].visible = false;
            i++;
         }
         mCloseButton = new UIButton(mDBFacade,mPopup.close);
         mCloseButton.releaseCallback = function():void
         {
            close(closeCallback);
         };
         animatedEntrance();
      }
   }
}

