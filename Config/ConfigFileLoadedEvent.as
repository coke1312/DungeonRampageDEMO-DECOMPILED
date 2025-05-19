package Config
{
   import flash.events.Event;
   
   public class ConfigFileLoadedEvent extends Event
   {
      
      public static const EVENT_NAME:String = "ConfigFileLoadedEvent";
      
      protected var mDBConfigManager:DBConfigManager;
      
      public function ConfigFileLoadedEvent(param1:DBConfigManager, param2:Boolean = false, param3:Boolean = false)
      {
         super("ConfigFileLoadedEvent",param2,param3);
         mDBConfigManager = param1;
      }
      
      public function get dbConfigManager() : DBConfigManager
      {
         return mDBConfigManager;
      }
   }
}

