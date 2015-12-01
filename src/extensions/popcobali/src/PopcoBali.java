import org.nlogo.api.*;
import java.net.*;

import clojure.java.api.Clojure;
import clojure.lang.IFn;
//import clojure.pprint.*;
import popco.core.*;

public class PopcoBali extends DefaultReporter {
	public Syntax getSyntax() {
		return Syntax.reporterSyntax(new int[] {Syntax.ListType()}, Syntax.StringType()); // single list as input, return string
	}

	public Object report(Argument args[], Context context) throws ExtensionException {
		try {
			addPath("extensions/popcobali/popcobali.jar"); // (addPath() defined below) <== PUT MY POPCO JAR FILE HERE
			IFn cljFn = Clojure.var("popco.core.main", "netlogo-test"); // IS THIS REALLY NECESSARY??  Can't I just call Clojure directly?
			Object retObj = cljFn.invoke(cljFn.invoke(args[0])); // Now Clojure it.
			if (retObj == null) { return "nil"; }{ return retObj.toString(); }
		} catch (Throwable e) {
			throw new ExtensionException( e.getMessage() ) ;
		}
	}

	// Slightly modified from http://jimlife.wordpress.com/2007/12/19/java-adding-new-classpath-at-runtime. (Thanks Jim!)
	// (There's supposed to be a way to do this without reflection, but I haven't gotten it to work with NetLogo.
	//  See e.g. http://www.coderanch.com/t/384068/java/java/Adding-JAR-file-Classpath-at.)
	public static void addPath(String s) throws Exception {
		java.io.File f = new java.io.File(s);
		URL url = f.toURI().toURL();
		URLClassLoader urlClassLoader = (URLClassLoader) ClassLoader.getSystemClassLoader();
		Class<?> urlClass = URLClassLoader.class;
		java.lang.reflect.Method method = urlClass.getDeclaredMethod("addURL", new Class[]{URL.class});
		method.setAccessible(true);
		method.invoke(urlClassLoader, new Object[]{url});
	}
}

// IS THIS NECESSARY??
class AddToClassLoader extends URLClassLoader{
 
    /**
     * @param urls accepts the existing classpath
     */
    public AddToClassLoader(URL[] urls) {
        super(urls);
    }
    
    @Override
    /**
     * add classpath to the loader.
     */
    public void addURL(URL url) {
        super.addURL(url);
    }
}
