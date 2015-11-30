import org.nlogo.api.*;

public class PopcoBaliExtension extends DefaultClassManager {

  public void load(PrimitiveManager primitiveManager) {
      primitiveManager.addPrimitive("popcobali", new PopcoBali());
  }
}
