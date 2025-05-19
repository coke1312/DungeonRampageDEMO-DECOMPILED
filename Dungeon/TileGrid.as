package Dungeon
{
   import Brain.Logger.Logger;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class TileGrid
   {
      
      public static const DEFAULT_GRID_WIDTH:uint = 12;
      
      public static const DEFAULT_GRID_HEIGHT:uint = 12;
      
      private static const MAX_VISIBLE_TILES:uint = 9;
      
      private var mGridWidth:uint;
      
      private var mGridHeight:uint;
      
      private var mTiles:Vector.<Tile>;
      
      private var mEmptyTileColiders:Vector.<RectangleNavCollider>;
      
      public function TileGrid(param1:uint = 12, param2:uint = 12)
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         super();
         mGridWidth = param1;
         mGridHeight = param2;
         mTiles = new Vector.<Tile>();
         mEmptyTileColiders = new Vector.<RectangleNavCollider>();
         _loc4_ = 0;
         while(_loc4_ < mGridHeight)
         {
            _loc3_ = 0;
            while(_loc3_ < mGridWidth)
            {
               mTiles.push(null);
               mEmptyTileColiders.push(null);
               _loc3_++;
            }
            _loc4_++;
         }
      }
      
      public function getNonFillTilePositions() : Vector.<Vector3D>
      {
         var _loc1_:Vector.<Vector3D> = new Vector.<Vector3D>();
         for each(var _loc2_ in mTiles)
         {
            if(_loc2_ && !_loc2_.isFiller())
            {
               _loc1_.push(_loc2_.position.clone());
            }
         }
         return _loc1_;
      }
      
      public function isPositionOpenForATile(param1:Vector3D) : Boolean
      {
         if(getTileIndexAtPosition(param1) >= 0)
         {
            return getTileAtPosition(param1) == null;
         }
         return false;
      }
      
      private function setTileAtIndex(param1:uint, param2:uint, param3:Tile) : void
      {
         if(param1 >= mGridWidth || param2 >= mGridHeight)
         {
            throw new Error("index out of range");
         }
         mTiles[param1 + param2 * mGridWidth] = param3;
         var _loc4_:RectangleNavCollider = mEmptyTileColiders[param1 + param2 * mGridWidth];
         if(_loc4_ != null)
         {
            _loc4_.destroy();
            mEmptyTileColiders[param1 + param2 * mGridWidth] = null;
         }
      }
      
      public function SetEmptyColliderAtIndex(param1:uint, param2:uint, param3:RectangleNavCollider) : void
      {
         if(param1 >= mGridWidth || param2 >= mGridHeight)
         {
            throw new Error("index out of range");
         }
         mEmptyTileColiders[param1 + param2 * mGridWidth] = param3;
      }
      
      public function getEmptyColliderAtIndex(param1:uint, param2:uint) : RectangleNavCollider
      {
         if(param1 >= mGridWidth || param2 >= mGridHeight)
         {
            return null;
         }
         return mEmptyTileColiders[param1 + param2 * mGridWidth];
      }
      
      public function setTileAtPosition(param1:Vector3D, param2:Tile) : void
      {
         if(param1.x < -900 || param1.y < -900)
         {
            Logger.error("setTileAtPosition: position must be positive: " + param1.toString());
            return;
         }
         var _loc3_:uint = (param1.x + 900) / 900;
         var _loc4_:uint = (param1.y + 900) / 900;
         setTileAtIndex(_loc3_,_loc4_,param2);
      }
      
      public function getTileAtIndex(param1:uint, param2:uint) : Tile
      {
         if(param1 >= mGridWidth || param2 >= mGridHeight)
         {
            return null;
         }
         return mTiles[param1 + param2 * mGridWidth];
      }
      
      public function getTileAtPosition(param1:Vector3D) : Tile
      {
         if(param1.x < -900 || param1.y < -900)
         {
            return null;
         }
         var _loc2_:uint = (param1.x + 900) / 900;
         var _loc3_:uint = (param1.y + 900) / 900;
         return getTileAtIndex(_loc2_,_loc3_);
      }
      
      public function getTileIndexAtPosition(param1:Vector3D) : int
      {
         if(param1.x < -900 || param1.y < -900)
         {
            return -1;
         }
         var _loc2_:uint = (param1.x + 900) / 900;
         var _loc3_:uint = (param1.y + 900) / 900;
         if(_loc2_ >= mGridWidth || _loc3_ >= mGridHeight)
         {
            return -1;
         }
         return _loc2_ + _loc3_ * mGridWidth;
      }
      
      public function getVisibleTiles(param1:Rectangle) : Vector.<Tile>
      {
         var rect:Rectangle = param1;
         var filterFunc:Function = function(param1:Tile, param2:int, param3:Vector.<Tile>):Boolean
         {
            if(param1)
            {
               return param1.bounds.intersects(rect);
            }
            return false;
         };
         var visibleTiles:Vector.<Tile> = mTiles.filter(filterFunc);
         if(visibleTiles.length > 9)
         {
            Logger.warn("getVisibleTiles: found " + visibleTiles.length + " visible. Something wrong?");
         }
         return visibleTiles;
      }
      
      public function iterator(param1:Boolean = false) : TileGridIterator
      {
         return new TileGridIterator(mTiles,param1);
      }
      
      public function removeAllFromWorld() : void
      {
         for each(var _loc1_ in mTiles)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
         }
      }
      
      public function removeTileAtPosition(param1:Vector3D) : void
      {
         var _loc2_:Number = getTileIndexAtPosition(param1);
         if(_loc2_ >= 0)
         {
            if(mTiles[_loc2_] != null)
            {
               mTiles[_loc2_].removeFromStage();
               mTiles[_loc2_].destroy();
            }
            mTiles[_loc2_] = null;
         }
      }
      
      public function destroy() : void
      {
         removeAllFromWorld();
         mTiles = null;
      }
   }
}

