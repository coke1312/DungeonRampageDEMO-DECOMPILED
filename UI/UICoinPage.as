package UI
{
   import Account.StoreServicesController;
   import Facade.DBFacade;
   import Facade.Locale;
   
   public class UICoinPage extends UIOfferPopup
   {
      
      public function UICoinPage(param1:DBFacade, param2:Function, param3:Function)
      {
         super(param1,Locale.getString("SHOP_COIN_PAGE_TITLE"),StoreServicesController.COIN_OFFERS,param2,param3);
      }
   }
}

