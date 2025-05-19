package GameMasterDictionary
{
   import flash.utils.getQualifiedClassName;
   
   public class GMItem
   {
      
      public var Id:uint;
      
      public var Constant:String;
      
      private var mName:String;
      
      private var mSecurityValue:int = 0;
      
      public function GMItem(param1:Object)
      {
         super();
         Id = param1.Id;
         Constant = param1.Constant;
         mName = param1.Name;
         for each(var _loc2_ in param1)
         {
            if(getQualifiedClassName(_loc2_) == "int")
            {
               mSecurityValue += Math.abs(int(_loc2_)) % 17 + Math.abs(int(_loc2_)) / 19;
            }
         }
         mSecurityValue %= 541;
      }
      
      public function get Name() : String
      {
         return mName;
      }
      
      public function get SecurityValue() : int
      {
         return mSecurityValue;
      }
   }
}

