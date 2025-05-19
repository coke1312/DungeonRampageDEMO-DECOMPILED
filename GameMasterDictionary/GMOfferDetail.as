package GameMasterDictionary
{
   public class GMOfferDetail
   {
      
      public var OfferId:uint;
      
      public var WeaponId:uint;
      
      public var WeaponPower:uint;
      
      public var Level:uint;
      
      public var Rarity:String;
      
      public var Modifier1:String;
      
      public var Modifier2:String;
      
      public var Modifier3:String;
      
      public var ChestId:uint;
      
      public var HeroId:uint;
      
      public var PetId:uint;
      
      public var SkinId:uint;
      
      public var StackableId:uint;
      
      public var StackableCount:uint;
      
      public var Coins:uint;
      
      public var BasicKeys:uint;
      
      public var UncommonKeys:uint;
      
      public var RareKeys:uint;
      
      public var LegendaryKeys:uint;
      
      public var WeaponSlots:uint;
      
      public var Gems:uint;
      
      public function GMOfferDetail(param1:Object)
      {
         super();
         OfferId = param1.OfferId;
         WeaponId = param1.WeaponId;
         WeaponPower = param1.WeaponPower;
         Level = param1.Level != null ? param1.Level : 0;
         Rarity = param1.Rarity;
         Modifier1 = param1.Modifier1;
         Modifier2 = param1.Modifier2;
         Modifier3 = param1.Modifier3;
         ChestId = param1.ChestId;
         HeroId = param1.HeroId;
         PetId = param1.PetId;
         SkinId = param1.SkinId;
         StackableId = param1.StackableId;
         StackableCount = param1.StackableCount;
         Coins = param1.Coins;
         BasicKeys = param1.BasicKeys;
         UncommonKeys = param1.UncommonKeys;
         RareKeys = param1.RareKeys;
         LegendaryKeys = param1.LegendaryKeys;
         WeaponSlots = param1.WeaponSlots;
         Gems = param1.Gems;
      }
   }
}

