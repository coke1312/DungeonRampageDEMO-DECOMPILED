package GameMasterDictionary
{
   public class GMChest
   {
      
      public var Id:uint;
      
      public var Name:String;
      
      public var Rarity:String;
      
      public var IconName:String;
      
      public var IconSwf:String;
      
      public var InventoryRevealName:String;
      
      public var InventoryRevealSwf:String;
      
      public var Description:String;
      
      public function GMChest(param1:Object)
      {
         super();
         Id = param1.Id;
         Name = param1.Name;
         Rarity = param1.Rarity;
         IconName = param1.IconName;
         IconSwf = param1.IconSwf;
         InventoryRevealName = param1.InventoryRevealName;
         InventoryRevealSwf = param1.InventoryRevealSwf;
         Description = param1.Description;
      }
   }
}

