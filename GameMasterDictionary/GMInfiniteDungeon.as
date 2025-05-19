package GameMasterDictionary
{
   import org.as3commons.collections.Map;
   
   public class GMInfiniteDungeon
   {
      
      public var Id:int;
      
      public var Constant:String;
      
      public var Name:String;
      
      public var DModFloorStart:Vector.<uint>;
      
      public var RewardFloors:Vector.<uint>;
      
      public var FloorRewardsMap:Map;
      
      public function GMInfiniteDungeon(param1:Object)
      {
         super();
         Id = param1.Id;
         Constant = param1.Constant;
         Name = param1.Name;
         DModFloorStart = new Vector.<uint>();
         DModFloorStart.push(param1.DMod1FloorStart);
         DModFloorStart.push(param1.DMod2FloorStart);
         DModFloorStart.push(param1.DMod3FloorStart);
         DModFloorStart.push(param1.DMod4FloorStart);
         RewardFloors = new Vector.<uint>();
         RewardFloors.push(param1.Reward1Floor);
         RewardFloors.push(param1.Reward2Floor);
         RewardFloors.push(param1.Reward3Floor);
         RewardFloors.push(param1.Reward4Floor);
         FloorRewardsMap = new Map();
         FloorRewardsMap.add(param1.Reward1Floor,param1.Reward1);
         FloorRewardsMap.add(param1.Reward2Floor,param1.Reward2);
         FloorRewardsMap.add(param1.Reward3Floor,param1.Reward3);
         FloorRewardsMap.add(param1.Reward4Floor,param1.Reward4);
      }
   }
}

