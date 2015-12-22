import org.nlogo.api.*;

public class PopcoExtension extends DefaultClassManager {

  public void load(PrimitiveManager primitiveManager) {
      primitiveManager.addPrimitive("bali-talk", new BaliTalk());
  }
}
