package Brain.jsonRPC
{
   import flash.events.EventDispatcher;
   import flash.net.URLStream;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class JSONRPCPendingInvokation extends EventDispatcher
   {
      
      protected var mRegisteredListeners:Map = new Map();
      
      protected var mURLStream:URLStream;
      
      protected var mDestroyCallback:Function;
      
      public function JSONRPCPendingInvokation(param1:URLStream)
      {
         mURLStream = param1;
         super(this);
      }
      
      public function handleError(param1:Error) : void
      {
         if(mDestroyCallback != null)
         {
            mDestroyCallback(this);
         }
         mDestroyCallback = null;
         this.dispatchEvent(new FaultEvent(param1));
         destory();
      }
      
      public function handleResult(param1:*) : void
      {
         if(mDestroyCallback != null)
         {
            mDestroyCallback(this);
         }
         mDestroyCallback = null;
         this.dispatchEvent(new ResultEvent(param1));
         destory();
      }
      
      public function addDestroyCallback(param1:Function) : void
      {
         mDestroyCallback = param1;
      }
      
      public function addListener(param1:String, param2:Function) : void
      {
         mRegisteredListeners.add(param1,param2);
         addEventListener(param1,param2);
      }
      
      public function removeListener(param1:String) : void
      {
         if(!mRegisteredListeners.has(param1))
         {
            return;
         }
         var _loc2_:Function = mRegisteredListeners.itemFor(param1);
         removeEventListener(param1,_loc2_);
         mRegisteredListeners.remove(param1);
      }
      
      public function destory() : void
      {
         removeAllListeners();
         mRegisteredListeners.clear();
         mRegisteredListeners = null;
         mURLStream.close();
         mURLStream = null;
         if(mDestroyCallback != null)
         {
            mDestroyCallback(this);
         }
         mDestroyCallback = null;
      }
      
      public function removeAllListeners() : void
      {
         var _loc2_:String = null;
         var _loc1_:IMapIterator = mRegisteredListeners.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc1_.next();
            _loc2_ = _loc1_.current as String;
            removeListener(_loc2_);
         }
      }
   }
}

