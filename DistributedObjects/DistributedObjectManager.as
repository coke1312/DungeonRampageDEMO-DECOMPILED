package DistributedObjects
{
   import Facade.DBFacade;
   import GeneratedCode.GeneratedDcSocket;
   
   public class DistributedObjectManager
   {
      
      private var mDBfacade:DBFacade;
      
      private var mGeneratedDcSocket:GeneratedDcSocket;
      
      public var mMatchMaker:MatchMaker;
      
      public var mPresenceManager:PresenceManager;
      
      public function DistributedObjectManager(param1:DBFacade)
      {
         super();
         mDBfacade = param1;
      }
      
      public function Initialize(param1:String, param2:int, param3:String, param4:String, param5:uint, param6:uint, param7:uint) : Boolean
      {
         if(mGeneratedDcSocket != null)
         {
            mGeneratedDcSocket.destroy();
         }
         mGeneratedDcSocket = null;
         mGeneratedDcSocket = new GeneratedDcSocket(mDBfacade,param1,param2,param3,param4,param5);
         mGeneratedDcSocket.pass2Init(param6,param7);
         return true;
      }
      
      public function destroy() : void
      {
         if(mGeneratedDcSocket != null)
         {
            mGeneratedDcSocket.destroy();
         }
         mGeneratedDcSocket = null;
      }
      
      public function isAllOk() : Boolean
      {
         var _loc1_:Boolean = mGeneratedDcSocket != null && mGeneratedDcSocket.connected && mMatchMaker != null;
         trace("------------>isAllOk ",_loc1_);
         return _loc1_;
      }
      
      private function SocketIsLeaving() : void
      {
         if(mGeneratedDcSocket != null)
         {
            mGeneratedDcSocket.destroy();
         }
         mGeneratedDcSocket = null;
      }
      
      public function enterSocketErrorState(param1:uint, param2:String = "") : void
      {
         mDBfacade.mainStateMachine.enterSocketErrorState(param1,param2);
         mDBfacade.mDistributedObjectManager.SocketIsLeaving();
      }
   }
}

