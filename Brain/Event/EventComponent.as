package Brain.Event
{
   import Brain.Component.Component;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.Utils.Receipt;
   import flash.events.Event;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class EventComponent extends Component
   {
      
      protected var mRegisteredListeners:Map = new Map();
      
      public function EventComponent(param1:Facade)
      {
         super(param1);
         mFacade = param1;
      }
      
      public function addListener(param1:String, param2:Function) : Receipt
      {
         var _loc3_:Boolean = mRegisteredListeners.add(param1,param2);
         if(_loc3_)
         {
            mFacade.eventManager.addEventListener(param1,param2);
            return new Receipt(removeListener);
         }
         Logger.warn("Failed duplicate addListener for eventName: " + param1);
         return null;
      }
      
      public function removeListener(param1:String) : void
      {
         var _loc2_:Function = mRegisteredListeners.removeKey(param1);
         if(_loc2_ == null)
         {
            return;
         }
         mFacade.eventManager.removeEventListener(param1,_loc2_);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         mFacade.eventManager.dispatchEvent(param1);
      }
      
      override public function destroy() : void
      {
         removeAllListeners();
         mRegisteredListeners = null;
         super.destroy();
      }
      
      public function removeAllListeners() : void
      {
         var _loc2_:String = null;
         var _loc3_:Function = null;
         var _loc1_:IMapIterator = mRegisteredListeners.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc3_ = _loc1_.next();
            _loc2_ = _loc1_.key;
            mFacade.eventManager.removeEventListener(_loc2_,_loc3_);
         }
         mRegisteredListeners.clear();
      }
   }
}

