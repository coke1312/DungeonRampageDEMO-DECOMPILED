package NetworkCode
{
   public class DcNetworkClass
   {
      
      private static var CREATION_ORDER_SEED:uint = 0;
      
      private var the_gamesocket:DcSocket;
      
      public var do_id:uint;
      
      private var mCreationOrder:uint;
      
      public function DcNetworkClass(param1:*, param2:DcSocket, param3:uint)
      {
         super();
         do_id = param3;
         the_gamesocket = param2;
         mCreationOrder = ++CREATION_ORDER_SEED;
      }
      
      public function get creationOrder() : uint
      {
         return mCreationOrder;
      }
      
      public function recvByIdLoop(param1:DcNetworkPacket) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:DcNetworkInterface = this as DcNetworkInterface;
         if(!param1.eof())
         {
            _loc4_ = param1.readUnsignedShort();
            while(!param1.eof())
            {
               _loc2_ = param1.readUnsignedShort();
               _loc3_.recvById(param1,_loc2_);
            }
         }
      }
      
      public function Process_SetFieldValue(param1:DcNetworkPacket) : void
      {
         var _loc3_:DcNetworkInterface = this as DcNetworkInterface;
         var _loc2_:uint = param1.readUnsignedShort();
         _loc3_.recvById(param1,_loc2_);
      }
      
      public function Send_packet(param1:DcNetworkPacket) : void
      {
         the_gamesocket.sendpacket(param1);
      }
      
      public function Prepare_FieldUpdate(param1:DcNetworkPacket, param2:uint) : void
      {
         param1.writeShort(124);
         param1.writeUnsignedInt(do_id);
         param1.writeShort(param2);
      }
      
      public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
      }
      
      public function generate(param1:DcNetworkPacket) : void
      {
      }
      
      public function destroy() : void
      {
      }
   }
}

