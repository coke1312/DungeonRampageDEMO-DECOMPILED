package Account.II
{
   import com.maccherone.json.JSON;
   import org.as3commons.collections.Map;
   
   public class II_FriendChampionsboardInfo
   {
      
      public var nodeIdToScore:Map;
      
      public var nodeIdToActiveSkin:Map;
      
      private var mNodeIdToFriendInfoJson:Map;
      
      public function II_FriendChampionsboardInfo(param1:Object)
      {
         super();
         nodeIdToScore = new Map();
         nodeIdToActiveSkin = new Map();
         mNodeIdToFriendInfoJson = new Map();
         updateMapnodeScore(param1);
      }
      
      public function updateMapnodeScore(param1:Object) : void
      {
         var _loc2_:* = null;
         nodeIdToScore.add(param1.mapnode_id,param1.score);
         nodeIdToActiveSkin.add(param1.mapnode_id,param1.active_skin);
         mNodeIdToFriendInfoJson.add(param1.mapnode_id,param1);
      }
      
      public function getWeaponsForNodeId(param1:uint) : Vector.<Object>
      {
         var _loc3_:Object = null;
         var _loc2_:Vector.<Object> = new Vector.<Object>();
         if(mNodeIdToFriendInfoJson.hasKey(param1))
         {
            _loc3_ = mNodeIdToFriendInfoJson.itemFor(param1);
            _loc2_.push(com.maccherone.json.JSON.decode(_loc3_.weapon1));
            _loc2_.push(com.maccherone.json.JSON.decode(_loc3_.weapon2));
            _loc2_.push(com.maccherone.json.JSON.decode(_loc3_.weapon3));
         }
         return _loc2_;
      }
   }
}

