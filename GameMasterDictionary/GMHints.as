package GameMasterDictionary
{
   public class GMHints
   {
      
      public var Constant:String;
      
      public var MinLevel:uint;
      
      public var MaxLevel:uint;
      
      public var Type:String;
      
      public var HintText:String;
      
      public function GMHints(param1:Object)
      {
         super();
         Constant = param1.Constant;
         MinLevel = param1.MinLevel;
         MaxLevel = param1.MaxLevel;
         Type = param1.Type;
         HintText = param1.HintText;
      }
   }
}

