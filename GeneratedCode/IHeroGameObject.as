package GeneratedCode
{
   import Brain.GameObject.GameObject;
   import flash.geom.Vector3D;
   
   public interface IHeroGameObject
   {
      
      function setNetworkComponentHeroGameObject(param1:HeroGameObjectNetworkComponent) : void;
      
      function postGenerate() : void;
      
      function getTrueObject() : GameObject;
      
      function destroy() : void;
      
      function set type(param1:uint) : void;
      
      function set position(param1:Vector3D) : void;
      
      function set heading(param1:Number) : void;
      
      function set scale(param1:Number) : void;
      
      function set flip(param1:uint) : void;
      
      function set hitPoints(param1:uint) : void;
      
      function set weaponDetails(param1:Vector.<WeaponDetails>) : void;
      
      function set consumableDetails(param1:Vector.<ConsumableDetails>) : void;
      
      function set healthBombsUsed(param1:uint) : void;
      
      function set partyBombsUsed(param1:uint) : void;
      
      function set playerID(param1:uint) : void;
      
      function set state(param1:String) : void;
      
      function set team(param1:int) : void;
      
      function ReceiveAttackChoreography(param1:AttackChoreography) : void;
      
      function ReceiveCombatResult(param1:CombatResult) : void;
      
      function set skinType(param1:uint) : void;
      
      function set screenName(param1:String) : void;
      
      function set manaPoints(param1:uint) : void;
      
      function set experiencePoints(param1:uint) : void;
      
      function set slotPoints(param1:Vector.<uint>) : void;
      
      function set dungeonBusterPoints(param1:uint) : void;
      
      function set setAFK(param1:uint) : void;
      
      function PartyBomb(param1:uint) : void;
      
      function setStateAndAttackChoreography(param1:String, param2:AttackChoreography) : void;
      
      function StopChoreography() : void;
   }
}

