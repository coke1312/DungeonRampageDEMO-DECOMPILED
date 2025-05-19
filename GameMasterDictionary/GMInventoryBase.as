package GameMasterDictionary
{
   public class GMInventoryBase extends GMItem
   {
      
      public static const WEAPON_CATEGORY:String = "WEAPON";
      
      public static const POWERUP_CATEGORY:String = "POWERUP";
      
      public static const PET_CATEGORY:String = "PET";
      
      public static const STUFF_CATEGORY:String = "STUFF";
      
      public var Coins:int;
      
      public var Cash:int;
      
      public var CashB:int;
      
      public var CashC:int;
      
      public var CashD:int;
      
      public var CashE:int;
      
      public var CashF:int;
      
      public var CashG:int;
      
      public var CashH:int;
      
      public var CashI:int;
      
      public var SellCoins:int;
      
      public var IconName:String;
      
      public var UISwfFilepath:String;
      
      public var Description:String;
      
      public var ItemCategory:String;
      
      public var ItemSubclass:String;
      
      public function GMInventoryBase(param1:Object)
      {
         super(param1);
         Coins = param1.Coins;
         Cash = param1.Cash;
         CashB = param1.CashB;
         CashC = param1.CashC;
         CashD = param1.CashD;
         CashE = param1.CashE;
         CashF = param1.CashF;
         CashG = param1.CashG;
         CashH = param1.CashH;
         CashI = param1.CashI;
         SellCoins = param1.SellCoins;
         ItemCategory = param1.ItemCategory;
         ItemSubclass = param1.ItemSubclass;
         IconName = param1.IconName;
         UISwfFilepath = param1.UISwfFilepath;
         Description = param1.Description;
      }
   }
}

