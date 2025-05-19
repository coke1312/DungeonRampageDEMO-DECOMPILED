package Brain.Utils
{
   public interface IPoolable
   {
      
      function postCheckout(param1:Boolean) : void;
      
      function postCheckin() : void;
      
      function destroy() : void;
      
      function getPoolKey() : String;
   }
}

