package DistributedObjects
{
   import Brain.GameObject.GameObject;
   import Facade.DBFacade;
   import GameMasterDictionary.StatVector;
   import GeneratedCode.AttackChoreography;
   import GeneratedCode.CombatResult;
   import GeneratedCode.DistributedNPCGameObjectNetworkComponent;
   import GeneratedCode.IDistributedNPCGameObject;
   import GeneratedCode.WeaponDetails;
   import flash.geom.Vector3D;
   
   public class DistributedNPCGameObject extends GameObject implements IDistributedNPCGameObject
   {
      
      protected var mNPCGameObject:NPCGameObject;
      
      public function DistributedNPCGameObject(param1:DBFacade, param2:uint = 0)
      {
         super(param1,0);
         mNPCGameObject = new NPCGameObject(param1,param2);
      }
      
      override public function getTrueObject() : GameObject
      {
         return mNPCGameObject;
      }
      
      public function setNetworkComponentDistributedNPCGameObject(param1:DistributedNPCGameObjectNetworkComponent) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.setNetworkComponentDistributedNPCGameObject(param1);
         }
      }
      
      public function set state(param1:String) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.state = param1;
            if(param1 == "dead")
            {
               mNPCGameObject.hasOwnership = true;
               mNPCGameObject = null;
            }
         }
      }
      
      public function postGenerate() : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.postGenerate();
         }
      }
      
      public function set type(param1:uint) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.type = param1;
         }
      }
      
      public function set level(param1:uint) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.level = param1;
         }
      }
      
      public function set position(param1:Vector3D) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.position = param1;
         }
      }
      
      public function set heading(param1:Number) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.heading = param1;
         }
      }
      
      public function set scale(param1:Number) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.scale = param1;
         }
      }
      
      public function set flip(param1:uint) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.flip = param1;
         }
      }
      
      public function set hitPoints(param1:uint) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.hitPoints = param1;
         }
      }
      
      public function set weaponDetails(param1:Vector.<WeaponDetails>) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.weaponDetails = param1;
         }
      }
      
      public function set stats(param1:StatVector) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.stats = param1;
         }
      }
      
      public function set masterId(param1:uint) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.masterId = param1;
         }
      }
      
      public function ReceiveAttackChoreography(param1:AttackChoreography) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.ReceiveAttackChoreography(param1);
         }
      }
      
      public function ReceiveTimelineAction(param1:String) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.ReceiveTimelineAction(param1);
         }
      }
      
      public function ReceiveCombatResult(param1:CombatResult) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.ReceiveCombatResult(param1);
         }
      }
      
      override public function destroy() : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.destroy();
            mNPCGameObject = null;
         }
         super.destroy();
      }
      
      public function set layer(param1:int) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.layer = param1;
         }
      }
      
      public function set team(param1:int) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.team = param1;
         }
      }
      
      public function set remoteTriggerState(param1:uint) : void
      {
         if(mNPCGameObject)
         {
            mNPCGameObject.remoteTriggerState = param1;
         }
      }
   }
}

