package Doobers
{
   import Brain.GameObject.GameObject;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   import GeneratedCode.DistributedDooberGameObjectNetworkComponent;
   import GeneratedCode.IDistributedDooberGameObject;
   import flash.geom.Vector3D;
   
   public class DistributedDooberGameObject extends GameObject implements IDistributedDooberGameObject
   {
      
      private var mDooberGameObject:DooberGameObject;
      
      private var localFacade:DBFacade;
      
      public function DistributedDooberGameObject(param1:DBFacade, param2:uint = 0)
      {
         localFacade = param1;
         super(param1,0);
         mDooberGameObject = new DooberGameObject(param1,param2);
      }
      
      override public function getTrueObject() : GameObject
      {
         return mDooberGameObject;
      }
      
      public function setNetworkComponentDistributedDooberGameObject(param1:DistributedDooberGameObjectNetworkComponent) : void
      {
         mDooberGameObject.setNetworkComponentDistributedDooberGameObject(param1);
      }
      
      public function postGenerate() : void
      {
         if(mDooberGameObject)
         {
            mDooberGameObject.postGenerate();
         }
      }
      
      public function set type(param1:uint) : void
      {
         if(mDooberGameObject)
         {
            mDooberGameObject.type = param1;
         }
      }
      
      public function set position(param1:Vector3D) : void
      {
         if(mDooberGameObject)
         {
            mDooberGameObject.position = param1;
         }
      }
      
      public function collectedBy(param1:uint) : void
      {
         if(mDooberGameObject)
         {
            mDooberGameObject.takeOwnership(param1 == HeroGameObjectOwner.currentHeroOwnerId,param1);
            mDooberGameObject = null;
         }
      }
      
      public function spawnFrom(param1:Vector3D) : void
      {
         if(mDooberGameObject)
         {
            mDooberGameObject.spawnFrom(param1);
         }
      }
      
      public function set layer(param1:int) : void
      {
         if(mDooberGameObject)
         {
            mDooberGameObject.layer = param1;
         }
      }
      
      override public function destroy() : void
      {
         if(mDooberGameObject)
         {
            mDooberGameObject.destroy();
            mDooberGameObject = null;
         }
         super.destroy();
      }
   }
}

