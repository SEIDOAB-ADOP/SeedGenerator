using Seido.Utilities.SeedGenerator;

namespace Models
{
    public class csPet : ISeed<csPet>, IEquatable<csPet>
    {
        public string PetName { get; set; }
        public override string ToString() => $"{PetName}";

        #region ISeed implementation to use csSeeGenerator to create random lists
        public bool Seeded { get; set; } = false;

        public csPet Seed(SeedGenerator rnd)
        {
            PetName = rnd.PetName;
            return this;
        }
        #endregion

        #region implementing IEquatable to use SeedGenerator Unique lists
        public bool Equals(csPet other) => (other != null) ? (PetName) == (other.PetName) : false;

        public override bool Equals(object obj) => Equals(obj as csPet);
        public override int GetHashCode() => (PetName).GetHashCode();
        #endregion

    }
}