import org.nlogo.api.*;
import java.net.*;

import clojure.java.api.Clojure;
import clojure.lang.IFn;
//import popco.core.*;

// Implementation of the 'bali-once' extension reporter/function
public class BaliOnce extends DefaultReporter {
	public Syntax getSyntax() {
		return Syntax.reporterSyntax(new int[] {Syntax.ListType()}, Syntax.ListType()); // argument types, return type
	}

	public Object report(Argument args[], Context context) throws ExtensionException {
		try {
			addPath("extensions/popco/popco2-1.0.0-standalone.jar");  // (addPath() defined below) 
			//IFn cljFn = Clojure.var("popco.core.Nlogo", "once");
			IFn cljFn = Clojure.var("popco.core.main", "nlogotest");
			System.out.println(cljFn + " Yow!");
			Object retObj = cljFn.invoke(args[0].getList()); // ERROR HERE
			//Object retObj = Nlogo.once(args[0].getList());
			if (retObj == null) { return "nil"; }{ return retObj; } // FIXME
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
