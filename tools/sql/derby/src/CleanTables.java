import java.sql.*;

public class CleanTables {
	public static void delAll()
			throws SQLException {
		/*
 		** The JDBC connector used here tells Derby to supply
		** a default connection to the code. Derby will manage
		** this connection.
		**
		** Note: If we have a referential constraint in place,
		** we only need to delete the records in the custs table
		** in order to also delete the records in the orders table.
		*/	
		Connection conn = DriverManager.getConnection(
			"jdbc:default:connection");

		Statement delCusts = conn.createStatement();
		delCusts.executeUpdate(
			"delete from custs");

		delCusts.close();
		conn.close();
	}
}
