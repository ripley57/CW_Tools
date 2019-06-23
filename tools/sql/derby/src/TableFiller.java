import java.sql.*;

public class TableFiller {
	Connection conn = null;
	PreparedStatement insertCust = null;
	PreparedStatement insertOrder = null;

	String driverName = "org.apache.derby.jdbc.EmbeddedDriver";
	/*
 	** Our database "mydb" is in the current directory, so we could
	** use the following, if we are also using embedded Derby:
	** String url = "jdbc:derby:mydb";
	**
	** Alternatively, we can specify the url using a property value.
	** Here's an example, and with a different location of the db:
	** String url = "jdbc:derby:c:/derby/mydb"
	**
	** Derby can also be run in the traditional standalone server
	** mode,like this:
	** String url = "jdbc:derby:net://localhost/mydb:user=APP;password=APP;"
	**
	** Note: This program assumes that the database "mydb" (and tables)
	**       have already been created. You need to follow the command-line
	**       steps in REAMDE.txt to do this.
	*/
	String url = null;

	public void loadDrivers()
			throws SQLException, ClassNotFoundException {
		Class.forName(driverName);
		conn = DriverManager.getConnection(this.url);
		insertCust = conn.prepareStatement("INSERT INTO custs VALUES(?, ?)");
		insertOrder = conn.prepareStatement("INSERT INTO orders VALUES(?, ?, ?)");
	}

	public TableFiller(String url) {
		this.url = url;
	}

	public static void main(String args[])
			throws Exception {

		// Default to an embedded Derby instance.
		String s = "jdbc:derby:c:/temp/mydb";

		// Use a networked (i.e. client-server standalone) Derby instance?
		if (args.length > 0 && args[0].equals("networked")) {	
			s = "jdbc:derby://localhost:1527/c:/temp/mydb;create=false";
		}

		TableFiller tf = new TableFiller(s);
		tf.loadDrivers();
		int orderNum = 1;
		for (int i=1; i<1001; i++) {
			String custNum = "" + i;
			tf.addCustomer(custNum, "customer #" + i);
			System.out.print("\n" + custNum);
			for (int j=1; j<11; j++) {
				tf.addOrder("" + orderNum, custNum, j*99);
				orderNum++;
				System.out.println(".");
			}
		}
		tf.closeAll();
	}

	public void addCustomer(String id, String custname)
			throws SQLException {
		insertCust.setString(1, id);
		insertCust.setString(2, custname);
		insertCust.executeUpdate();
	}

	public void addOrder(String id, String custid, int total)
			throws SQLException {
		insertOrder.setString(1, id);
		insertOrder.setString(2, custid);
		insertOrder.setInt(3, total);
		insertOrder.executeUpdate();
	}

	public void closeAll()
			throws SQLException {
		insertCust.close();
		insertOrder.close();
		conn.close();
	}
}
