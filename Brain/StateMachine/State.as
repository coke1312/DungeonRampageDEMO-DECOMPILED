package Brain.StateMachine
{
   public class State
   {
      
      protected var mName:String = new String();
      
      protected var mFinishedCallback:Function;
      
      protected var mRunning:Boolean = false;
      
      public function State(param1:String, param2:Function = null)
      {
         super();
         mName = param1;
         mFinishedCallback = param2;
      }
      
      public function get running() : Boolean
      {
         return mRunning;
      }
      
      public function set finishedCallback(param1:Function) : void
      {
         mFinishedCallback = param1;
      }
      
      public function get name() : String
      {
         return mName;
      }
      
      public function enterState() : void
      {
         mRunning = true;
      }
      
      public function exitState() : void
      {
         mRunning = false;
      }
      
      public function destroy() : void
      {
         mFinishedCallback = null;
         mRunning = false;
      }
   }
}

