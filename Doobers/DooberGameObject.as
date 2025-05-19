package Doobers
{
   import Brain.Clock.GameClock;
   import Brain.WorkLoop.LogicalWorkComponent;
   import DistributedObjects.HeroGameObjectOwner;
   import Events.FirstTreasureCollectedEvent;
   import Events.FirstTreasureNearbyEvent;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Floor.FloorView;
   import GameMasterDictionary.GMDoober;
   import GeneratedCode.DistributedDooberGameObjectNetworkComponent;
   import GeneratedCode.IDistributedDooberGameObject;
   import flash.geom.Vector3D;
   
   public class DooberGameObject extends FloorObject implements IDistributedDooberGameObject
   {
      
      public var mDooberData:GMDoober;
      
      private var mDooberView:DooberView;
      
      protected var mSwfPath:String;
      
      protected var mClassName:String;
      
      protected var mDooberId:uint;
      
      private var hasOwnership:Boolean;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mTutorialStarted:Boolean = false;
      
      public function DooberGameObject(param1:DBFacade, param2:uint = 0)
      {
         super(param1,param2);
         this.layer = 20;
         this.mSwfPath = DBFacade.buildFullDownloadPath("Resources/Art2D/Items/db_items_doobers.swf");
         hasOwnership = false;
      }
      
      override protected function buildView() : void
      {
         mDooberView = new DooberView(mDBFacade,this);
         this.view = mDooberView as FloorView;
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
         this.mDooberView.position = param1;
      }
      
      public function get swfPath() : String
      {
         return this.mSwfPath;
      }
      
      public function get className() : String
      {
         return this.mClassName;
      }
      
      public function get type() : uint
      {
         return this.mDooberId;
      }
      
      public function set type(param1:uint) : void
      {
         mDooberId = param1;
         this.mDooberData = mDBFacade.gameMaster.dooberById.itemFor(mDooberId);
         this.mClassName = mDooberData.AssetClassName;
         mSwfPath = DBFacade.buildFullDownloadPath(mDooberData.SwfFilePath);
      }
      
      public function postGenerate() : void
      {
         this.init();
         if(!mDBFacade.dbAccountInfo.dbAccountParams.hasChestNearbyTutorialParam())
         {
            if(mDooberData.DooberType == "TREASURE")
            {
               mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
               mLogicalWorkComponent.doEveryFrame(checkForTutorialPopUp);
            }
         }
      }
      
      public function takeOwnership(param1:Boolean, param2:uint) : void
      {
         var _loc5_:HeroGameObjectOwner = null;
         var _loc4_:Number = NaN;
         var _loc3_:int = 0;
         hasOwnership = true;
         mDooberView.collectedEffect(param1,param2,animationComplete);
         if(this.distributedDungeonFloor != null && mDooberData != null)
         {
            if(mDooberData.Exp > 0)
            {
               this.distributedDungeonFloor.addCollectedExp(mDooberData.Exp);
            }
            else if(mDooberData.DooberType == "TREASURE")
            {
               this.distributedDungeonFloor.addCollectedTreasure(mDooberId);
               if(!mDBFacade.dbAccountInfo.dbAccountParams.hasChestCollectedTutorialParam())
               {
                  mDBFacade.eventManager.dispatchEvent(new FirstTreasureCollectedEvent());
               }
               mTutorialStarted = true;
            }
            else if(param1 && mDooberData.isFood())
            {
               _loc5_ = mDBFacade.gameObjectManager.getReferenceFromId(param2) as HeroGameObjectOwner;
               _loc4_ = Math.round(mDooberData.HPPercentage * _loc5_.maxHitPoints);
               _loc3_ = 0;
               _loc5_.heroView.spawnHealFloater(_loc4_,true,true,_loc3_,0,"DAMAGE_MOVEMENT_TYPE");
            }
            else if(param1 && mDooberData.DooberType == "MANA")
            {
               _loc5_ = mDBFacade.gameObjectManager.getReferenceFromId(param2) as HeroGameObjectOwner;
               _loc4_ = Math.round(mDooberData.MPPercentage * _loc5_.maxManaPoints);
               _loc3_ = 0;
               _loc5_.heroView.spawnHealFloater(_loc4_,true,true,_loc3_,2,"DAMAGE_MOVEMENT_TYPE");
            }
         }
      }
      
      private function animationComplete() : void
      {
         if(hasOwnership)
         {
            if(mDooberData.DooberType == "EXP")
            {
               mDBFacade.hud.bulgeXpBar();
            }
            else if(mDooberData.DooberType == "FOOD")
            {
               mDBFacade.hud.bulgeProfileBox();
            }
            this.destroy();
         }
      }
      
      public function collectedBy(param1:uint) : void
      {
      }
      
      public function spawnFrom(param1:Vector3D) : void
      {
         this.mDooberView.animateDooberBounce(param1,this.position);
      }
      
      override public function destroy() : void
      {
         mDooberView = null;
         if(mLogicalWorkComponent)
         {
            mLogicalWorkComponent.destroy();
            mLogicalWorkComponent = null;
         }
         super.destroy();
      }
      
      public function setNetworkComponentDistributedDooberGameObject(param1:DistributedDooberGameObjectNetworkComponent) : void
      {
      }
      
      public function checkForTutorialPopUp(param1:GameClock) : void
      {
         if(!mTutorialStarted && mDistributedDungeonFloor.activeOwnerAvatar && Vector3D.distance(mDistributedDungeonFloor.activeOwnerAvatar.actorView.position,mPosition) < 500)
         {
            mTutorialStarted = true;
            if(!mDBFacade.dbAccountInfo.dbAccountParams.hasChestNearbyTutorialParam())
            {
               mDBFacade.eventManager.dispatchEvent(new FirstTreasureNearbyEvent());
            }
            mLogicalWorkComponent.clear();
            mLogicalWorkComponent.destroy();
            mLogicalWorkComponent = null;
         }
      }
   }
}

