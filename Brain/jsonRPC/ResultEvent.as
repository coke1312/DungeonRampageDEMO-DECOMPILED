package Brain.jsonRPC
{
   import flash.events.Event;
   
   public class ResultEvent extends Event
   {
      
      public static const Result:String = "result";
      
      public var result:*;
      
      public function ResultEvent(param1:*)
      {
         this.result = param1;
         super("result");
      }
   }
}

