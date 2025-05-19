package UI.InfiniteIsland
{
   public class II_ChampionsboardListPerNode
   {
      
      private var mListOfTopScores:Vector.<II_ChampionsboardTopScore>;
      
      public function II_ChampionsboardListPerNode(param1:Object)
      {
         super();
         mListOfTopScores = new Vector.<II_ChampionsboardTopScore>();
         for each(var _loc2_ in param1)
         {
            if(_loc2_.name)
            {
               mListOfTopScores.push(new II_ChampionsboardTopScore(_loc2_.name,_loc2_.score,_loc2_.active_skin != null ? _loc2_.active_skin : 151,_loc2_.weapon1,_loc2_.weapon2,_loc2_.weapon3));
            }
            else
            {
               mListOfTopScores.push(new II_ChampionsboardTopScore(_loc2_.account_id,_loc2_.score,_loc2_.active_skin != null ? _loc2_.active_skin : 151,_loc2_.weapon1,_loc2_.weapon2,_loc2_.weapon3));
            }
         }
      }
      
      public function getTotalScores() : int
      {
         return mListOfTopScores.length;
      }
      
      public function getTopScoreForNum(param1:int) : II_ChampionsboardTopScore
      {
         return mListOfTopScores[param1];
      }
      
      public function sort() : void
      {
         mListOfTopScores.sort(sortTopScores);
      }
      
      private function sortTopScores(param1:II_ChampionsboardTopScore, param2:II_ChampionsboardTopScore) : int
      {
         return param2.score - param1.score;
      }
   }
}

