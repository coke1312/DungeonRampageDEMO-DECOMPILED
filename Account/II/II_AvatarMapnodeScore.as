package Account.II
{
   import org.as3commons.collections.Map;
   
   public class II_AvatarMapnodeScore
   {
      
      public var nodeIdToScore:Map;
      
      public function II_AvatarMapnodeScore(param1:Object)
      {
         super();
         nodeIdToScore = new Map();
         updateMapnodeScore(param1);
      }
      
      public function updateMapnodeScore(param1:Object) : void
      {
         var _loc2_:* = null;
         nodeIdToScore.add(int(param1.mapnode_id),int(param1.score));
      }
   }
}

