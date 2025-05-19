package Brain.Utils
{
   public class Receipt
   {
      
      private var mUnregisterFunction:Function;
      
      public function Receipt(param1:Function)
      {
         super();
         mUnregisterFunction = param1;
      }
      
      public function exit() : void
      {
         mUnregisterFunction();
      }
   }
}

