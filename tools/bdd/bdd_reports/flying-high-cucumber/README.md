# BDD reports - Cucumber built-in report vs "Cucumber Reports"

See my comments in pom.xml for how I got "Cucumber Reports" to work (https://github.com/damianszczepanik/cucumber-reporting)

To build reports:
mvn verify

This generates additional reports, in the "target" directory.

The built-in cucumber "html" report:
./target/cucumber-html-report/index.html

The additiona "Cucumber Reports" reports:
./target/cucumber-html-reports/overview-features.html


JeremyC 30-07-2019
