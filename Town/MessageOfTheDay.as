package Town
{
   public class MessageOfTheDay
   {
      
      public static const IMAGE_PORTRAIT:uint = 0;
      
      public static const IMAGE_LANDSCAPE:uint = 1;
      
      public static const MOVIE:uint = 2;
      
      public var type:uint;
      
      public var title:String;
      
      public var message:String;
      
      public var imageURL:String;
      
      public var mainText:String;
      
      public var mainCallback:Function;
      
      public var webText:String;
      
      public var webURL:String;
      
      public function MessageOfTheDay(param1:String, param2:String, param3:String, param4:String, param5:String, param6:Function, param7:String, param8:String)
      {
         super();
         if(param1 == "IMAGE_PORTRAIT")
         {
            type = 0;
         }
         else if(param1 == "IMAGE_LANDSCAPE")
         {
            type = 1;
         }
         else if(param1 == "MOVIE")
         {
            type = 2;
         }
         title = param2;
         message = param3;
         imageURL = param4;
         mainText = param5;
         mainCallback = param6;
         webText = param7;
         webURL = param8;
      }
   }
}

