package GeneratedCode
{
   import Brain.GameObject.GameObject;
   import flash.geom.Vector3D;
   
   public interface IDistributedNPCGameObject
   {
      
      function setNetworkComponentDistributedNPCGameObject(param1:DistributedNPCGameObjectNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function set type(param1:uint) : void;
      
      function set level(param1:uint) : void;
      
      function set position(param1:Vector3D) : void;
      
      function set heading(param1:Number) : void;
      
      function set scale(param1:Number) : void;
      
      function set flip(param1:uint) : void;
      
      function set hitPoints(param1:uint) : void;
      
      function set weaponDetails(param1:Vector.<WeaponDetails>) : void;
      
      function set state(param1:String) : void;
      
      function set team(param1:int) : void;
      
      function set layer(param1:int) : void;
      
      function set remoteTriggerState(param1:uint) : void;
      
      function set masterId(param1:uint) : void;
      
      function ReceiveAttackChoreography(param1:AttackChoreography) : void;
      
      function ReceiveCombatResult(param1:CombatResult) : void;
      
      function ReceiveTimelineAction(param1:String) : void;
   }
}

