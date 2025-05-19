package Combat.Attack
{
   import Actor.ActorGameObject;
   import Brain.AssetRepository.JsonAsset;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.DistributedDungeonFloor;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   import avmplus.getQualifiedClassName;
   import org.as3commons.collections.Map;
   
   public class TimelineFactory
   {
      
      private static const TIMELINE_FILE_PATH:String = "Resources/Combat/AttackTimeline.json";
      
      protected var mDBFacade:DBFacade;
      
      protected var mJsonAsset:JsonAsset;
      
      protected var mTimelines:Map;
      
      private var mSecurityValue:int;
      
      public function TimelineFactory(param1:DBFacade, param2:JsonAsset)
      {
         var _loc3_:String = null;
         super();
         mDBFacade = param1;
         mJsonAsset = param2;
         mTimelines = new Map();
         var _loc5_:int = 0;
         mSecurityValue = 0;
         for each(var _loc4_ in param2.json.attacks)
         {
            _loc3_ = _loc4_.attackName;
            mTimelines.add(_loc3_,_loc4_);
            _loc5_ += GetSecurityValue(_loc4_);
         }
         _loc5_ %= 1097;
         mSecurityValue += _loc5_;
         _loc5_ = 0;
      }
      
      public function GetSecurityValue(param1:Object) : int
      {
         var _loc2_:int = 0;
         for each(var _loc3_ in param1)
         {
            if(getQualifiedClassName(_loc3_) == "int")
            {
               _loc2_ += Math.abs(int(_loc3_)) % 17 + Math.abs(int(_loc3_)) / 19;
            }
         }
         return _loc2_ % 541;
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         mTimelines.clear();
         mTimelines = null;
         mJsonAsset = null;
      }
      
      public function get securityChecksum() : int
      {
         return mSecurityValue;
      }
      
      public function createAttackTimeline(param1:String, param2:WeaponGameObject, param3:ActorGameObject, param4:DistributedDungeonFloor) : AttackTimeline
      {
         var _loc6_:AttackTimeline = null;
         var _loc5_:Object = mTimelines.itemFor(param1);
         if(param3.isOwner)
         {
            _loc6_ = new OwnerAttackTimeline(param2,param3 as HeroGameObjectOwner,param3.actorView,_loc5_,mDBFacade,param4);
         }
         else
         {
            _loc6_ = new AttackTimeline(param2,param3,param3.actorView,_loc5_,mDBFacade,param4);
         }
         return _loc6_;
      }
      
      public function createScriptTimeline(param1:String, param2:ActorGameObject, param3:DistributedDungeonFloor) : ScriptTimeline
      {
         var _loc5_:* = null;
         var _loc4_:Object = mTimelines.itemFor(param1);
         return new ScriptTimeline(param2,param2.actorView,_loc4_,mDBFacade,param3);
      }
   }
}

