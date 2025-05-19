package GameMasterDictionary
{
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   
   public class GMOffer
   {
      
      public static const BASIC_CURRENCY:String = "BASIC";
      
      public static const PREMIUM_CURRENCY:String = "PREMIUM";
      
      private static const SPECIAL_NEW:String = "NEW";
      
      private static const SPECIAL_FEATURED:String = "FEATURED";
      
      private static const SPECIAL_SALE:String = "SALE";
      
      private var mPrice:uint;
      
      public var Id:uint;
      
      public var CurrencyType:String;
      
      public var Tab:String;
      
      public var Location:String;
      
      public var CoinOfferId:uint;
      
      public var CoinOffer:GMOffer;
      
      public var IsCoinAltOffer:Boolean = false;
      
      public var VisibleDate:Date;
      
      public var StartDate:Date;
      
      public var EndDate:Date;
      
      public var SoldOutDate:Date;
      
      public var SaleTargetOfferId:uint;
      
      public var SaleTargetOffer:GMOffer;
      
      public var SaleOffers:Vector.<GMOffer>;
      
      public var SalePercentOff:uint;
      
      public var SaleStartDate:Date;
      
      public var SaleEndDate:Date;
      
      public var LimitedQuantity:uint;
      
      private var mSpecial:String;
      
      public var Gift:Boolean;
      
      public var IsBundle:Boolean;
      
      public var BundleName:String;
      
      public var BundleIcon:String;
      
      public var BundleSwfFilepath:String;
      
      public var BundleDescription:String = "";
      
      public var Rarity:String;
      
      public var OrigPriceA:uint;
      
      public var OrigPriceB:uint;
      
      public var OrigPriceC:uint;
      
      public var OrigPriceD:uint;
      
      public var OrigPriceE:uint;
      
      public var OrigPriceF:uint;
      
      public var OrigPriceG:uint;
      
      public var OrigPriceH:uint;
      
      public var OrigPriceI:uint;
      
      public var OrigPriceJ:uint;
      
      public var Details:Vector.<GMOfferDetail>;
      
      public function GMOffer(param1:Object, param2:Object)
      {
         super();
         Id = param1.Id;
         CurrencyType = param1.CurrencyType;
         this.determinePrice(param1,param2);
         Tab = param1.Tab;
         Location = param1.Location;
         CoinOfferId = param1.CoinOfferId;
         SaleTargetOfferId = param1.SaleOffer;
         IsBundle = param1.IsBundle;
         if(IsBundle)
         {
            BundleName = param1.BundleName;
            BundleIcon = param1.BundleIcon;
            BundleSwfFilepath = param1.BundleSwfFilepath;
            BundleDescription = param1.BundleDescription;
         }
         Rarity = param1.Rarity;
         if(param1.VisibleDate)
         {
            VisibleDate = GameClock.parseW3CDTF(param1.VisibleDate);
         }
         if(param1.StartDate)
         {
            StartDate = GameClock.parseW3CDTF(param1.StartDate);
         }
         if(param1.EndDate)
         {
            EndDate = GameClock.parseW3CDTF(param1.EndDate);
         }
         if(param1.SoldOutDate)
         {
            SoldOutDate = GameClock.parseW3CDTF(param1.SoldOutDate);
         }
         if(param1.SaleStartDate)
         {
            SaleStartDate = GameClock.parseW3CDTF(param1.SaleStartDate);
         }
         if(param1.SaleEndDate)
         {
            SaleEndDate = GameClock.parseW3CDTF(param1.SaleEndDate);
         }
         SalePercentOff = param1.SalePercentOff;
         LimitedQuantity = param1.LimitedQuantity;
         mSpecial = param1.Special;
         Gift = param1.Gift;
         Details = new Vector.<GMOfferDetail>();
      }
      
      public function get percentOff() : uint
      {
         if(SaleTargetOffer && SalePercentOff)
         {
            return SalePercentOff;
         }
         return 0;
      }
      
      public function get Special() : Boolean
      {
         if(isFeatured)
         {
            return true;
         }
         if(this.isOnSaleNow && this.isSale)
         {
            return true;
         }
         return Boolean(mSpecial);
      }
      
      public function isVisible() : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc7_:Number = GameClock.getWebServerTime();
         if(VisibleDate)
         {
            _loc3_ = Number(VisibleDate.getTime());
            if(_loc3_ > _loc7_)
            {
               return false;
            }
            if(SoldOutDate)
            {
               _loc2_ = Number(SoldOutDate.getTime());
               if(_loc2_ < _loc7_)
               {
                  return false;
               }
            }
            else if(EndDate)
            {
               _loc5_ = Number(EndDate.getTime());
               if(_loc5_ < _loc7_)
               {
                  return false;
               }
            }
            return true;
         }
         if(StartDate)
         {
            _loc4_ = Number(StartDate.getTime());
            if(_loc4_ > _loc7_)
            {
               return false;
            }
            if(SoldOutDate)
            {
               _loc6_ = Number(SoldOutDate.getTime());
               if(_loc6_ < _loc7_)
               {
                  return false;
               }
            }
            else if(EndDate)
            {
               _loc1_ = Number(EndDate.getTime());
               if(_loc1_ < _loc7_)
               {
                  return false;
               }
            }
            return true;
         }
         return true;
      }
      
      public function isAvailableTime() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = GameClock.getWebServerTime();
         if(StartDate)
         {
            _loc1_ = Number(StartDate.getTime());
            if(_loc1_ > _loc3_)
            {
               return false;
            }
         }
         if(EndDate)
         {
            _loc2_ = Number(EndDate.getTime());
            if(_loc2_ < _loc3_)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get isFeatured() : Boolean
      {
         var _loc1_:GMOffer = isOnSaleNow;
         if(_loc1_ && _loc1_.mSpecial == "FEATURED")
         {
            return true;
         }
         return mSpecial == "FEATURED";
      }
      
      public function get isNew() : Boolean
      {
         return mSpecial == "NEW";
      }
      
      public function get isSale() : Boolean
      {
         return mSpecial == "SALE" || mSpecial == "FEATURED";
      }
      
      public function get isOnSaleNow() : GMOffer
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this.SaleOffers)
         {
            return null;
         }
         var _loc4_:Number = GameClock.getWebServerTime();
         for each(var _loc1_ in this.SaleOffers)
         {
            if(!(_loc1_.SaleStartDate && _loc1_.SaleEndDate))
            {
               return _loc1_;
            }
            _loc2_ = Number(_loc1_.SaleStartDate.getTime());
            _loc3_ = Number(_loc1_.SaleEndDate.getTime());
            if(_loc2_ < _loc4_ && _loc4_ < _loc3_)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      private function determinePrice(param1:Object, param2:Object) : void
      {
         var _loc3_:* = null;
         OrigPriceA = param1.Price;
         OrigPriceB = param1.PriceB;
         OrigPriceC = param1.PriceC;
         OrigPriceD = param1.PriceD;
         OrigPriceE = param1.PriceE;
         OrigPriceF = param1.PriceF;
         OrigPriceG = param1.PriceG;
         OrigPriceH = param1.PriceH;
         OrigPriceI = param1.PriceI;
         OrigPriceJ = param1.PriceJ;
         mPrice = OrigPriceE;
         for each(_loc3_ in param2)
         {
            if(String(_loc3_.name).indexOf("ShopPrices") <= -1)
            {
               continue;
            }
            switch(_loc3_.value)
            {
               case "PriceA":
                  mPrice = OrigPriceA;
                  break;
               case "PriceB":
                  mPrice = OrigPriceB;
                  break;
               case "PriceC":
                  mPrice = OrigPriceC;
                  break;
               case "PriceD":
                  mPrice = OrigPriceD;
                  break;
               case "PriceE":
                  mPrice = OrigPriceE;
                  break;
               case "PriceF":
                  mPrice = OrigPriceF;
                  break;
               case "PriceG":
                  mPrice = OrigPriceG;
                  break;
               case "PriceH":
                  mPrice = OrigPriceH;
                  break;
               case "PriceI":
                  mPrice = OrigPriceI;
                  break;
               case "PriceJ":
                  mPrice = OrigPriceJ;
                  break;
               default:
                  Logger.warn("Invalid split test for ShopPrices: " + _loc3_.value);
                  break;
            }
         }
         for each(_loc3_ in param2)
         {
            if(_loc3_.name == "GemValue1" && CurrencyType == "PREMIUM")
            {
               mPrice = Math.ceil(mPrice * _loc3_.value);
            }
         }
         if(CurrencyType == "PREMIUM")
         {
            for each(_loc3_ in param2)
            {
               if(_loc3_.name == "InDungeonHealthBombSale" && Id == 51304)
               {
                  mPrice = Math.ceil(mPrice * Number(_loc3_.value));
               }
            }
         }
      }
      
      public function getDisplayName(param1:GameMaster, param2:String = "") : String
      {
         var _loc9_:GMOfferDetail = null;
         var _loc5_:GMHero = null;
         var _loc3_:GMWeaponItem = null;
         var _loc4_:GMWeaponAesthetic = null;
         var _loc6_:GMNpc = null;
         var _loc8_:GMSkin = null;
         var _loc7_:* = param2;
         if(this.IsBundle)
         {
            _loc7_ = this.BundleName.toUpperCase();
         }
         else
         {
            _loc9_ = this.Details[0];
            if(_loc9_.HeroId)
            {
               _loc5_ = param1.heroById.itemFor(_loc9_.HeroId);
               if(_loc5_)
               {
                  _loc7_ = _loc5_.Name.toUpperCase();
               }
            }
            else if(_loc9_.WeaponId)
            {
               _loc3_ = param1.weaponItemById.itemFor(_loc9_.WeaponId);
               _loc4_ = _loc3_.getWeaponAesthetic(_loc9_.Level);
               _loc7_ = _loc4_.Name.toUpperCase();
            }
            else if(_loc9_.PetId)
            {
               _loc6_ = param1.npcById.itemFor(_loc9_.PetId);
               if(_loc6_)
               {
                  _loc7_ = _loc6_.Name.toUpperCase();
               }
            }
            else if(_loc9_.SkinId)
            {
               _loc8_ = param1.getSkinByType(_loc9_.SkinId);
               if(_loc8_)
               {
                  _loc7_ = _loc8_.Name.toUpperCase();
               }
            }
         }
         return _loc7_;
      }
      
      public function get Price() : Number
      {
         return mPrice;
      }
   }
}

