import org.nlogo.api.*;

public class EvalExtension extends DefaultClassManager {

  public void load(PrimitiveManager primitiveManager) {
      primitiveManager.addPrimitive("eval", new Eval());
  }
}
