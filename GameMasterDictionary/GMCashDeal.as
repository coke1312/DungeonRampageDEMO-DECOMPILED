package GameMasterDictionary
{
   public class GMCashDeal
   {
      
      public var Id:uint;
      
      public var Name:String;
      
      public var Currency:String;
      
      public var Partner:String;
      
      private var mPrice:Number;
      
      public var Value:uint;
      
      public var Bonus:uint;
      
      public var Default:uint;
      
      public var ImageURL:String;
      
      public var ProductURL:String;
      
      public var SplitTest:String;
      
      public var Description:String;
      
      public var DragonKnightBonus:Boolean;
      
      public function GMCashDeal(param1:Object, param2:Object)
      {
         super();
         Id = param1.Id;
         Name = param1.Name;
         mPrice = param1.Price;
         Value = param1.Value;
         Bonus = param1.Bonus;
         ImageURL = param1.ImageURL;
         ProductURL = param1.ProductURL;
         Description = param1.Description;
         Currency = param1.Currency;
         Partner = param1.Partner;
         Default = param1.Default;
         SplitTest = param1.SplitTest;
         DragonKnightBonus = param1.DragonKnightBonus as Boolean;
      }
      
      public function get Price() : Number
      {
         return mPrice;
      }
   }
}

