using Seido.Utilities.SeedGenerator;

namespace Models
{
    public enum FruitType { Apple, Banana, Orange, Pear, Peach }

    public class Fruit
    {
        public int FruitId { get; set; }
        public FruitType Type { get; set; }
        public double Weight { get; set; }
    }
}
