#!/usr/bin/perl
#
# Description:
#    Script for querying the databases and tables.
#
# Options:
#    -h <hostname>    Hostname where MySQL server is located (defaults to localhost).
#    -u <username>    Username to access database. (REQUIRED)
#    -p <password>    Password to access database. (REQUIRED)
#
#    -c               List the database associated with each Case.
#
#    -d all           List all the databases and all the tables in each.
#    -d <database>    List the tables in a specific database.
#
#    -t all           List all the tables and the databases they are in.
#    -t <table>       List the databases containing a specific table.
#
#    -help            Display this help and usage examples.
#
# Examples:
#    List the database associated with each Case:
#        perl querydb.pl -c -u dbusr -p dbpwd
#
#    List the tables in a specific database:
#        perl querydb.pl -d esadb -u dbusr -p dbpwd
#
#    List the databases containing a specific table:
#        perl querydb.pl -t t_user -u dbusr -p dbpwd
#
#    List the databases containing either of two specific tables:
#        perl querydb.pl -t t_user -t t_deleteworkarea -u dbusr -p dbpwd
#
#    List the tables in two specific databases:
#        perl querydb.pl -d esadb -d esadb_system -u dbusr -p dbpwd
#
#    List all the databases and the tables in each:
#        perl querydb.pl -d all -u dbusr -p dbpwd
#
#    List all the tables and the databses they are in:
#        perl querydb.pl -t all -u dbusr -p dbpwd
#
# END Description

use strict;
use File::Spec;
# See http://perldoc.perl.org/Getopt/Long.html#Getting-Started-with-Getopt%3a%3aLong
use Getopt::Long;

$| = 1;  # Flush stdout

# Usage: perl querydb.pl [-c] [ -table table|all ] [ -database database|all ] -user user -password password
my $DB_USER;
my $DB_PASSWORD;
my $DB_HOSTNAME = 'localhost';
my @TABLES;
my @DATABASES;
my $list_case_databases;
my $bad_args = 0;
GetOptions ('u|user=s'      => \$DB_USER, 
            'p|password=s'  => \$DB_PASSWORD, 
            'h|hostname=s'  => \$DB_HOSTNAME,
            't|table=s@'    => \@TABLES,
            'd|database=s'  => \@DATABASES,
	    'c|cases'       => \$list_case_databases,
            'help'          => sub { usage() });
			
# Mandatory arguments.
unless (defined $DB_USER) {
    print "Error: The database user must be specified using the -u option!\n";
    $bad_args = 1;
}
unless (defined $DB_PASSWORD) {
    print "Error: The database password must be specified using the -p option!\n";
    $bad_args = 1;
}
if ($bad_args == 1) {
    exit(1);
}

my $opt_list_all_databases = 0;
my $opt_list_tables_in_specific_databases = 0;
if (@DATABASES) {
    if (scalar(@DATABASES) == 1 && grep( /^all$/, @DATABASES)) {
	$opt_list_all_databases = 1;
    } else {
        $opt_list_tables_in_specific_databases = 1;
    }		
}

my $opt_list_all_tables = 0;
my $opt_print_table_schemas = 1;
my $opt_list_databases_containing_specific_tables = 0;
if (@TABLES) {
    if (scalar(@TABLES) == 1 && grep( /^all$/, @TABLES)) {
	$opt_list_all_tables = 1;
    } else {
        $opt_list_databases_containing_specific_tables = 1;
    }		
}

# For some reason GetOptions() is not automatically exiting
# the script when required arguments are missing.
if ($opt_list_all_databases == 0 &&
    $opt_list_tables_in_specific_databases == 0 &&
    $opt_list_all_tables == 0 &&
    $opt_list_databases_containing_specific_tables == 0 &&
	!defined($list_case_databases)) {
    exit(99);
}

# Display the description and example section from the top of this script.
sub usage 
{
    # Determine full path to this script.
    my $script_path = File::Spec->rel2abs( __FILE__ );

    my $OUTPUT_FH;
    open($OUTPUT_FH, $script_path) || die "Failed: $!\n";
    while (<$OUTPUT_FH>)
    {
        next unless ($. > 1);  # Only do work if on > 2nd line.
        chomp; 
        if (/^# END Description/) { 
            # End of relevant text section.
            last;
        }
       	if (/^#/) {
      	    $_ =~ s/^#/    /;
            print "$_\n";
        }
    }	
    close($OUTPUT_FH);	
    exit(2);
}

sub getDatabaseList
{
    my @databases;
    my $OUTPUT_FH;
    open($OUTPUT_FH,"mysql -N -B -e \"SHOW DATABASES\" -h $DB_HOSTNAME -u $DB_USER -p$DB_PASSWORD | sort |") || die "Failed: $!\n";
    while (<$OUTPUT_FH>)
    {
        chomp;
        push(@databases, $_);
    }
    close($OUTPUT_FH);
    return (@databases);
}

sub getTableList
{
    my $database = $_[0];
    my @tables;
    my $OUTPUT_FH;
    open($OUTPUT_FH,"mysql -N -B -e \"SHOW TABLES FROM $database\" -h $DB_HOSTNAME -u $DB_USER -p$DB_PASSWORD | sort |") || die "Failed: $!\n";
    while (<$OUTPUT_FH>)
    {
        chomp;
        push(@tables, $_);
    }
    close($OUTPUT_FH);
    return (@tables);
}

