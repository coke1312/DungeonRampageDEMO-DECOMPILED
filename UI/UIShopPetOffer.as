package UI
{
   import Facade.DBFacade;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMNpc;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMOfferDetail;
   
   public class UIShopPetOffer extends UIShopOffer
   {
      
      protected var mGMOfferDetail:GMOfferDetail;
      
      protected var mGMOfferPet:GMNpc;
      
      public function UIShopPetOffer(param1:DBFacade, param2:Class, param3:Function = null)
      {
         super(param1,param2,param3);
      }
      
      override public function showOffer(param1:GMOffer, param2:GMHero) : void
      {
         this.offer = param1;
         mGMOfferDetail = this.offer.Details[0];
         mGMOfferPet = mDBFacade.gameMaster.npcById.itemFor(mGMOfferDetail.PetId);
         super.showOffer(param1,param2);
      }
      
      override protected function get nativeIconSize() : Number
      {
         return 68;
      }
      
      override protected function get offerDescription() : String
      {
         return mGMOfferPet ? mGMOfferPet.Description : "";
      }
      
      override protected function get offerIconName() : String
      {
         return mGMOfferPet ? mGMOfferPet.IconName : "";
      }
      
      override protected function get offerSwfPath() : String
      {
         return mGMOfferPet ? mGMOfferPet.IconSwfFilepath : "";
      }
      
      override protected function hasRequirements() : Boolean
      {
         return false;
      }
      
      override protected function requirementsMetForPurchase() : Boolean
      {
         return true;
      }
   }
}

