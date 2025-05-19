package GeneratedCode
{
   import DistributedObjects.PlayerGameObject;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class PlayerGameObjectNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:PlayerGameObject;
      
      public const FLID_screenName:uint = 180;
      
      public const FLID_basicCurrency:uint = 181;
      
      public const FLID_Chat:uint = 182;
      
      public const FLID_ShowPlayerIsTyping:uint = 183;
      
      public const FLID_requesthero:uint = 184;
      
      public const FLID_requestentry:uint = 185;
      
      public const FLID_requestpartymemberinvite:uint = 186;
      
      public const FLID_requestexit:uint = 187;
      
      public function PlayerGameObjectNetworkComponent(param1:PlayerGameObject, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : PlayerGameObjectNetworkComponent
      {
         var _loc5_:PlayerGameObject = new PlayerGameObject(param2.facade,param3);
         var _loc4_:PlayerGameObjectNetworkComponent = new PlayerGameObjectNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentPlayerGameObject(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 180)
         {
            case 0:
               recv_screenName(param1);
               break;
            case 2:
               recv_Chat(param1);
               break;
            case 3:
               recv_ShowPlayerIsTyping(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_screenName(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_screenName(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.screenName = _loc2_;
      }
      
      public function recv_Chat(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.Chat(_loc2_);
      }
      
      public function recv_ShowPlayerIsTyping(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         the_instance.ShowPlayerIsTyping(_loc2_);
      }
   }
}