# Collect Database and Table data, creating hashes  
# of "Database to Tables" and "Table to Databases" .
my %hash_database_to_tables = ();
my %hash_table_to_databases = ();
my @databases = getDatabaseList();
foreach my $db (@databases) {
    # "Database to Tables" hash is easy.
    my @tables = getTableList($db);
    $hash_database_to_tables{$db} = \@tables;
	
    # "Table to Databases" hash is more complicated, since 
    # the same Table might be used in multiple databases.
    foreach my $tbl (@tables) {
        if (exists $hash_table_to_databases{$tbl}) {
	    # We already have an array of Databases for this Table.
		
	    # We need to check if this particular Database is included in the
	    # array. We do this by converting the Databases array into a hash
	    # and then using the "exists()" function.
	    my %dbs_as_hash = map { $_ => 1 } @{$hash_table_to_databases{$tbl}};
            unless (exists $dbs_as_hash{$db}) {
	        # Add Database to the Databases array for this Table.
            push(@{$hash_table_to_databases{$tbl}}, $db);
            } 
	} else {
	    # We don't have an array of Databases for this Table.
			
        # Create Database array and add it.
	    my @db_array = ($db);
		$hash_table_to_databases{$tbl} = \@db_array;
	}
    }
}

# TESTING		
sub printDatabaseToTablesHash
{
    foreach my $d (sort keys %hash_database_to_tables) {
        print "\nDATABASE: $d\n";
        my @t_array = @{$hash_database_to_tables{$d}};
        foreach my $t (@t_array) {
            print "  TABLE: $t\n";
        }
    }		
}
# TESTING
sub printTableToDatabasesHash
{
    foreach my $t (sort keys %hash_table_to_databases) {
        print "\nTABLE: $t\n";
     	my @d_array = @{$hash_table_to_databases{$t}};
        foreach my $d (@d_array) {
            print "  DATABASE: $d\n";
        }  
    }		
}

#
# Perform all the requested operations.
#

if (defined($list_case_databases)) {
    my $OUTPUT_FH;
    print "\nOPERATION: List the database asosciated with each Case.\n";
    print "\nRESULTS:\n\n";
    open($OUTPUT_FH,"mysql -e \"SHOW DATABASES\" -h $DB_HOSTNAME -u $DB_USER -p$DB_PASSWORD | sort |") || die "Failed: $!\n";
    while (<$OUTPUT_FH>)
    {
        # We only want to bother with the Case databases.
        if (/esadb_lds_case_[0-9]{9}/) {
            chomp;
            my $case_db = $_;
            my $case_name;
            my $OUTPUT_FH2;
            open($OUTPUT_FH2, "mysql -N -B -e \"SELECT NAME FROM $case_db.t_case\" -h $DB_HOSTNAME -u $DB_USER -p$DB_PASSWORD |") || die "Failed: $!\n";
            while (<$OUTPUT_FH2>)
            {
                chomp;
                $case_name = $_;
            }
            close($OUTPUT_FH2);
            printf "%30s  %s\n", $case_name, $case_db;
        }
    }
    close($OUTPUT_FH);
    print "\nEND OF RESULTS\n";
}

if ($opt_list_all_databases) {
    print "\nOPERATION: List all the databases and the tables in each.\n";
    print "\nRESULTS:\n\n";
    foreach my $db (sort keys %hash_database_to_tables) {
        print "\nDATABASE: $db\n";
        print "TABLES:\n";
        my @tbl_array = @{$hash_database_to_tables{$db}};
        foreach my $tbl (@tbl_array) {
            print "\n   $tbl\n";
            if ($opt_print_table_schemas) {
                my $case_name;
                my $OUTPUT;
                open($OUTPUT, "mysql -e \"DESC $db.$tbl\" -h $DB_HOSTNAME -u $DB_USER -p$DB_PASSWORD |") || die "Failed: $!\n";
                while (<$OUTPUT>)
                {
                     printf "   %s", $_;
                }
                close($OUTPUT);
            }
        }
    }
    print "\nEND OF RESULTS\n";
}

if ($opt_list_tables_in_specific_databases) {
   print "\nOPERATION: List tables in the following databases: @DATABASES\n";
   print "\nRESULTS:\n";
   foreach my $db (@DATABASES) {
       print "\nDATABASE: $db\n";
       print "TABLES:\n";
       unless (exists $hash_database_to_tables{$db}) {
           print "No such database: $db\n";
       } else {
           my @db_tbls = @{$hash_database_to_tables{$db}};
           foreach my $t (@db_tbls) {
               print "   $t\n";
           }
       }
   }
   print "\nEND OF RESULTS\n";
}

if ($opt_list_all_tables) {
    print "\nOPERATION: List all tables and the databases there are in.\n";
    print "\nRESULTS:\n\n";
    foreach my $tbl (sort keys %hash_table_to_databases) {
	    print "\nTABLE: $tbl\n";
        print "DATABASES:\n";
        my @tbl_dbs = @{$hash_table_to_databases{$tbl}};
        foreach my $db (@tbl_dbs) {
               print "   $db\n";
        }
    }
	print "\nEND OF RESULTS\n";
}

if ($opt_list_databases_containing_specific_tables) {
    print "\nOPERATION: List databases containing the following tables: @TABLES\n";
    print "\nRESULTS:\n";
    foreach my $tbl (@TABLES) {
        print "\nTABLE: $tbl\n";
        print "DATABASES:\n";
        unless (exists $hash_table_to_databases{$tbl}) {
            print "No such table: $tbl\n"
        } else { 
            my @tbl_databases = @{$hash_table_to_databases{$tbl}};
            foreach my $db (@tbl_databases) {
               print "   $db\n";
            }
        }
    }
    print "\nEND OF RESULTS\n";
}

# END
