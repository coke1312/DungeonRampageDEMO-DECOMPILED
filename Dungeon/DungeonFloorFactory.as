package Dungeon
{
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import GeneratedCode.DungeonTileUsage;
   import flash.geom.Vector3D;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.IIterator;
   
   public class DungeonFloorFactory
   {
      
      protected var mTileNetworkComponents:Vector.<DungeonTileUsage>;
      
      protected var mTilesBuiltCallback:Function;
      
      protected var mNumTilesCreated:uint = 0;
      
      protected var mTileGrid:TileGrid;
      
      protected var mTileFactory:TileFactory;
      
      protected var mDBFacade:DBFacade;
      
      protected var mDistributedDungeonFloor:DistributedDungeonFloor;
      
      public function DungeonFloorFactory(param1:DistributedDungeonFloor, param2:Function, param3:DBFacade, param4:String)
      {
         super();
         mDBFacade = param3;
         mDistributedDungeonFloor = param1;
         mTileFactory = new TileFactory(mDBFacade,mDBFacade.libraryJson,mDBFacade.getTileLibraryJson(param4));
         mTileGrid = new TileGrid();
         param2(mTileGrid);
      }
      
      public function destroy() : void
      {
         mTileNetworkComponents = null;
         mTilesBuiltCallback = null;
         mTileGrid.destroy();
         mTileGrid = null;
         mTileFactory.destroy();
         mTileFactory = null;
         mDistributedDungeonFloor = null;
         mDBFacade = null;
      }
      
      public function get tileFactory() : TileFactory
      {
         return mTileFactory;
      }
      
      public function buildDungeonFloor(param1:Vector.<DungeonTileUsage>, param2:Function) : void
      {
         mTileNetworkComponents = param1;
         mTilesBuiltCallback = param2;
         buildGrid(param1);
         AddFillerTiles();
      }
      
      private function AddFillerTilesHelper(param1:Vector3D, param2:Number, param3:Number) : void
      {
         var _loc4_:DungeonTileUsage = null;
         param1.x += param2 * 900;
         param1.y += param3 * 900;
         if(mTileGrid.isPositionOpenForATile(param1))
         {
            _loc4_ = new DungeonTileUsage();
            _loc4_.tileId = mTileFactory.mFillerTiles[0].id;
            _loc4_.x = param1.x;
            _loc4_.y = param1.y;
            mTileFactory.buildTile(_loc4_,addToGrid,tileInitialized,mDistributedDungeonFloor);
         }
      }
      
      private function AddFillerTiles() : void
      {
         var _loc1_:* = undefined;
         if(mTileFactory.mFillerTiles.length > 0)
         {
            _loc1_ = mTileGrid.getNonFillTilePositions();
            for each(var _loc2_ in _loc1_)
            {
               AddFillerTilesHelper(_loc2_.clone(),1,0);
               AddFillerTilesHelper(_loc2_.clone(),1,1);
               AddFillerTilesHelper(_loc2_.clone(),1,-1);
               AddFillerTilesHelper(_loc2_.clone(),0,1);
               AddFillerTilesHelper(_loc2_.clone(),0,-1);
               AddFillerTilesHelper(_loc2_.clone(),-1,1);
               AddFillerTilesHelper(_loc2_.clone(),-1,0);
               AddFillerTilesHelper(_loc2_.clone(),-1,-1);
            }
         }
      }
      
      protected function buildGrid(param1:Vector.<DungeonTileUsage>) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            mTileFactory.buildTile(param1[_loc2_],addToGrid,tileInitialized,mDistributedDungeonFloor);
            _loc2_++;
         }
      }
      
      protected function addToGrid(param1:Tile) : void
      {
         var _loc5_:Set = null;
         var _loc2_:IIterator = null;
         var _loc4_:FloorObject = null;
         var _loc3_:Tile = mTileGrid.getTileAtPosition(param1.position);
         if(_loc3_ != null)
         {
            _loc5_ = _loc3_.floorObjects;
            _loc2_ = _loc5_.iterator();
            while(_loc2_.hasNext())
            {
               _loc4_ = _loc2_.next();
               if(!_loc3_.hasOwnedFloorObject(_loc4_))
               {
                  _loc4_.tile = param1;
               }
            }
            mTileGrid.removeTileAtPosition(param1.position);
         }
         mTileGrid.setTileAtPosition(param1.position,param1);
      }
      
      protected function tileInitialized(param1:Tile) : void
      {
         mTileGrid.setTileAtPosition(param1.position,param1);
         mDistributedDungeonFloor.astarGrids.InitTileAstarGrids(param1.position.x / 900 + 1,param1.position.y / 900 + 1);
         mNumTilesCreated++;
         if(mNumTilesCreated == mTileNetworkComponents.length)
         {
            mTilesBuiltCallback(mTileGrid);
         }
      }
   }
}

