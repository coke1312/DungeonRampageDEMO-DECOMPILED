package Dungeon
{
   import Brain.Logger.Logger;
   import DistributedObjects.DistributedDungeonFloor;
   import Events.LEClientEvent;
   import Facade.DBFacade;
   import GeneratedCode.DungeonTileUsage;
   import flash.geom.Vector3D;
   import org.as3commons.collections.Map;
   
   public class TileFactory
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mFactoriesReady:Function;
      
      protected var mPropFactoryReady:Boolean = false;
      
      protected var mTileFactoryReady:Boolean = false;
      
      protected var mPropFactory:PropFactory;
      
      protected var mTileMap:Map = new Map();
      
      public var mFillerTiles:Array = [];
      
      protected var mLocalProximityTriggers:Array;
      
      protected var mTileLibraryJson:Object;
      
      public function TileFactory(param1:DBFacade, param2:Array, param3:Object)
      {
         super();
         mDBFacade = param1;
         mTileLibraryJson = param3;
         loadTileLibrary();
         loadTileTriggersAndTriggerables();
         mPropFactory = new PropFactory(mDBFacade,param2);
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         mPropFactory.destroy();
         mPropFactory = null;
         mFactoriesReady = null;
      }
      
      public function get propFactory() : PropFactory
      {
         return mPropFactory;
      }
      
      protected function propFactoryReady() : void
      {
         mPropFactoryReady = true;
         checkIfReady();
      }
      
      protected function checkIfReady() : void
      {
         if(mPropFactoryReady && mTileFactoryReady)
         {
            mFactoriesReady();
         }
      }
      
      protected function loadTileLibrary() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = mTileLibraryJson.LETiles as Array;
         var _loc1_:uint = _loc3_.length;
         while(_loc2_ < _loc1_)
         {
            mTileMap.add(_loc3_[_loc2_].id,_loc3_[_loc2_]);
            if(_loc3_[_loc2_].category == "FILLER_TILE")
            {
               mFillerTiles.push(_loc3_[_loc2_]);
            }
            _loc2_++;
         }
         mTileFactoryReady = true;
         checkIfReady();
      }
      
      protected function loadTileTriggersAndTriggerables() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = mTileLibraryJson.LETriggers as Array;
         var _loc1_:uint = _loc3_.length;
         while(_loc2_ < _loc1_)
         {
            mDBFacade.gameMaster.triggerToTriggerable.add(_loc3_[_loc2_].triggerId,_loc3_[_loc2_].triggerableId);
            _loc2_++;
         }
      }
      
      public function buildTile(param1:DungeonTileUsage, param2:Function, param3:Function, param4:DistributedDungeonFloor) : void
      {
         var _loc5_:* = null;
         mLocalProximityTriggers = [];
         var _loc6_:Object = mTileMap.itemFor(param1.tileId);
         if(_loc6_ == null)
         {
            Logger.warn("Could not find tileId: " + param1.tileId + " in mTileMap");
            return;
         }
         var _loc7_:Tile = new Tile(mDBFacade,_loc6_.LEObjects.length,_loc6_.category == "FILLER_TILE");
         _loc7_.position = new Vector3D(param1.x,param1.y);
         param2(_loc7_);
         param3(_loc7_);
         buildBackground(_loc6_.LEBackground,_loc7_,param4);
         for each(_loc5_ in _loc6_.LEObjects)
         {
            buildingProp(_loc5_,_loc7_,param4);
         }
         for each(_loc5_ in _loc6_.LETriggers)
         {
            buildingProp(_loc5_,_loc7_,param4);
         }
         for each(_loc5_ in mLocalProximityTriggers)
         {
            analyzeLocalProximityTrigger(_loc5_,_loc7_,param4);
         }
      }
      
      protected function buildingProp(param1:Object, param2:Tile, param3:DistributedDungeonFloor) : void
      {
         switch(param1.type)
         {
            case "LEProp":
               buildProp(param1,param2,param3);
               break;
            case "LEHeroSpawnProp":
            case "LENPC":
            case "LENPCGenerator":
            case "LECollectable":
            case "LETriggerGate":
            case "LETriggerableCamera":
            case "LENPCGeneratorWithAllSpawnsDeadTrigger":
               param2.ignoredAProp();
               break;
            case "LETriggerable":
               if(param1.constant == "SEND_LOCAL_CLIENT_EVENT")
               {
                  mDBFacade.gameMaster.TriggerableIdToTriggerableEvent.add(uint(param1.id),new TriggerableEvent(param1.id,param1.textKey));
               }
               break;
            case "LETrigger":
               if(param1.constant == "PROXIMITY_LOCAL_HERO")
               {
                  mLocalProximityTriggers.push(param1);
               }
               break;
            default:
               Logger.debug("Do not know how to handle type: " + param1.type.toString() + " Ignoring.");
               param2.ignoredAProp();
         }
      }
      
      protected function buildProp(param1:Object, param2:Tile, param3:DistributedDungeonFloor) : void
      {
         var _loc4_:Boolean = Prop.validatePropConstant(param1,mDBFacade);
         if(!_loc4_)
         {
            Logger.warn("invalid prop constant: " + param1.constant);
            return;
         }
         var _loc5_:Prop = Prop.parseFromTileJson(param1,param2,mDBFacade);
         _loc5_.distributedDungeonFloor = param3;
      }
      
      protected function analyzeLocalProximityTrigger(param1:Object, param2:Tile, param3:DistributedDungeonFloor) : void
      {
         var triggerableEvent:TriggerableEvent;
         var propJsonObj:Object = param1;
         var tile:Tile = param2;
         var distributedDungeonFloor:DistributedDungeonFloor = param3;
         var triggerableId:uint = mDBFacade.gameMaster.triggerToTriggerable.itemFor(propJsonObj.id);
         if(triggerableId)
         {
            triggerableEvent = mDBFacade.gameMaster.TriggerableIdToTriggerableEvent.itemFor(triggerableId);
            if(triggerableEvent)
            {
               tile.createLocalEventCollision(distributedDungeonFloor,propJsonObj.x,propJsonObj.y,propJsonObj.radius,propJsonObj.triggerOnce,function():void
               {
                  mDBFacade.eventManager.dispatchEvent(new LEClientEvent(triggerableEvent.eventName));
               });
            }
         }
      }
      
      protected function buildBackground(param1:Object, param2:Tile, param3:DistributedDungeonFloor) : void
      {
         var _loc4_:Boolean = Prop.validatePropConstant(param1,mDBFacade);
         if(!_loc4_)
         {
            Logger.warn("invalid background constant: " + param1.constant);
            return;
         }
         var _loc5_:Prop = Prop.parseFromTileJson(param1,param2,mDBFacade);
         _loc5_.view.root.scaleX = _loc5_.view.root.scaleY = 1.0022222222222221;
         _loc5_.layer = 5;
         _loc5_.distributedDungeonFloor = param3;
         param2.background = _loc5_;
      }
   }
}

