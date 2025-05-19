package Account
{
   public class MapnodeInfo
   {
      
      public static const NODE_STATE_DEFEATED:uint = 1;
      
      public static const NODE_STATE_OPEN:uint = 2;
      
      public static const NODE_STATE_OPEN_NOT_DEFEATED:uint = 3;
      
      private var mMapnodeJson:Object;
      
      private var mMapnodeId:uint;
      
      private var mAccountId:uint;
      
      private var mId:uint;
      
      private var mMapnodeState:uint;
      
      private var mResponseCallback:Function;
      
      private var mCallbackSuccess:Function;
      
      private var mCallbackFailure:Function;
      
      public function MapnodeInfo()
      {
         super();
      }
      
      public function get id() : uint
      {
         return mId;
      }
      
      public function get nodeId() : uint
      {
         return mMapnodeId;
      }
      
      public function get MapnodeState() : uint
      {
         return mMapnodeState;
      }
      
      public function set MapnodeState(param1:uint) : void
      {
         mMapnodeState = param1;
      }
      
      public function init(param1:uint, param2:uint) : void
      {
         mMapnodeId = param1;
         mMapnodeState = param2;
      }
      
      private function parseMapnodeJson(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         mMapnodeId = param1.node_id as uint;
         mAccountId = param1.account_id as uint;
         mId = param1.id as uint;
         mMapnodeState = param1.node_state as uint;
      }
      
      public function parseResponse(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         mMapnodeId = param1.node_id as uint;
         mAccountId = param1.account_id as uint;
         mId = param1.id as uint;
         mMapnodeState = param1.node_state as uint;
         if(mCallbackSuccess != null)
         {
            mCallbackSuccess(this);
         }
      }
   }
}

