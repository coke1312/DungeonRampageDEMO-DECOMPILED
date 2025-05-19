package GameMasterDictionary
{
   import Brain.Logger.Logger;
   import DBGlobals.DBGlobal;
   
   public class StatVector
   {
      
      public static var slotCount:uint = 15;
      
      public var values:Vector.<Number>;
      
      public function StatVector()
      {
         super();
         values = new Vector.<Number>(15,true);
      }
      
      public static function clone(param1:StatVector) : StatVector
      {
         var _loc3_:* = 0;
         var _loc2_:StatVector = new StatVector();
         _loc3_ = 0;
         while(_loc3_ < slotCount)
         {
            _loc2_.values[_loc3_] = param1.values[_loc3_];
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function multiply(param1:StatVector, param2:StatVector) : StatVector
      {
         var _loc4_:* = 0;
         var _loc3_:StatVector = StatVector.clone(param1);
         _loc4_ = 0;
         while(_loc4_ < slotCount)
         {
            _loc3_.values[_loc4_] *= param2.values[_loc4_];
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function multiplyScalar(param1:StatVector, param2:Number) : StatVector
      {
         var _loc4_:* = 0;
         var _loc3_:StatVector = StatVector.clone(param1);
         _loc4_ = 0;
         while(_loc4_ < slotCount)
         {
            _loc3_.values[_loc4_] *= param2;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function add(param1:StatVector, param2:StatVector) : StatVector
      {
         var _loc4_:* = 0;
         var _loc3_:StatVector = StatVector.clone(param1);
         _loc4_ = 0;
         while(_loc4_ < slotCount)
         {
            _loc3_.values[_loc4_] += param2.values[_loc4_];
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function setConstant(param1:int) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < slotCount)
         {
            values[_loc2_] = param1;
            _loc2_++;
         }
      }
      
      public function SetFromJSON(param1:Object, param2:String = "") : void
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < DBGlobal.StatNames.length)
         {
            if(param1[param2 + DBGlobal.StatNames[_loc3_]] == null)
            {
               Logger.error("StatVector Reading JSON Value " + param2 + DBGlobal.StatNames[_loc3_] + "Not Found Continuing ?");
            }
            values[_loc3_] = param1[param2 + DBGlobal.StatNames[_loc3_]];
            _loc3_++;
         }
      }
      
      public function destroy() : void
      {
         values = null;
      }
      
      public function set data(param1:Vector.<Number>) : void
      {
         values = param1;
      }
      
      public function get maxHitPoints() : Number
      {
         return values[0];
      }
      
      public function get maxManaPoints() : Number
      {
         return values[1];
      }
      
      public function get movementSpeed() : Number
      {
         return values[13];
      }
      
      public function getSpeed(param1:String) : Number
      {
         if(param1 == "MELEE")
         {
            return values[8];
         }
         if(param1 == "SHOOT" || param1 == "SHOOTING")
         {
            return values[9];
         }
         if(param1 == "MAGIC")
         {
            return values[10];
         }
         return 1;
      }
      
      public function DebugPrint() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < slotCount)
         {
            trace(DBGlobal.StatNames[_loc1_],this.values[_loc1_]);
            _loc1_++;
         }
      }
   }
}

