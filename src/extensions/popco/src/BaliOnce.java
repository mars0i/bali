import org.nlogo.api.*;
import java.net.*;

import clojure.java.api.Clojure;
//import clojure.lang.IFn;
import popco.core.main;

// Implementation of the 'bali-once' extension reporter/function
public class BaliOnce extends DefaultReporter {
	public Syntax getSyntax() {
		return Syntax.reporterSyntax(new int[] {Syntax.ListType()}, Syntax.ListType()); // argument types, return type
	}

	public Object report(Argument args[], Context context) throws ExtensionException {
		try {
			Object retObj = popco.core.main.nlogotest(args[0].getList()); // Now Clojure it.
			if (retObj == null) { return "nil"; }{ return retObj; } // FIXME
		} catch (Throwable e) {
			throw new ExtensionException( e.getMessage() ) ;
		}
	}
}
