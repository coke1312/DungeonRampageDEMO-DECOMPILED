package GeneratedCode
{
   import NetworkCode.DcNetworkPacket;
   
   public class InfiniteMapNodeDetail
   {
      
      public var epoc:uint;
      
      public var nodeId:uint;
      
      public var modifiers:Vector.<uint>;
      
      public function InfiniteMapNodeDetail()
      {
         super();
      }
      
      public static function readFromPacket(param1:DcNetworkPacket) : InfiniteMapNodeDetail
      {
         var packet:DcNetworkPacket = param1;
         var work:InfiniteMapNodeDetail = new InfiniteMapNodeDetail();
         work.epoc = packet.readUnsignedInt();
         work.nodeId = packet.readUnsignedInt();
         work.modifiers = (function(param1:DcNetworkPacket):Vector.<uint>
         {
            var _loc3_:* = 0;
            var _loc5_:* = 0;
            var _loc4_:Vector.<uint> = new Vector.<uint>();
            var _loc2_:uint = 4;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = param1.readUnsignedInt();
               _loc4_.push(_loc5_);
               _loc3_++;
            }
            return _loc4_;
         })(packet);
         return work;
      }
      
      public function writeToPacket(param1:DcNetworkPacket) : void
      {
         var _loc3_:* = 0;
         param1.writeUnsignedInt(epoc);
         param1.writeUnsignedInt(nodeId);
         var _loc2_:uint = 4;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            param1.writeUnsignedInt(modifiers[_loc3_]);
            _loc3_++;
         }
      }
   }
}

