package Brain.Render
{
   public class SortedLayer extends Layer
   {
      
      public function SortedLayer(param1:int = 0)
      {
         super(param1);
      }
      
      override public function render() : void
      {
         this.sortLayer();
      }
   }
}

