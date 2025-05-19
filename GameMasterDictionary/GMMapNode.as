package GameMasterDictionary
{
   public class GMMapNode extends GMItem
   {
      
      public static const DUNGEON_NODE_TYPE:String = "DUNGEON";
      
      public static const BOSS_NODE_TYPE:String = "BOSS";
      
      public static const INFINITE_NODE_TYPE:String = "INFINITE";
      
      public static const TAVERN_NODE_TYPE:String = "TAVERN";
      
      public var DifficultyName:String;
      
      public var ColiseumType:uint;
      
      public var NodeType:String;
      
      public var TierRank:String;
      
      public var InfiniteDungeon:String;
      
      public var BasicKeys:uint;
      
      public var PremiumKeys:uint;
      
      public var PayEverytime:Boolean;
      
      public var RevealNodes:Array;
      
      public var ChildNodes:Array;
      
      public var ParentNodes:Array;
      
      public var PrefixupParentNode:String;
      
      public var StorySwfPath:String;
      
      public var StoryAssetClass:String;
      
      public var StoryPlayEverytime:Boolean;
      
      public var NodeIcon:String;
      
      public var GoalRoomTileset:String;
      
      public var GoalRoom:String;
      
      public var LevelRequirement:uint;
      
      public var TrophyRequirement:uint;
      
      public var CompletionXPBonus:uint;
      
      public var IsWeeklyChallenge:Boolean;
      
      public var AlwaysVisible:Boolean;
      
      public var MinTreasure:uint;
      
      public var BitIndex:uint;
      
      public var IsInfiniteDungeon:Boolean;
      
      public function GMMapNode(param1:Object)
      {
         super(param1);
         BitIndex = param1.BitIndex;
         DifficultyName = param1.DifficultyName;
         ColiseumType = mapColiseumType(param1.ColiseumType);
         NodeType = param1.NodeType;
         TierRank = param1.TierRank;
         InfiniteDungeon = param1.InfiniteDungeon;
         IsInfiniteDungeon = false;
         NodeIcon = param1.NodeIcon;
         GoalRoomTileset = param1.GoalRoomTileset;
         GoalRoom = param1.GoalRoom;
         LevelRequirement = param1.LevelReq;
         TrophyRequirement = param1.TrophyReq;
         BasicKeys = param1.BasicKeys;
         PremiumKeys = param1.PremiumKeys;
         PayEverytime = param1.PayEverytime;
         StorySwfPath = param1.StoryScene;
         StoryAssetClass = param1.AssetClassName;
         StoryPlayEverytime = param1.PlayEverytime;
         RevealNodes = [param1.RevealNode1,param1.RevealNode2,param1.RevealNode3,param1.RevealNode4,param1.RevealNode5,param1.RevealNode6,param1.RevealNode7,param1.RevealNode8,param1.RevealNode9,param1.RevealNode10];
         ChildNodes = [param1.ChildNode1,param1.ChildNode2,param1.ChildNode3];
         PrefixupParentNode = param1.ParentNode;
         ParentNodes = [];
         IsWeeklyChallenge = param1.IsWeeklyChallenge;
         AlwaysVisible = param1.AlwaysVisible;
         CompletionXPBonus = param1.CompletionXPBonus;
         MinTreasure = param1.MinTreasure;
      }
      
      private function mapColiseumType(param1:String) : uint
      {
         if(param1 == "DINO_JUNGLE")
         {
            return 2;
         }
         if(param1 == "ICE_CAVES")
         {
            return 3;
         }
         if(param1 == "SKY_PAGODA")
         {
            return 4;
         }
         return 1;
      }
   }
}

