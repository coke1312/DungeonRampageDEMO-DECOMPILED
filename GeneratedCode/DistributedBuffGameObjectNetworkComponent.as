package GeneratedCode
{
   import Actor.Buffs.DistributedBuffGameObject;
   import NetworkCode.DcNetworkClass;
   import NetworkCode.DcNetworkInterface;
   import NetworkCode.DcNetworkPacket;
   
   public class DistributedBuffGameObjectNetworkComponent extends DcNetworkClass implements DcNetworkInterface
   {
      
      private var the_instance:DistributedBuffGameObject;
      
      public const FLID_type:uint = 291;
      
      public const FLID_effectedActor:uint = 292;
      
      public function DistributedBuffGameObjectNetworkComponent(param1:DistributedBuffGameObject, param2:GeneratedDcSocket, param3:uint)
      {
         super(param1,param2,param3);
         the_instance = param1;
      }
      
      public static function netFactory(param1:DcNetworkPacket, param2:GeneratedDcSocket, param3:uint) : DistributedBuffGameObjectNetworkComponent
      {
         var _loc5_:DistributedBuffGameObject = new DistributedBuffGameObject(param2.facade,param3);
         var _loc4_:DistributedBuffGameObjectNetworkComponent = new DistributedBuffGameObjectNetworkComponent(_loc5_,param2,param3);
         _loc4_.generate(param1);
         _loc5_.setNetworkComponentDistributedBuffGameObject(_loc4_);
         _loc5_.postGenerate();
         return _loc4_;
      }
      
      override public function recvById(param1:DcNetworkPacket, param2:uint) : void
      {
         switch(int(param2) - 291)
         {
            case 0:
               recv_type(param1);
               break;
            case 1:
               recv_effectedActor(param1);
               break;
            default:
               super.recvById(param1,param2);
         }
      }
      
      override public function generate(param1:DcNetworkPacket) : void
      {
         recv_type(param1);
         recv_effectedActor(param1);
         recvByIdLoop(param1);
      }
      
      override public function destroy() : void
      {
         the_instance.destroy();
      }
      
      public function recv_type(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.type = _loc2_;
      }
      
      public function recv_effectedActor(param1:DcNetworkPacket) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         the_instance.effectedActor = _loc2_;
      }
   }
}

