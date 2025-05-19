package GeneratedCode
{
   import DistributedObjects.PresenceManager;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class PresenceManagerNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:PresenceManager;
      
      public const FLID_friendState:uint = 188;
      
      public const FLID_addFriends:uint = 189;
      
      public function PresenceManagerNetworkComponent(param1:PresenceManager, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : PresenceManagerNetworkComponent
      {
         var _loc5_:PresenceManager = new PresenceManager(param2.facade,param3);
         var _loc4_:PresenceManagerNetworkComponent = new PresenceManagerNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentPresenceManager(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 188)
         {
            case 0:
               recv_friendState(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_friendState(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc3_:uint = param1.readUnsignedInt();
         the_instance.friendState(_loc2_,_loc4_,_loc3_);
      }
      
      public function send_addFriends(param1:Vector.<uint>) : void
      {
         var whofunc:Function;
         var who:Vector.<uint> = param1;
         var outpacket:DcNetworkPacket = new DcNetworkPacket();
         Prepare_FieldUpdate(outpacket,189);
         whofunc = function():void
         {
            var _loc2_:* = 0;
            var _loc3_:uint = who.length;
            var _loc1_:DcNetworkPacket = outpacket;
            outpacket = new DcNetworkPacket();
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               outpacket.writeUnsignedInt(who[_loc2_]);
               _loc2_++;
            }
            _loc1_.writeShort(outpacket.length);
            _loc1_.writeBytes(outpacket);
            outpacket = _loc1_;
         };
         whofunc();
         Send_packet(outpacket);
      }
   }
}

