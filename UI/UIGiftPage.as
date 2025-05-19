package UI
{
   import Account.StoreServicesController;
   import Brain.AssetRepository.SwfAsset;
   import Facade.DBFacade;
   import Facade.Locale;
   
   public class UIGiftPage extends UIOfferPopup
   {
      
      public function UIGiftPage(param1:DBFacade, param2:Function, param3:Function)
      {
         var dbFacade:DBFacade = param1;
         var buyCallback:Function = param2;
         var closeCallback:Function = param3;
         super(dbFacade,Locale.getString("SHOP_GIFT_PAGE_TITLE"),StoreServicesController.GIFT_OFFERS,buyCallback,closeCallback,false);
         if(mBuyCallback == null)
         {
            mBuyCallback = function():void
            {
               close(null);
            };
         }
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         super.setupUI(param1,param2,param3,param4,param5);
      }
   }
}

