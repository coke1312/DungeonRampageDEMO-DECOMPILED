package Events
{
   import flash.events.Event;
   
   public class CacheLoadRequestNpcEvent extends Event
   {
      
      public static const CACHE_LOAD_REQUEST:String = "Busterncpccahche_event";
      
      public var cacheNpc:Vector.<uint>;
      
      public var cacheSwf:Vector.<String>;
      
      public var tilelibraryname:Vector.<String>;
      
      public function CacheLoadRequestNpcEvent(param1:Vector.<uint>, param2:Vector.<String>, param3:Vector.<String>, param4:Boolean = false, param5:Boolean = false)
      {
         cacheSwf = param2;
         cacheNpc = param1;
         tilelibraryname = param3;
         super("Busterncpccahche_event",param4,param5);
      }
   }
}

