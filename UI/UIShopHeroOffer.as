package UI
{
   import Brain.UI.UIButton;
   import Facade.DBFacade;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMOfferDetail;
   import GameMasterDictionary.GMSkin;
   import Town.TownHeader;
   
   public class UIShopHeroOffer extends UIShopOffer
   {
      
      protected var mGMOfferDetail:GMOfferDetail;
      
      protected var mGMOfferHero:GMHero;
      
      protected var mInfoButton:UIButton;
      
      private var mTownHeader:TownHeader;
      
      public function UIShopHeroOffer(param1:TownHeader, param2:DBFacade, param3:Class, param4:Function = null)
      {
         super(param2,param3,param4);
         mInfoButton = new UIButton(mDBFacade,mRoot.icon);
         mInfoButton.releaseCallback = this.showInfo;
         mTownHeader = param1;
      }
      
      private function showInfo() : void
      {
         var _loc1_:UIHeroUpsellPopup = null;
         if(this.requirementsMetForPurchase())
         {
            _loc1_ = new UIHeroUpsellPopup(mTownHeader,mDBFacade,this.offer,null);
         }
      }
      
      override public function destroy() : void
      {
         if(mInfoButton)
         {
            mInfoButton.destroy();
            mInfoButton = null;
         }
      }
      
      override public function showOffer(param1:GMOffer, param2:GMHero) : void
      {
         this.offer = param1;
         mGMOfferDetail = this.offer.Details[0];
         mGMOfferHero = mDBFacade.gameMaster.heroById.itemFor(mGMOfferDetail.HeroId);
         super.showOffer(param1,param2);
      }
      
      override protected function IsCashPageExclusiveOffer() : Boolean
      {
         return mGMOfferHero.IsExclusive;
      }
      
      override protected function get nativeIconSize() : Number
      {
         return 72;
      }
      
      override protected function get offerDescription() : String
      {
         return mGMOfferHero ? mGMOfferHero.StoreDescription : "";
      }
      
      override protected function get offerIconName() : String
      {
         return mGMOfferHero ? mGMOfferHero.IconName : "";
      }
      
      override protected function get offerSwfPath() : String
      {
         var _loc2_:GMSkin = null;
         var _loc1_:String = "";
         if(mGMOfferHero != null)
         {
            _loc2_ = mDBFacade.gameMaster.getSkinByConstant(mGMOfferHero.DefaultSkin);
            _loc1_ = _loc2_.UISwfFilepath;
         }
         return _loc1_;
      }
      
      override protected function hasRequirements() : Boolean
      {
         return false;
      }
      
      override protected function requirementsMetForPurchase() : Boolean
      {
         return !mDBFacade.dbAccountInfo.inventoryInfo.ownsItem(mGMOfferDetail.HeroId);
      }
   }
}

