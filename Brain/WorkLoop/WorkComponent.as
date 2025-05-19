package Brain.WorkLoop
{
   import Brain.Clock.GameClock;
   import Brain.Component.Component;
   import Brain.Facade.Facade;
   import flash.utils.Dictionary;
   
   public class WorkComponent extends Component
   {
      
      protected var mWorkLoopManager:WorkLoopManager;
      
      protected var mTasks:Dictionary;
      
      public function WorkComponent(param1:Facade, param2:WorkLoopManager)
      {
         super(param1);
         mTasks = new Dictionary(true);
         mWorkLoopManager = param2;
      }
      
      public function get gameClock() : GameClock
      {
         return mWorkLoopManager.gameClock;
      }
      
      public function doEveryFrame(param1:Function) : Task
      {
         var _loc2_:Task = mWorkLoopManager.doEveryFrame(param1);
         mTasks[_loc2_] = 1;
         return _loc2_;
      }
      
      public function doLater(param1:Number, param2:Function) : Task
      {
         var _loc3_:Task = mWorkLoopManager.doLater(param1,param2,false);
         mTasks[_loc3_] = 1;
         return _loc3_;
      }
      
      public function doEverySeconds(param1:Number, param2:Function) : Task
      {
         var _loc3_:Task = mWorkLoopManager.doEverySeconds(param1,param2,true);
         mTasks[_loc3_] = 1;
         return _loc3_;
      }
      
      public function clear() : void
      {
         for(var _loc1_ in mTasks)
         {
            Task(_loc1_).destroy();
         }
         mTasks = new Dictionary(true);
      }
      
      override public function destroy() : void
      {
         for(var _loc1_ in mTasks)
         {
            Task(_loc1_).destroy();
         }
         mTasks = null;
         mWorkLoopManager = null;
         super.destroy();
      }
   }
}

