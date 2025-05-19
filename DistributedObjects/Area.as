package DistributedObjects
{
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import GeneratedCode.InfiniteRewardData;
   
   public class Area extends GameObject
   {
      
      protected var mActiveFloor:Floor;
      
      public var mDBFacade:DBFacade;
      
      private var mExpCollected:uint;
      
      private var mTreasureCollected:Vector.<uint>;
      
      protected var mAvScore:int = 0;
      
      protected var mInfiniteStartScore:int = 0;
      
      protected var mInfiniteTotalGold:int = 0;
      
      protected var mInfiniteFloorGold:int = 0;
      
      protected var mInfiniteRewardData:Vector.<InfiniteRewardData>;
      
      public function Area(param1:DBFacade, param2:uint = 0)
      {
         super(param1,param2);
         mDBFacade = param1;
         mTreasureCollected = new Vector.<uint>();
      }
      
      override public function newNetworkChild(param1:GameObject) : void
      {
         if(param1 as Floor)
         {
            settingActiveFloor(param1 as Floor);
         }
      }
      
      public function settingActiveFloor(param1:Floor) : void
      {
         mActiveFloor = param1;
         mActiveFloor.SetParentArea(this);
      }
      
      public function get infiniteStartScore() : int
      {
         return mInfiniteStartScore;
      }
      
      public function get infiniteTotalGold() : int
      {
         return mInfiniteTotalGold;
      }
      
      public function get infiniteFloorGold() : int
      {
         return mInfiniteFloorGold;
      }
      
      public function addInfiniteFloorGoldToTotal() : void
      {
         mInfiniteTotalGold += mInfiniteFloorGold;
      }
      
      public function get infiniteRewardData() : Vector.<InfiniteRewardData>
      {
         return mInfiniteRewardData;
      }
      
      public function get avScore() : int
      {
         return mAvScore;
      }
      
      override public function destroy() : void
      {
         if(mActiveFloor)
         {
            Logger.debug("destroy Area " + id.toString() + " Before Active Floor is Cleared" + mActiveFloor.id.toString());
         }
         super.destroy();
         mActiveFloor = null;
         mTreasureCollected = null;
      }
      
      public function FloorIsLeaving(param1:Floor) : void
      {
         mActiveFloor = null;
      }
      
      public function addCollectedTreasure(param1:uint) : void
      {
         mTreasureCollected.push(param1);
      }
      
      public function get treasureCollected() : Vector.<uint>
      {
         return mTreasureCollected;
      }
      
      public function addCollectedExp(param1:uint) : void
      {
         mExpCollected += param1;
      }
      
      public function get expCollected() : uint
      {
         return mExpCollected;
      }
   }
}

