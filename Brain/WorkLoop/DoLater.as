package Brain.WorkLoop
{
   public class DoLater extends Task implements IPrioritizable
   {
      
      public var delay:Number = 0;
      
      public var dueTime:uint = 0;
      
      protected var mRepeat:Boolean = true;
      
      public function DoLater(param1:Boolean = true)
      {
         super();
         mRepeat = param1;
      }
      
      public function get repeat() : Boolean
      {
         return mRepeat;
      }
      
      public function get priority() : int
      {
         return -dueTime;
      }
      
      public function set priority(param1:int) : void
      {
         throw new Error("Not implemented, set dueTime and requeue");
      }
   }
}

