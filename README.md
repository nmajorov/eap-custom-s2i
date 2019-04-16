# jboss eap 7.2 add oracle_ds

This uses jboss-eap-openshift docker image and adds support for the Oracle JDBC driver as a jboss module


- Modified standalone-openshift.xml to include the Oracle Driver
- Modified s2i/run script to include type "ORACLE" datasource type.
- Added flyway as a pre-hook to the RollingUpdate deployment-strategy in the examples/sample-app-dc-flyway.yml deploymentconfig object.


# Service Discovery

Datasources are automatically created based on the value of some environment variables.

The most important is the DB_SERVICE_PREFIX_MAPPING environment variable which defines JNDI mappings for data sources. It must be set to a comma-separated list of <name>_<database_type>=<PREFIX> triplets, where name is used as the pool-name in the data source, database_type determines what database driver to use, and PREFIX is the prefix used in the names of environment variables, which are used to configure the data source.

For each <name>-<database_type>=PREFIX triplet in the DB_SERVICE_PREFIX_MAPPING environment variable, a separate datasource will be created by the launch script, which is executed when running the image.  
The <database_type> will determine the driver for the datasource.

The jboss_eap only supports postgresql and mysql, i added oracle.

Oracle driver example  configuration:

                  <driver name="oracle" module="com.oracle">
                    <xa-datasource-class>oracle.jdbc.xa.client.OracleXADataSource</xa-datasource-class>
                  </driver>  


## Build image locally


      docker build -t majorov.biz/eap72 .


## Build and test s2i  image localy

Install the S2I tool from the Red Hat Software Collections repository:

      yum install source-to-image

      s2i build  -e oracle_DRIVER_NAME=oracle \
      -e oracle_DRIVER_CLASS=oracle.jdbc.xa.client.OracleXADataSource \
       -e DATABASETYPE=oracle -e oracle_USERNAME=system \
      -e oracle_PASSWORD=oracle -e oracle_JNDI=java:jboss/datasources/TodoListDS \
      -e oracle_URL=jdbc:oracle:thin:@localhost:1521:XE \
        https://github.com/nmajorov/html5-frontend-sso.git \
        majorov.biz/eap72  rh-eap72-app  
