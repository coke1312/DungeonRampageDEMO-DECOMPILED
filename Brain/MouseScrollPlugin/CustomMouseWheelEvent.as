package Brain.MouseScrollPlugin
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class CustomMouseWheelEvent extends MouseEvent
   {
      
      public static const MOVE:String = "onMove";
      
      public function CustomMouseWheelEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:Number = 0, param5:Number = 0, param6:InteractiveObject = null, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:int = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
   }
}

