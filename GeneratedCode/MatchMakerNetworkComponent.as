package GeneratedCode
{
   import DistributedObjects.MatchMaker;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class MatchMakerNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:MatchMaker;
      
      public const FLID_InfiniteDetails:uint = 293;
      
      public const FLID_ClientRequestEntry:uint = 294;
      
      public const FLID_ClientRequestEntryResponce:uint = 295;
      
      public const FLID_RequestExit:uint = 296;
      
      public const FLID_ClientExitComplete:uint = 297;
      
      public const FLID_ClientDataFlushExit:uint = 298;
      
      public const FLID_ClientRequestPartyMemberInvite:uint = 299;
      
      public const FLID_RequestPartyMemberInvite:uint = 300;
      
      public const FLID_ClientRequestLeaveParty:uint = 301;
      
      public const FLID_ClientInformPartyComposition:uint = 302;
      
      public const FLID_Proxy_ClientRequestEntryResponce:uint = 303;
      
      public const FLID_RequestEntry:uint = 304;
      
      public const FLID_AreaManagerStatus:uint = 305;
      
      public const FLID_AreaStatus:uint = 306;
      
      public const FLID_MatchMaker_Newgame:uint = 307;
      
      public const FLID_RequestExitProxy:uint = 308;
      
      public const FLID_AreaExit:uint = 309;
      
      public const FLID_ForceAreaExit:uint = 310;
      
      public const FLID_PlayerExit:uint = 311;
      
      public const FLID_ReportAreaOutcome:uint = 312;
      
      public const FLID_TimingProbResp:uint = 313;
      
      public function MatchMakerNetworkComponent(param1:MatchMaker, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : MatchMakerNetworkComponent
      {
         var _loc5_:MatchMaker = new MatchMaker(param2.facade,param3);
         var _loc4_:MatchMakerNetworkComponent = new MatchMakerNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentMatchMaker(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 293)
         {
            case 0:
               recv_InfiniteDetails(param1);
               break;
            case 2:
               recv_ClientRequestEntryResponce(param1);
               break;
            case 4:
               recv_ClientExitComplete(param1);
               break;
            case 9:
               recv_ClientInformPartyComposition(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_InfiniteDetails(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_InfiniteDetails(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var value_0:Vector.<InfiniteMapNodeDetail> = (function(param1:DcNetworkPacket):Vector.<InfiniteMapNodeDetail>
         {
            var _loc5_:InfiniteMapNodeDetail = null;
            var _loc3_:Vector.<InfiniteMapNodeDetail> = new Vector.<InfiniteMapNodeDetail>();
            var _loc2_:uint = param1.readUnsignedShort();
            var _loc4_:uint = _loc2_ + param1.position;
            while(param1.position < _loc4_)
            {
               _loc5_ = InfiniteMapNodeDetail.readFromPacket(param1);
               _loc3_.push(_loc5_);
            }
            return _loc3_;
         })(packet);
         the_instance.InfiniteDetails(value_0);
      }
      
      public function send_ClientRequestEntry(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:String) : void
      {
         var _loc8_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc8_,294);
         _loc8_.writeUTF(param1);
         _loc8_.writeUnsignedInt(param2);
         _loc8_.writeUnsignedInt(param3);
         _loc8_.writeUnsignedInt(param4);
         _loc8_.writeUnsignedInt(param5);
         _loc8_.writeByte(param6);
         _loc8_.writeUTF(param7);
         Send_packet(_loc8_);
      }
      
      public function recv_ClientRequestEntryResponce(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = param1.readUnsignedInt();
         the_instance.ClientRequestEntryResponce(_loc2_,_loc3_);
      }
      
      public function send_RequestExit(param1:uint) : void
      {
         var _loc2_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc2_,296);
         _loc2_.writeUnsignedInt(param1);
         Send_packet(_loc2_);
      }
      
      public function recv_ClientExitComplete(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         the_instance.ClientExitComplete(_loc2_);
      }
      
      public function send_ClientRequestPartyMemberInvite(param1:String, param2:uint) : void
      {
         var _loc3_:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(_loc3_,299);
         _loc3_.writeUTF(param1);
         _loc3_.writeUnsignedInt(param2);
         Send_packet(_loc3_);
      }
      
      public function recv_ClientInformPartyComposition(param1:DcNetworkPacket) : void
      {
         var packet:DcNetworkPacket = param1;
         var partyMembers:Vector.<GameServerPartyMember> = (function(param1:DcNetworkPacket):Vector.<GameServerPartyMember>
         {
            var _loc3_:* = 0;
            var _loc5_:GameServerPartyMember = null;
            var _loc4_:Vector.<GameServerPartyMember> = new Vector.<GameServerPartyMember>();
            var _loc2_:uint = 4;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = GameServerPartyMember.readFromPacket(param1);
               _loc4_.push(_loc5_);
               _loc3_++;
            }
            return _loc4_;
         })(packet);
         the_instance.ClientInformPartyComposition(partyMembers);
      }
   }
}

