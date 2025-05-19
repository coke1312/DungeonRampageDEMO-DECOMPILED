package Brain.WorkLoop
{
   import Brain.Clock.GameClock;
   import flash.display.Sprite;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.ISetIterator;
   
   public class WorkLoopManager extends Sprite
   {
      
      protected var mTasks:Set = new Set();
      
      protected var mCurrentGameClock:GameClock;
      
      protected var doLaterQueue:SimplePriorityQueue = new SimplePriorityQueue(1024);
      
      public function WorkLoopManager(param1:GameClock)
      {
         super();
         mCurrentGameClock = param1;
      }
      
      public function update(param1:GameClock) : void
      {
         mCurrentGameClock = param1;
         advance();
      }
      
      public function get gameClock() : GameClock
      {
         return mCurrentGameClock;
      }
      
      public function doEveryFrame(param1:Function) : Task
      {
         var _loc2_:Task = new Task();
         _loc2_.callback = param1;
         mTasks.add(_loc2_);
         return _loc2_;
      }
      
      public function doEverySeconds(param1:Number, param2:Function, param3:Boolean = true) : DoLater
      {
         return doLater(param1,param2,param3);
      }
      
      public function CalculateCallbackTime(param1:Number) : uint
      {
         return mCurrentGameClock.gameTime + param1 * 1000;
      }
      
      public function doLater(param1:Number, param2:Function, param3:Boolean = true) : DoLater
      {
         var _loc4_:DoLater = new DoLater(param3);
         _loc4_.delay = param1;
         _loc4_.dueTime = mCurrentGameClock.gameTime + _loc4_.delay * 1000;
         _loc4_.callback = param2;
         doLaterQueue.enqueue(_loc4_);
         return _loc4_;
      }
      
      protected function removeDoLater(param1:DoLater) : Boolean
      {
         param1.destroy();
         return doLaterQueue.remove(param1);
      }
      
      protected function removeTask(param1:Task) : Boolean
      {
         param1.destroy();
         return mTasks.remove(param1);
      }
      
      private function advance() : void
      {
         processTasks();
         processDoLaters();
      }
      
      private function processTasks() : void
      {
         var _loc2_:Task = null;
         if(mTasks.size == 0)
         {
            return;
         }
         var _loc1_:ISetIterator = mTasks.iterator() as ISetIterator;
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next();
            if(_loc2_.isDestroyed())
            {
               _loc1_.remove();
            }
            else if(_loc2_.callback != null)
            {
               _loc2_.callback(mCurrentGameClock);
            }
         }
      }
      
      private function processDoLaters() : void
      {
         var _loc1_:DoLater = null;
         if(doLaterQueue.size == 0)
         {
            return;
         }
         while(doLaterQueue.front && doLaterQueue.front.priority >= -mCurrentGameClock.gameTime)
         {
            _loc1_ = doLaterQueue.dequeue() as DoLater;
            if(_loc1_ && !_loc1_.isDestroyed())
            {
               if(_loc1_.callback != null)
               {
                  _loc1_.callback(mCurrentGameClock);
               }
               if(_loc1_.repeat)
               {
                  _loc1_.dueTime += _loc1_.delay * 1000;
                  doLaterQueue.enqueue(_loc1_);
               }
            }
         }
      }
   }
}

