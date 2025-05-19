package DistributedObjects
{
   import Actor.ActorGameObject;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.SceneGraph.SceneGraphComponent;
   import Events.CacheLoadRequestNpcEvent;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import GeneratedCode.DistributedDungionAreaNetworkComponent;
   import GeneratedCode.IDistributedDungionArea;
   import GeneratedCode.InfiniteRewardData;
   import GeneratedCode.WeaponDetails;
   import GeneratedCode.swrapper;
   
   public class DistributedDungionArea extends Area implements IDistributedDungionArea
   {
      
      private var mNetworkComponent:DistributedDungionAreaNetworkComponent;
      
      private var mTileLibrary:Vector.<String>;
      
      protected var mSceneGraphComponent:SceneGraphComponent;
      
      protected var mEventComponent:EventComponent;
      
      public var mCacheNpc:Vector.<uint>;
      
      public var mCacheSfc:Vector.<String>;
      
      public function DistributedDungionArea(param1:DBFacade, param2:uint = 0)
      {
         Logger.debug("New  DistributedDungionArea******************************");
         super(param1,param2);
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mCacheNpc = new Vector.<uint>();
         mCacheSfc = new Vector.<String>();
         mEventComponent = new EventComponent(param1);
      }
      
      public function set cacheNpc(param1:Vector.<uint>) : void
      {
         mCacheNpc = param1;
      }
      
      public function set cacheSWC(param1:Vector.<swrapper>) : void
      {
         var _loc2_:* = 0;
         mCacheSfc = new Vector.<String>();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            mCacheSfc.push(DBFacade.buildFullDownloadPath(param1[_loc2_].fileName));
            _loc2_++;
         }
      }
      
      public function setNetworkComponentDistributedDungionArea(param1:DistributedDungionAreaNetworkComponent) : void
      {
         mNetworkComponent = param1;
      }
      
      public function postGenerate() : void
      {
         mEventComponent.dispatchEvent(new CacheLoadRequestNpcEvent(mCacheNpc,mCacheSfc,mTileLibrary));
      }
      
      public function tileLibrary(param1:Vector.<swrapper>) : void
      {
         var _loc2_:* = 0;
         mTileLibrary = new Vector.<String>();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            mTileLibrary.push(param1[_loc2_].fileName);
            _loc2_++;
         }
      }
      
      public function calculateNetAttackDamage(param1:ActorGameObject, param2:ActorGameObject, param3:GMAttack, param4:WeaponDetails) : Number
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc5_:Number = 0;
         if(param3.StatOffsets != null)
         {
            _loc6_ = (param4.power * mDBFacade.gameMaster.stat_BonusMultiplier.values[param3.StatOffsets.offence] + param1.stats.values[param3.StatOffsets.offence]) * param1.buffHandler.multiplier[param3.StatOffsets.offence];
            _loc6_ = _loc6_ * param3.DamageMod;
            _loc7_ = param2.stats.values[param3.StatOffsets.defence] * param2.buffHandler.multiplier[param3.StatOffsets.defence];
            _loc5_ = _loc6_ + _loc7_;
         }
         else
         {
            _loc5_ = param4.power * param3.DamageMod;
         }
         return _loc5_;
      }
      
      public function floorReward(param1:uint) : void
      {
      }
      
      public function floorEnding(param1:uint) : void
      {
         if(mActiveFloor == null)
         {
            return;
         }
         mActiveFloor.floorEnding(param1);
      }
      
      public function floorfailing(param1:uint) : void
      {
         if(mActiveFloor == null)
         {
            return;
         }
         mActiveFloor.floorFailing(param1);
      }
      
      public function tellClientInfiniteRewardData(param1:uint, param2:uint, param3:uint, param4:Vector.<InfiniteRewardData>) : void
      {
         if(mDBFacade.dbAccountInfo.activeAvatarId != param1)
         {
            return;
         }
         mInfiniteStartScore = param2;
         mInfiniteFloorGold = param3;
         mInfiniteRewardData = param4;
         for each(var _loc5_ in param4)
         {
         }
      }
      
      public function dungeonEnding(param1:uint, param2:uint) : void
      {
         if(mActiveFloor == null)
         {
            return;
         }
         if(param2)
         {
            mActiveFloor.victory();
         }
         else
         {
            mActiveFloor.defeat();
         }
      }
      
      override public function destroy() : void
      {
         mEventComponent.destroy();
         mEventComponent = null;
         mCacheNpc = null;
         super.destroy();
      }
   }
}

