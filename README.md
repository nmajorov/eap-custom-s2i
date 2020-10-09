# jboss eap openshift s2i 7.2 
# oracle datasource plus driver installation

This uses jboss-eap-openshift docker image and adds support for the Oracle JDBC driver as a jboss module


- Modified standalone-openshift.xml to include the Oracle Driver
- Modified s2i/run script to include type "ORACLE" datasource type.


time is passing by and a very  good read about s2i eap 7 image on openshift you can find here: 
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.3/html-single/getting_started_with_jboss_eap_for_openshift_container_platform/index#eap_s2i_process

Many of this instruction is not requried anymore.



# Service Discovery

Datasources are automatically created based on the value of some environment variables.

The most important is the DB_SERVICE_PREFIX_MAPPING environment variable which defines JNDI mappings for data sources. It must be set to a comma-separated list of <name>_<database_type>=<PREFIX> triplets, where name is used as the pool-name in the data source, database_type determines what database driver to use, and PREFIX is the prefix used in the names of environment variables, which are used to configure the data source.

For each <name>-<database_type>=PREFIX triplet in the DB_SERVICE_PREFIX_MAPPING environment variable, a separate datasource will be created by the launch script, which is executed when running the image.  
The <database_type> will determine the driver for the datasource.

The jboss_eap only supports postgresql and mysql, i added oracle.

Oracle pool/driver XA example  configuration:



                  <xa-datasource jndi-name="java:jboss/datasources/TodoListDS"
                    pool-name="todo_oracle-DB" enabled="true"
                    use-java-context="true">
                   <xa-datasource-property name="URL">jdbc:oracle:thin:@localhost:1521:XE</xa-datasource-property>
                    <driver>oracle</driver>
                     <xa-pool>
                        <min-pool-size>1</min-pool-size>
                        <max-pool-size>2</max-pool-size>
                      </xa-pool>
                      <security>
                       <user-name>system</user-name>
                        <password>oracle</password>
                        </security>
                  </xa-datasource>


                  <driver name="oracle" module="com.oracle">
                    <xa-datasource-class>oracle.jdbc.xa.client.OracleXADataSource</xa-datasource-class>
                  </driver>  

## Build image locally


      docker build -t majorov.biz/eap72 .


## Build and test s2i  image localy

Install the S2I tool from the Red Hat Software Collections repository:

      yum install source-to-image

Example of adding  XA oracle pool:



        s2i build -e DB_SERVICE_PREFIX_MAPPING=TODO-oracle=DB -e DB_DRIVER_NAME=oracle -e DB_USERNAME=system \
        -e DB_PASSWORD=oracle -e  DB_JNDI=java:jboss/datasources/TodoListDS  \
        -e DB_MIN_POOL_SIZE=1  -e DB_MAX_POOL_SIZE=2 \
        -e  DB_XA_CONNECTION_PROPERTY_URL=jdbc:oracle:thin:@localhost:1521:XE \
          https://github.com/nmajorov/html5-frontend-sso.git \
          majorov.biz/eap72  rh-eap72-app
