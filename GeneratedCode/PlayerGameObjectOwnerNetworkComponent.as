package GeneratedCode
{
   import DistributedObjects.PlayerGameObjectOwner;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class PlayerGameObjectOwnerNetworkComponent extends PlayerGameObjectNetworkComponent implements DcNetworkInterface
   {
      
      private var the_instance:IPlayerGameObjectOwner;
      
      public function PlayerGameObjectOwnerNetworkComponent(param1:PlayerGameObjectOwner, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function ownerFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : PlayerGameObjectOwnerNetworkComponent
      {
         var _loc5_:PlayerGameObjectOwner = new PlayerGameObjectOwner(param2.facade,param3);
         var _loc4_:PlayerGameObjectOwnerNetworkComponent = new PlayerGameObjectOwnerNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentPlayerGameObject(_loc4_);
         _loc5_.setOwnerNetworkComponentPlayerGameObject(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 181)
         {
            case 0:
               recv_basicCurrency(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_screenName(param1);
         recv_basicCurrency(param1);
         recvByIdLoop(param1);
      }
      
      public function recv_basicCurrency(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.basicCurrency = _loc2_;
      }
      
      public function send_Chat(param1:String) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,182);
         _loc2_.writeUTF(param1);
         Send_packet(_loc2_);
      }
      
      public function send_ShowPlayerIsTyping(param1:uint) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,183);
         _loc2_.writeByte(param1);
         Send_packet(_loc2_);
      }
      
      public function send_requesthero() : void
      {
         var _loc1_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc1_,184);
         Send_packet(_loc1_);
      }
      
      public function send_requestentry() : void
      {
         var _loc1_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc1_,185);
         Send_packet(_loc1_);
      }
      
      public function send_requestpartymemberinvite() : void
      {
         var _loc1_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc1_,186);
         Send_packet(_loc1_);
      }
   }
}

