import java.io.*;
import com.teneo.esa.common.util.Version;

/*
**
** Description:
**
**     Display build information from Version.class
**
*/
public class buildinfo {

    public static void main(String[] args) {
        //System.out.println("Version:               " + Version.getVersion());
        //System.out.println("Build Release Number:  " + Version.getBuildReleaseNumber());
        //System.out.println("Product Version:       " + Version.getProductVersion());
        //System.out.println("Patch Set Number:      " + Version.getPatchSetNumber());
        //System.out.println("Software Version:      " + Version.getSoftwareVersion());
        //System.out.println("Branchless Version:    " + Version.getBranchlessVersion());
        //System.out.println("Build Number:          " + Version.getBuildNumber());
        //System.out.println("Build Name:            " + Version.getBuildName());
        //System.out.println("Patch Number:          " + Version.getPatchNumber());
        //System.out.println("Product Major Version: " + Version.getProductMajorVersion());
        System.out.println(Version.getSoftwareVersion());
    }
}
