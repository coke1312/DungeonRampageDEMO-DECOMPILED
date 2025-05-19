package UI.InfiniteIsland
{
   import com.maccherone.json.JSON;
   
   public class II_ChampionsboardTopScore
   {
      
      public var name:String;
      
      public var score:int;
      
      public var skinId:int;
      
      private var mWeaponsJson:Vector.<Object>;
      
      public function II_ChampionsboardTopScore(param1:String, param2:int, param3:int, param4:String, param5:String, param6:String)
      {
         super();
         name = param1;
         score = param2;
         skinId = param3;
         mWeaponsJson = new Vector.<Object>();
         if(param4 != null)
         {
            mWeaponsJson.push(com.maccherone.json.JSON.decode(param4));
         }
         else
         {
            mWeaponsJson.push(null);
         }
         if(param4 != null)
         {
            mWeaponsJson.push(com.maccherone.json.JSON.decode(param5));
         }
         else
         {
            mWeaponsJson.push(null);
         }
         if(param4 != null)
         {
            mWeaponsJson.push(com.maccherone.json.JSON.decode(param6));
         }
         else
         {
            mWeaponsJson.push(null);
         }
      }
      
      public function get weaponsJson() : Vector.<Object>
      {
         return mWeaponsJson;
      }
   }
}

