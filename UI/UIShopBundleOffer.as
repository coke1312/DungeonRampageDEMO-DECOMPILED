package UI
{
   import Account.StoreServicesController;
   import Facade.DBFacade;
   
   public class UIShopBundleOffer extends UIShopOffer
   {
      
      public function UIShopBundleOffer(param1:DBFacade, param2:Class, param3:Function = null, param4:Boolean = true)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function get offerDescription() : String
      {
         return this.offer.BundleDescription;
      }
      
      override protected function get offerIconName() : String
      {
         return this.offer.BundleIcon;
      }
      
      override protected function get offerSwfPath() : String
      {
         return this.offer.BundleSwfFilepath;
      }
      
      override protected function hasRequirements() : Boolean
      {
         return false;
      }
      
      override protected function requirementsMetForPurchase() : Boolean
      {
         return !StoreServicesController.alreadyOwns(mDBFacade,this.offer);
      }
   }
}

