import org.nlogo.api.*;

public class PopcoExtension extends DefaultClassManager {

  public void load(PrimitiveManager primitiveManager) {
      primitiveManager.addPrimitive("bali-once", new BaliOnce());
  }
}
