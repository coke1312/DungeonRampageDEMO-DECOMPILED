package GeneratedCode
{
   import DistributedObjects.DistributedTownArea;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class DistributedTownAreaNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedTownArea;
      
      public const FLID_tileLibrary:uint = 285;
      
      public function DistributedTownAreaNetworkComponent(param1:DistributedTownArea, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedTownAreaNetworkComponent
      {
         var _loc5_:DistributedTownArea = new DistributedTownArea(param2.facade,param3);
         var _loc4_:DistributedTownAreaNetworkComponent = new DistributedTownAreaNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedTownArea(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 285)
         {
            case 0:
               recv_tileLibrary(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_tileLibrary(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_tileLibrary(param1:DcNetworkPacket) : void
      {
         var _loc2_:String = param1.readUTF();
         the_instance.tileLibrary(_loc2_);
      }
   }
}

