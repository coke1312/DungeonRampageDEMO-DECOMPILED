package Brain.Utils
{
   public class Tuple
   {
      
      private var mFirst:*;
      
      private var mSecond:*;
      
      public function Tuple(param1:*, param2:*)
      {
         super();
         mFirst = param1;
         mSecond = param2;
      }
      
      public function get first() : *
      {
         return mFirst;
      }
      
      public function get second() : *
      {
         return mSecond;
      }
   }
}

