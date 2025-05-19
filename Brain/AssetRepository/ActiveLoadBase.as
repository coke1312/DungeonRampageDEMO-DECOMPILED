package Brain.AssetRepository
{
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.core.SetIterator;
   
   public class ActiveLoadBase
   {
      
      public var mPendingSuccessCallback:Set;
      
      public var mPendingErrorCallbacks:Set;
      
      public var mInfo:AssetLoaderInfo;
      
      public var mAssetRepository:AssetRepository;
      
      public function ActiveLoadBase(param1:AssetRepository, param2:AssetLoaderInfo)
      {
         super();
         mPendingErrorCallbacks = new Set();
         mPendingSuccessCallback = new Set();
         mInfo = param2;
         mAssetRepository = param1;
      }
      
      public function AddCallback(param1:Function, param2:Function) : void
      {
         if(param1 != null)
         {
            mPendingSuccessCallback.add(param1);
         }
         if(param2 != null)
         {
            mPendingErrorCallbacks.add(param2);
         }
      }
      
      public function removeCallback(param1:Function, param2:Function) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = mPendingSuccessCallback.remove(param1);
         }
         if(param2 != null)
         {
            _loc3_ ||= mPendingErrorCallbacks.remove(param2);
         }
         return _loc3_;
      }
      
      public function hasNoCallbacks() : Boolean
      {
         return mPendingSuccessCallback.size != 0 || mPendingErrorCallbacks.size != 0;
      }
      
      public function executeErrorCallbacks(param1:AssetLoaderInfo) : void
      {
         var _loc3_:Function = null;
         var _loc2_:SetIterator = mPendingErrorCallbacks.iterator() as SetIterator;
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            if(_loc3_ != null)
            {
               _loc3_();
            }
         }
         mPendingErrorCallbacks.clear();
      }
      
      public function executeSucessCallbacks(param1:AssetLoaderInfo, param2:Asset) : void
      {
         var _loc4_:Function = null;
         var _loc3_:SetIterator = mPendingSuccessCallback.iterator() as SetIterator;
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next();
            if(_loc4_ != null)
            {
               _loc4_(param2);
            }
         }
         mPendingSuccessCallback.clear();
      }
      
      public function destroy() : void
      {
         mPendingSuccessCallback.clear();
         mPendingErrorCallbacks.clear();
         mAssetRepository = null;
         mInfo = null;
      }
   }
}

