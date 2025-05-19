package Brain.AssetRepository
{
   import flash.utils.*;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   internal final class AssetCache
   {
      
      private var mCachedAssets:Map = new Map();
      
      public function AssetCache()
      {
         super();
         mCachedAssets = new Map();
      }
      
      public function itemFor(param1:AssetLoaderInfo) : Asset
      {
         if(param1.useCache)
         {
            return mCachedAssets.itemFor(param1.getKey());
         }
         return null;
      }
      
      public function add(param1:AssetLoaderInfo, param2:Asset) : Boolean
      {
         if(param1.useCache)
         {
            return mCachedAssets.add(param1.getKey(),param2);
         }
         return false;
      }
      
      public function remove(param1:Asset) : Boolean
      {
         return mCachedAssets.remove(param1);
      }
      
      public function get size() : int
      {
         return mCachedAssets.size;
      }
      
      public function removeCacheForSpriteSheetAssets() : void
      {
         var _loc2_:SpriteSheetAsset = null;
         var _loc3_:String = null;
         var _loc5_:* = 0;
         var _loc6_:Map = new Map();
         var _loc4_:Vector.<String> = new Vector.<String>();
         var _loc1_:IMapIterator = mCachedAssets.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc1_.next();
            _loc2_ = _loc1_.current as SpriteSheetAsset;
            if(_loc2_ != null)
            {
               _loc4_.push(_loc2_.cacheKey);
               _loc2_.destroy();
               _loc2_ = null;
            }
            else
            {
               _loc6_.add(_loc1_.key as String,_loc1_.current);
            }
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc3_ = _loc4_[_loc5_];
            if(_loc6_.hasKey(_loc3_))
            {
               _loc6_.removeKey(_loc3_);
            }
            _loc5_++;
         }
         mCachedAssets.clear();
         mCachedAssets = _loc6_;
         _loc6_ = null;
      }
      
      public function Dump() : void
      {
         var _loc2_:Asset = null;
         trace(" Asset Cache ------------------------------");
         var _loc1_:IMapIterator = mCachedAssets.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc1_.next();
            _loc2_ = _loc1_.current as Asset;
            if(_loc2_ != null)
            {
               trace("AssetCache : ",_loc1_.key,getQualifiedClassName((_loc2_ as Object).constructor as Class));
            }
         }
      }
   }
}

